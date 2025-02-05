import random
import pandas as pd

system_message = """
You are an AI assistant designed to answer questions with the best of your knowledge.
Please restrict your answer to the exact question and use the exact answer format asked.
"""

def format_prompt(text, fea1, fea2, fea_df, type="pos_neg"):
    """Format prompt for LLM queries.
    
    Args:
        text (str): Input text to analyze
        fea1 (str): First feature
        fea2 (str): Second feature
        fea_df (pd.DataFrame): Features information
        type (str): Type of prompt ("pos_neg" or "pos_pos")
        
    Returns:
        str: Formatted prompt
    """
    fea_w_des1 = fea1 + " (" + str(fea_df.loc[fea1, 'description']) + ")"
    fea_w_des2 = fea2 + " (" + str(fea_df.loc[fea2, 'description']) + ")" 
    
    if type == "pos_neg":
        # engineer prompt for this 'pos_neg'pair
        prompt = f"In the provided paragraph, do you observe any strong association between topic '{fea_w_des1}' and topic '{fea_w_des2}'?\n"
        prompt += f"Respond in format: '[yes/no.] If yes, shortly describe the observed association. If no, only return no.'\n"
    
    if type == "pos_pos":
        # if fea 2 truly present in text, and fea2 is not inferred from fea1, putting the opposite of fea1 into the text, will give the same presence of fea2. 
        # inject the opposite instances of fea1 into the text
        fea1_oppo_examples = fea_df.loc[fea1, 'oppo_examples'].split(" (^_^) ")
        fea1_oppo_examples = random.sample(fea1_oppo_examples, 2)
        # random.shuffle(fea1_oppo_examples) # shuffle these examples
        text = text + " " + " ".join(fea1_oppo_examples[0:]) 
        prompt = f"Does the following paragraph mention '{fea_w_des2}'?\n"
        prompt += f"Respond in format: '[yes/no.] If yes, related phrases in the text. If no, only return no.'\n"
        
    
    paragragh_content = f"Paragraph: '{text}' \n"
    user_message = prompt + paragragh_content + "\n"
    
    return user_message



def get_pos_neg_matrix(sm_pos, sm_neg, raw_text,
                       tokenizer, model):
    # create a matrix / table alike object, where rownames are sm_pos, colnames are sm_neg, and the cell value is the response from the LLM
    response_matrix = pd.DataFrame(index=sm_pos, columns=sm_neg)
    
    for i in range(len(sm_pos)): 
        pos_fea = sm_pos[i]
        
        for j in range(len(sm_neg)):
            neg_fea = sm_neg[j]

            # get user message
            user_message = format_prompt(raw_text, pos_fea, neg_fea, type="pos_neg")
            user_message = "Question: " + user_message + " Answer:"
            inputs = tokenizer.apply_chat_template(
                [
                    {"role": "system", "content": system_message},
                    {"role": "user", "content": user_message}
                ],
                add_generation_prompt=False,
                return_dict=True,
                return_tensors="pt"
            )
            inputs.to(model.device)
            outputs = model.generate(**inputs,
                                     do_sample=True,
                                     max_new_tokens=512,
                                     temperature=0.1)
            response = tokenizer.decode(outputs[0], skip_special_tokens=True)
            response = response.split("assistant\n\n")[-1]
            response = response.replace("[", "").replace("]", "")
            response = response.strip()
            response = response.lower()
            if response.startswith("no"):
                response = "no."
            response_matrix.loc[pos_fea, neg_fea] = response
            del inputs
            del outputs
        
    return response_matrix

def get_pos_pos_matrix(sm_pos, raw_text,
                       tokenizer, model):
    response_matrix = pd.DataFrame(index=sm_pos, columns=sm_pos)
    for fea1 in sm_pos:
        for fea2 in sm_pos:
            if fea1 == fea2 : continue
            
            user_message = format_prompt(raw_text, fea1, fea2, type="pos_pos")
            user_message = "Question: " + user_message + " Answer:"
            inputs = tokenizer.apply_chat_template(
                [
                    {"role": "system", "content": system_message},
                    {"role": "user", "content": user_message}
                ],
                add_generation_prompt=False,
                return_dict=True,
                return_tensors="pt"
            )
            inputs.to(model.device)
            outputs = model.generate(**inputs,
                                     do_sample=True,
                                     max_new_tokens=512,
                                     temperature=0.1)
            response = tokenizer.decode(outputs[0], skip_special_tokens=True)
            response = response.split("assistant\n\n")[-1]
            response_matrix.loc[fea1, fea2] = response
            del inputs
            del outputs
    return response_matrix