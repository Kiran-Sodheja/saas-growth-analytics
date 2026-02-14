# SaaS Growth & GTM Analytics (MySQL, Python, Power BI)

# Overview
This project presents an end-to-end analysis of customer, subscription, and event-level data for a B2B SaaS company. The objective is to understand revenue performance, customer churn, funnel efficiency, and 
acquisition channel effectiveness using SQL, Python, and Power BI. The datasets contained missing values, duplicates, and inconsistent events, requiring data cleaning and documented assumptions.

# Tools Used
- MySQL – data cleaning, transformations, SaaS metrics, funnel analysis  
- Python (pandas, numpy) – data loading, validation, sanity checks  
- Power BI – dashboard and visualization

# Data Issues Identified
- Duplicate signup events for some customers  
- Inconsistent event naming (e.g., 'trial_start' vs 'trial')  
- Missing 'end_date' for active subscriptions  
- Date columns stored as text

# Data Cleaning & Assumptions
- Standardized 'event_type' values (signup, trial, activated, paid, churned)  
- Treated empty 'end_date' as active subscriptions  
- Converted date fields to DATE format in MySQL  
- Removed or deduplicated conflicting events where applicable

# Metric Definitions
- **MRR (Monthly Recurring Revenue):** Sum of `monthly_price` for active subscriptions per month  
- **ARR (Annual Recurring Revenue):** MRR × 12  
- **Logo Churn Rate:** Churned customers / customers active at start of month  
- **Revenue Churn Rate:** Lost MRR from churned customers / starting MRR  
- **ARPC (Average Revenue per Customer):** Total MRR / number of active customers

# Funnel Definition
Signup → Trial → Activated → Paid → Churned  
Conversion rates and drop-offs were calculated overall and segmented by acquisition source.

# Key Insights
- Significant drop-off observed between Signup → Trial and Trial → Activated  
- Organic and referral channels showed stronger activation compared to paid ads  
- Revenue growth driven primarily by higher-priced plans despite churn

# Dashboard
The Power BI dashboard includes:
- Monthly MRR trend  
- Funnel conversion overview  
- Churn metrics  
- Acquisition source breakdown  

Screenshots are available in the 'dashboard/' folder

