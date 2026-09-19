USE ecotrack_analytics;

-- 1. Latest sustainability + SaaS KPIs
WITH latest_month AS (
    SELECT MAX(Month) AS max_month FROM monthly_sustainability
)
SELECT
    ROUND(SUM(m.Total_CO2_kg)/1000,2) AS estimated_co2_tonnes,
    ROUND(SUM(m.MRR),2) AS current_mrr,
    ROUND(SUM(m.MRR)*12,2) AS current_arr,
    COUNT(DISTINCT m.Company_ID) AS active_companies
FROM monthly_sustainability m
JOIN latest_month l ON m.Month=l.max_month;

-- 2. Monthly emissions trend and month-over-month change
WITH monthly_emissions AS (
    SELECT Month, SUM(Total_CO2_kg)/1000 AS co2_tonnes
    FROM monthly_sustainability
    GROUP BY Month
), changes AS (
    SELECT Month, co2_tonnes,
           LAG(co2_tonnes) OVER (ORDER BY Month) AS previous_month
    FROM monthly_emissions
)
SELECT Month,
       ROUND(co2_tonnes,2) AS co2_tonnes,
       ROUND(100*(co2_tonnes-previous_month)/NULLIF(previous_month,0),2) AS mom_change_pct
FROM changes
ORDER BY Month;

-- 3. Latest emissions by source
WITH latest_month AS (SELECT MAX(Month) AS max_month FROM monthly_sustainability)
SELECT
    ROUND(SUM(Electricity_CO2_kg)/1000,2) AS electricity_tonnes,
    ROUND(SUM(Gas_CO2_kg)/1000,2) AS gas_tonnes,
    ROUND(SUM(Fuel_CO2_kg)/1000,2) AS fuel_tonnes,
    ROUND(SUM(Travel_CO2_kg)/1000,2) AS travel_tonnes,
    ROUND(SUM(Waste_CO2_kg)/1000,2) AS waste_tonnes
FROM monthly_sustainability m
JOIN latest_month l ON m.Month=l.max_month;

-- 4. Industry emissions intensity
WITH latest_month AS (SELECT MAX(Month) AS max_month FROM monthly_sustainability)
SELECT Industry,
       ROUND(SUM(Total_CO2_kg)/1000,2) AS co2_tonnes,
       SUM(Employees) AS employees,
       ROUND(SUM(Total_CO2_kg)/NULLIF(SUM(Employees),0),2) AS co2_kg_per_employee
FROM monthly_sustainability m
JOIN latest_month l ON m.Month=l.max_month
GROUP BY Industry
ORDER BY co2_tonnes DESC;

-- 5. Company reduction performance
SELECT Company_ID, Industry, Company_Size,
       Initial_CO2_kg, Latest_CO2_kg,
       Observed_Reduction_Pct,
       Reduction_Target_Pct,
       CASE
         WHEN Observed_Reduction_Pct >= Reduction_Target_Pct THEN 'Target Met'
         WHEN Observed_Reduction_Pct > 0 THEN 'Improving'
         ELSE 'Not Improving'
       END AS reduction_status
FROM companies
ORDER BY Observed_Reduction_Pct DESC;

-- 6. Platform engagement vs churn
SELECT
    CASE
      WHEN Avg_Monthly_Logins <= 2 THEN '0-2'
      WHEN Avg_Monthly_Logins <= 5 THEN '3-5'
      WHEN Avg_Monthly_Logins <= 8 THEN '6-8'
      WHEN Avg_Monthly_Logins <= 12 THEN '9-12'
      ELSE '13+'
    END AS login_band,
    COUNT(*) AS companies,
    ROUND(100.0*AVG(Churn_Flag),2) AS churn_rate_pct,
    ROUND(AVG(Observed_Reduction_Pct),2) AS avg_reduction_pct
FROM companies
GROUP BY login_band
ORDER BY MIN(Avg_Monthly_Logins);

-- 7. Churn by subscription plan and contract
SELECT Plan, Contract_Type,
       COUNT(*) AS companies,
       ROUND(100.0*AVG(Churn_Flag),2) AS churn_rate_pct,
       ROUND(AVG(Lifetime_Revenue),2) AS avg_lifetime_revenue
FROM companies
GROUP BY Plan, Contract_Type
ORDER BY churn_rate_pct DESC;

-- 8. Rank industries by latest emissions
WITH latest_month AS (SELECT MAX(Month) AS max_month FROM monthly_sustainability),
industry_emissions AS (
    SELECT Industry, SUM(Total_CO2_kg)/1000 AS co2_tonnes
    FROM monthly_sustainability m
    JOIN latest_month l ON m.Month=l.max_month
    GROUP BY Industry
)
SELECT Industry,
       ROUND(co2_tonnes,2) AS co2_tonnes,
       DENSE_RANK() OVER (ORDER BY co2_tonnes DESC) AS emissions_rank
FROM industry_emissions;

-- 9. Acquisition channel quality
SELECT Acquisition_Channel,
       COUNT(*) AS companies,
       ROUND(100.0*AVG(Churn_Flag),2) AS churn_rate_pct,
       ROUND(AVG(Lifetime_Revenue),2) AS avg_lifetime_revenue,
       ROUND(AVG(Observed_Reduction_Pct),2) AS avg_reduction_pct
FROM companies
GROUP BY Acquisition_Channel
ORDER BY avg_lifetime_revenue DESC;

-- 10. High-risk active accounts for customer success
SELECT Company_ID, Plan, Contract_Type,
       Avg_Monthly_Logins,
       Avg_Reports_Generated,
       Avg_Data_Completeness_Pct,
       Observed_Reduction_Pct,
       CASE
         WHEN Avg_Monthly_Logins <= 2
              AND Avg_Reports_Generated < 1
              AND Observed_Reduction_Pct <= 0 THEN 'High Risk'
         WHEN Avg_Monthly_Logins <= 5
              OR Avg_Data_Completeness_Pct < 70 THEN 'Medium Risk'
         ELSE 'Low Risk'
       END AS risk_segment
FROM companies
WHERE Churn_Status='Active';
