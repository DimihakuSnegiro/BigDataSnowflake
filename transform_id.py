import pandas as pd
import os

directory = r'./исходные данные'

for i in range(1, 10):
    filename = f'MOCK_DATA ({i}).csv'
    filepath = os.path.join(directory, filename)
    
    df = pd.read_csv(filepath)
    id_column = next((col for col in df.columns if col.lower() == 'id'), None)
    
    df[id_column] = df[id_column].astype(int) + i * 1000
    df.to_csv(filepath, index=False)