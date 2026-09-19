from pathlib import Path
import pandas as pd

ROOT=Path(__file__).resolve().parents[1]
companies=pd.read_csv(ROOT/'data/processed/companies_clean.csv')
monthly=pd.read_csv(ROOT/'data/processed/monthly_sustainability_clean.csv',parse_dates=['Month'])
latest_month=monthly['Month'].max()
latest=monthly[monthly['Month']==latest_month]

mrr=latest['MRR'].sum()
arr=mrr*12
active=latest['Company_ID'].nunique()
churn=companies['Churn_Flag'].mean()
emissions=latest['CO2_tonnes'].sum()

print(f'Latest month: {latest_month:%Y-%m}')
print(f'Estimated CO2: {emissions:,.2f} tonnes')
print(f'MRR: £{mrr:,.2f}')
print(f'ARR: £{arr:,.2f}')
print(f'Active companies: {active:,}')
print(f'Overall churn: {churn:.2%}')
