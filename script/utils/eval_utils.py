import pandas as pd
import matplotlib.pyplot as plt

def plot_precision_recall(res_df):
    """Plot precision and recall bars.
    
    Args:
        res_df (pd.DataFrame): DataFrame containing precision and recall values
    """
    fig, ax = plt.subplots(1, 2)
    ax[0].bar(res_df.index, res_df['precision'], color='blue')
    ax[0].set_title("precision")  
    ax[0].set_xticks([])
    ax[1].bar(res_df.index, res_df['recall'], color='red')
    ax[1].set_title("recall")  
    ax[1].set_xticks([])
    plt.show()

def plot_precision_recall_diff(res_df, res_df_old):
    fig, ax = plt.subplots(1, 2)
    ax[0].bar(res_df.index, res_df['precision'] - res_df_old['precision'], color='blue')
    ax[0].set_title("precision")  
    ax[0].set_xticks([])
    ax[1].bar(res_df.index, res_df['recall'] - res_df_old['recall'], color='red')
    ax[1].set_title("recall")  
    ax[1].set_xticks([])
    plt.show()


def check_precision_recall(label_df, label_df_human, fea_df, plot=True):
    """Calculate precision and recall metrics.
    
    Args:
        label_df (pd.DataFrame): LLM predictions
        label_df_human (pd.DataFrame): Human annotations
        fea_df (pd.DataFrame): Features information
        plot (bool): Whether to plot the results
        
    Returns:
        pd.DataFrame: DataFrame containing precision and recall for each feature
    """
    res_df = pd.DataFrame(index=fea_df.fea, columns=['precision', 'recall'])

    for col in fea_df.fea:
        true_positives = ((label_df.loc[:,col] == 1) & (label_df_human.loc[:,col] == 1)).sum()
        false_positives = ((label_df.loc[:,col] == 1) & (label_df_human.loc[:,col] == 0)).sum()
        false_negatives = ((label_df.loc[:,col] == 0) & (label_df_human.loc[:,col] == 1)).sum()
        
        precision = true_positives / (true_positives + false_positives) if (true_positives + false_positives) > 0 else 0
        recall = true_positives / (true_positives + false_negatives) if (true_positives + false_negatives) > 0 else 0
        
        res_df.loc[col, 'precision'] = precision
        res_df.loc[col, 'recall'] = recall  
        
    if plot:
        plot_precision_recall(res_df)
    return res_df 