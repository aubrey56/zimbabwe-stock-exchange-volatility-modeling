import numpy as np
import pandas as pd

def load_and_clean_data(filepath):
    # Load raw ZSE CSV dataset
    df = pd.read_csv(filepath)
    df['Date'] = pd.to_datetime(df['Date'], format='%m/%d/%Y')
    df['Price'] = df['Price'].astype(str).str.replace(',', '').astype(float)
    df = df.sort_values('Date').reset_index(drop=True)
    
    # Calculate daily logarithmic returns
    df['Log_Return'] = np.log(df['Price'] / df['Price'].shift(1))
    df_clean = df.dropna(subset=['Log_Return']).copy()
    
    return df_clean

if __name__ == "__main__":
    df = load_and_clean_data('data/raw/ZSE All Share Historical Data.csv')
    df.to_csv('data/processed/zse_clean_returns.csv', index=False)
    print(f"Data preprocessed successfully. Total observations: {len(df)}")
