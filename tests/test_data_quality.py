from pathlib import Path
import pandas as pd
ROOT=Path(__file__).resolve().parents[1]
C=ROOT/'data/processed/companies_clean.csv'; M=ROOT/'data/processed/monthly_sustainability_clean.csv'
def test_unique_companies():
    df=pd.read_csv(C); assert df['Company_ID'].is_unique
def test_unique_company_months():
    df=pd.read_csv(M); assert not df.duplicated(['Company_ID','Month']).any()
def test_positive_activity():
    df=pd.read_csv(M); assert (df['Electricity_kWh']>=0).all(); assert (df['Total_CO2_kg']>=0).all()
def test_binary_churn():
    df=pd.read_csv(C); assert set(df['Churn_Flag'].unique()).issubset({0,1})
def test_emissions_sum():
    df=pd.read_csv(M); parts=df[['Electricity_CO2_kg','Gas_CO2_kg','Fuel_CO2_kg','Travel_CO2_kg','Waste_CO2_kg']].sum(axis=1); assert ((parts-df['Total_CO2_kg']).abs()<0.06).all()
