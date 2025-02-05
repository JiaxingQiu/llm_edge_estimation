import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

def setup_model(model_name):
    """Initialize and setup the LLM model and tokenizer.
    
    Args:
        model_name (str): Name or path of the model to load
        
    Returns:
        tuple: (model, tokenizer)
    """
    # Clear GPU cache
    if torch.cuda.is_available():
        torch.cuda.empty_cache()
    device = 0 if torch.cuda.is_available() else -1

    # Load the model
    model = AutoModelForCausalLM.from_pretrained(
        model_name,                   
        return_dict=True,
        low_cpu_mem_usage=True,
        torch_dtype=torch.float16,
        device_map="auto" if device == 0 else None,
        trust_remote_code=True
    )

    tokenizer = AutoTokenizer.from_pretrained(model_name)
    return model, tokenizer