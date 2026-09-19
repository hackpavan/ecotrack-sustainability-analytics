# EcoTrack — Plain-English Learning Guide

## 1. What is EcoTrack?

EcoTrack is a **fictional Sustainability SaaS platform** for businesses.

- **SaaS** means Software as a Service: companies pay a recurring subscription to use software.
- **Sustainability analytics** means using data to understand resource consumption and environmental impact.

EcoTrack helps businesses track activity such as:

- electricity use
- gas use
- fuel use
- business travel
- waste
- water consumption

The project then estimates CO₂ emissions from those activities and tracks whether companies are reducing them over time.

> **Important:** The emissions conversion factors in this portfolio project are illustrative synthetic assumptions. They are not official government or regulatory carbon-accounting factors and should not be used for real emissions reporting.

## 2. The fictional business model

EcoTrack has four subscription plans:

| Plan | Monthly fee |
|---|---:|
| Starter | £39 |
| Professional | £99 |
| Business | £249 |
| Enterprise | £699 |

Customers use the platform to upload sustainability data, create reports, set reduction targets and view recommendations.

## 3. Two sides of the analysis

### A. Sustainability analytics

We ask:

- How much estimated CO₂ is produced?
- Which emission source contributes the most?
- Which industries have the highest emissions?
- Are companies reducing emissions over time?
- What is CO₂ per employee?

### B. SaaS / product analytics

We also ask:

- What is MRR?
- What is ARR?
- What is customer churn?
- Do highly engaged customers churn less?
- Which plans and contracts retain customers better?

This combination makes the project different from a normal dashboard project.

## 4. How estimated emissions are calculated

EcoTrack takes business activity and multiplies it by an **illustrative emissions factor**.

Example:

```text
Electricity usage = 10,000 kWh
Illustrative factor = 0.19 kg CO₂ per kWh
Estimated electricity emissions = 10,000 × 0.19 = 1,900 kg CO₂
```

The project does the same for gas, fuel, travel and waste.

```text
Total estimated CO₂ =
Electricity CO₂
+ Gas CO₂
+ Fuel CO₂
+ Travel CO₂
+ Waste CO₂
```

Water is tracked as an operational sustainability metric but is not included in this project's simplified CO₂ total.

## 5. Main sustainability KPIs

### Total CO₂
Estimated emissions across all tracked companies.

Latest synthetic month: **7,258 tonnes CO₂**.

### Emissions reduction %

```text
Reduction % =
(Baseline emissions - Current emissions)
/ Baseline emissions × 100
```

The average reduction among currently active companies is approximately **4.6%**.

### CO₂ per employee

```text
CO₂ per employee = Total CO₂ / Number of employees
```

This helps compare companies of different sizes more fairly.

## 6. Main SaaS KPIs

### MRR — Monthly Recurring Revenue
Recurring subscription revenue in one month.

Current synthetic MRR: **£217,332**.

### ARR — Annual Recurring Revenue

```text
ARR = MRR × 12
```

Current synthetic ARR: **£2,607,984**.

### Churn
A customer churns when they stop subscribing.

Overall synthetic churn: **25.2%**.

### Product engagement
EcoTrack measures:

- monthly logins
- reports generated
- reduction targets set
- recommendations viewed
- data completeness

We analyse whether companies with low engagement have higher churn.

## 7. How the dataset was designed

The project contains two main datasets.

### `companies_clean.csv`
One row per customer/company.

It contains company details, subscription details, observed emissions reduction and churn status.

### `monthly_sustainability_clean.csv`
One row per company per active month.

It contains resource usage, estimated CO₂, product engagement and recurring revenue.

That second dataset makes time-series and cohort analysis possible.

## 8. What the analyst does

1. Inspect raw data quality.
2. Remove duplicate records.
3. Standardise categorical fields.
4. Calculate emissions metrics.
5. Calculate MRR, ARR and churn.
6. Analyse emissions by source and industry.
7. Compare platform engagement with churn.
8. Analyse customer retention by signup cohort.
9. Build a dashboard.
10. Turn the findings into business recommendations.

## 9. How to explain EcoTrack in an interview

> “I built EcoTrack, a synthetic sustainability SaaS analytics project. I modelled business resource usage such as electricity, fuel, travel and waste and converted those activities into illustrative CO₂ estimates. I then combined that with subscription and product-engagement data to analyse MRR, churn, retention and whether platform engagement was associated with customer retention. I used Python for data preparation, SQL for business analysis and an interactive dashboard for communication.”

## 10. What not to claim

Do **not** say the emissions numbers are real company emissions or official carbon-accounting results.

A good phrase is:

> “The dataset and emissions factors are synthetic and designed to demonstrate analytics techniques.”
