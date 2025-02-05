import pandas as pd

def load_and_process_labels(data_path, llmname, fea_path):
    """Load and process label data from CSV files.
    
    Args:
        data_path (str): Path to the main data CSV file
        llmname (str): Name of the LLM model
        fea_path (str): Path to the features CSV file
        
    Returns:
        tuple: (label_df, label_df_human, fea_df)
    """
    label_df_org = pd.read_csv(data_path)
    fea_df = pd.read_csv(fea_path)
    
    # Process LLM labels
    label_df = label_df_org.copy()
    # in pandas, select columns that name starts with "llama_" and ends with "01"
    llm_columns = label_df.filter(regex=f'^{llmname}_.*01$')
    # remove prefix llmname and suffix '01' from column names
    llm_columns.columns = llm_columns.columns.str.replace(f'{llmname}_', '').str.replace('01', '')
    # select columns whose names are in fea_df.fea
    llm_columns = llm_columns.loc[:, llm_columns.columns.isin(fea_df.fea)]
    # concat with label_df
    label_df = pd.concat([label_df[['sm_id', 'raw_text']], llm_columns], axis=1)
    label_df = label_df.set_index('sm_id', drop=False) # assign sm_id as row index
    fea_df = fea_df.set_index('fea', drop=False)

    
    # Process human labels
    label_df_human = label_df_org.copy()
    human_columns = label_df_human.filter(regex='^human_.*01$')
    # remove prefix llmname and suffix '01' from column names
    human_columns.columns = human_columns.columns.str.replace('human_', '').str.replace('01', '')
    # select columns whose names are in fea_df.fea
    human_columns = human_columns.loc[:, human_columns.columns.isin(fea_df.fea)]
    # concat with label_df
    label_df_human = pd.concat([label_df_human[['sm_id']], human_columns], axis=1)
    label_df_human = label_df_human.set_index('sm_id', drop=False) # assign sm_id as row index

    return label_df, label_df_human, fea_df 