from pathlib import Path
import pandas as pd

ROOT=Path(__file__).resolve().parents[1]
companies=pd.read_csv(ROOT/'data/raw/companies.csv')
monthly=pd.read_csv(ROOT/'data/raw/monthly_sustainability.csv')

for col in ['Industry','Country','Company_Size','Plan','Contract_Type','Acquisition_Channel','Churn_Status']:
    companies[col]=companies[col].astype('string').str.strip()
companies['Industry']=companies['Industry'].fillna('Unknown')
companies['Acquisition_Channel']=companies['Acquisition_Channel'].fillna('Unknown')
companies['Signup_Date']=pd.to_datetime(companies['Signup_Date'])
companies['Churn_Date']=pd.to_datetime(companies['Churn_Date'],errors='coerce')
companies=companies.drop_duplicates('Company_ID').reset_index(drop=True)
companies['Churn_Flag']=(companies['Churn_Status']=='Churned').astype(int)
companies['Signup_Month']=companies['Signup_Date'].dt.to_period('M').astype(str)
companies['Annualised_Revenue']=companies['Monthly_Fee']*12

for col in ['Industry','Country','Company_Size','Plan','Contract_Type','Acquisition_Channel']:
    monthly[col]=monthly[col].astype('string').str.strip()
monthly['Month']=pd.to_datetime(monthly['Month'])
monthly=monthly.drop_duplicates(['Company_ID','Month']).reset_index(drop=True)
monthly['CO2_tonnes']=monthly['Total_CO2_kg']/1000
monthly['CO2_per_Employee_kg']=monthly['Total_CO2_kg']/monthly['Employees']

companies.to_csv(ROOT/'data/processed/companies_clean.csv',index=False)
monthly.to_csv(ROOT/'data/processed/monthly_sustainability_clean.csv',index=False)
print(f'Clean companies: {len(companies):,}')
print(f'Clean company-month rows: {len(monthly):,}')
