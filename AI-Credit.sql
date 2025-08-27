-- =============================================
-- SME Credit Scoring Analysis - Complete SQL Query
-- Matching the analysis from the technical report
-- =============================================

-- Create the main dataset table
CREATE TABLE IF NOT EXISTS sme_credit_data (
    business_id VARCHAR(20),
    business_type VARCHAR(50),
    location_type VARCHAR(20),
    years_in_business DECIMAL(4,2),
    num_employees INT,
    owner_gender VARCHAR(10),
    owner_age DECIMAL(4,1),
    education_level INT,
    monthly_revenue DECIMAL(12,2),
    monthly_expenses DECIMAL(12,2),
    cash_flow_volatility DECIMAL(5,2),
    mobile_money_frequency DECIMAL(6,1),
    mobile_money_volume DECIMAL(10,1),
    mobile_money_consistency DECIMAL(4,2),
    has_bank_account INT,
    bank_account_age DECIMAL(4,1),
    savings_balance DECIMAL(12,2),
    num_suppliers INT,
    num_customers INT,
    digital_payment_adoption DECIMAL(4,2),
    social_media_presence INT,
    mobile_money_score DECIMAL(4,2),
    business_score DECIMAL(4,2),
    banking_score DECIMAL(4,2),
    digital_score DECIMAL(4,2),
    demo_score DECIMAL(4,2),
    credit_score DECIMAL(4,2),
    traditional_score DECIMAL(4,2),
    traditional_approval INT,
    ai_approval INT,
    actually_creditworthy INT
);

-- =============================================
-- 1. DEMOGRAPHIC ANALYSIS
-- =============================================

-- Gender distribution by creditworthiness
SELECT 
    'Gender Distribution Analysis' as analysis_type,
    owner_gender,
    COUNT(*) as total_businesses,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sme_credit_data), 2) as percentage,
    SUM(actually_creditworthy) as creditworthy_count,
    ROUND(AVG(actually_creditworthy) * 100, 2) as creditworthy_rate,
    ROUND(AVG(credit_score), 3) as avg_credit_score,
    ROUND(AVG(traditional_score), 3) as avg_traditional_score
FROM sme_credit_data
GROUP BY owner_gender
ORDER BY total_businesses DESC;

-- Age group analysis
SELECT 
    'Age Group Analysis' as analysis_type,
    CASE 
        WHEN owner_age < 25 THEN 'Under 25'
        WHEN owner_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN owner_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN owner_age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END as age_group,
    COUNT(*) as total_businesses,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sme_credit_data), 2) as percentage,
    SUM(actually_creditworthy) as creditworthy_count,
    ROUND(AVG(actually_creditworthy) * 100, 2) as creditworthy_rate,
    ROUND(AVG(credit_score), 3) as avg_credit_score,
    ROUND(AVG(demo_score), 3) as avg_demo_score
FROM sme_credit_data
GROUP BY 
    CASE 
        WHEN owner_age < 25 THEN 'Under 25'
        WHEN owner_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN owner_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN owner_age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END
ORDER BY 
    CASE 
        WHEN age_group = 'Under 25' THEN 1
        WHEN age_group = '25-34' THEN 2
        WHEN age_group = '35-44' THEN 3
        WHEN age_group = '45-54' THEN 4
        ELSE 5
    END;

-- Education level impact
SELECT 
    'Education Level Analysis' as analysis_type,
    education_level,
    CASE education_level
        WHEN 1 THEN 'Primary'
        WHEN 2 THEN 'Secondary'
        WHEN 3 THEN 'Tertiary'
        WHEN 4 THEN 'Higher'
    END as education_description,
    COUNT(*) as total_businesses,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sme_credit_data), 2) as percentage,
    SUM(actually_creditworthy) as creditworthy_count,
    ROUND(AVG(actually_creditworthy) * 100, 2) as creditworthy_rate,
    ROUND(AVG(demo_score), 3) as avg_demo_score,
    ROUND(AVG(credit_score), 3) as avg_credit_score
FROM sme_credit_data
GROUP BY education_level
ORDER BY education_level;

-- =============================================
-- 2. BUSINESS CHARACTERISTICS ANALYSIS
-- =============================================

-- Business type distribution
SELECT 
    'Business Type Analysis' as analysis_type,
    business_type,
    COUNT(*) as total_businesses,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sme_credit_data), 2) as percentage,
    SUM(actually_creditworthy) as creditworthy_count,
    ROUND(AVG(actually_creditworthy) * 100, 2) as creditworthy_rate,
    ROUND(AVG(business_score), 3) as avg_business_score,
    ROUND(AVG(monthly_revenue), 0) as avg_monthly_revenue,
    ROUND(AVG(credit_score), 3) as avg_credit_score
FROM sme_credit_data
GROUP BY business_type
ORDER BY total_businesses DESC;

-- Location type analysis
SELECT 
    'Location Type Analysis' as analysis_type,
    location_type,
    COUNT(*) as total_businesses,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sme_credit_data), 2) as percentage,
    SUM(actually_creditworthy) as creditworthy_count,
    ROUND(AVG(actually_creditworthy) * 100, 2) as creditworthy_rate,
    ROUND(AVG(business_score), 3) as avg_business_score,
    ROUND(AVG(digital_score), 3) as avg_digital_score,
    ROUND(AVG(credit_score), 3) as avg_credit_score
FROM sme_credit_data
GROUP BY location_type
ORDER BY total_businesses DESC;

-- Business maturity analysis
SELECT 
    'Business Maturity Analysis' as analysis_type,
    CASE 
        WHEN years_in_business < 1 THEN 'Less than 1 year'
        WHEN years_in_business BETWEEN 1 AND 2.99 THEN '1-3 years'
        WHEN years_in_business BETWEEN 3 AND 5.99 THEN '3-6 years'
        ELSE '6+ years'
    END as business_maturity,
    COUNT(*) as total_businesses,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sme_credit_data), 2) as percentage,
    SUM(actually_creditworthy) as creditworthy_count,
    ROUND(AVG(actually_creditworthy) * 100, 2) as creditworthy_rate,
    ROUND(AVG(years_in_business), 2) as avg_years_in_business,
    ROUND(AVG(business_score), 3) as avg_business_score,
    ROUND(AVG(credit_score), 3) as avg_credit_score
FROM sme_credit_data
GROUP BY 
    CASE 
        WHEN years_in_business < 1 THEN 'Less than 1 year'
        WHEN years_in_business BETWEEN 1 AND 2.99 THEN '1-3 years'
        WHEN years_in_business BETWEEN 3 AND 5.99 THEN '3-6 years'
        ELSE '6+ years'
    END
ORDER BY 
    CASE 
        WHEN business_maturity = 'Less than 1 year' THEN 1
        WHEN business_maturity = '1-3 years' THEN 2
        WHEN business_maturity = '3-6 years' THEN 3
        ELSE 4
    END;

-- =============================================
-- 3. FINANCIAL PERFORMANCE ANALYSIS
-- =============================================

-- Revenue analysis by quartiles
WITH revenue_quartiles AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY monthly_revenue) as revenue_quartile
    FROM sme_credit_data
)
SELECT 
    'Revenue Quartile Analysis' as analysis_type,
    revenue_quartile,
    CASE revenue_quartile
        WHEN 1 THEN 'Q1 (Lowest)'
        WHEN 2 THEN 'Q2 (Low-Medium)'
        WHEN 3 THEN 'Q3 (Medium-High)'
        WHEN 4 THEN 'Q4 (Highest)'
    END as quartile_description,
    COUNT(*) as total_businesses,
    ROUND(MIN(monthly_revenue), 0) as min_revenue,
    ROUND(MAX(monthly_revenue), 0) as max_revenue,
    ROUND(AVG(monthly_revenue), 0) as avg_revenue,
    SUM(actually_creditworthy) as creditworthy_count,
    ROUND(AVG(actually_creditworthy) * 100, 2) as creditworthy_rate,
    ROUND(AVG(credit_score), 3) as avg_credit_score
FROM revenue_quartiles
GROUP BY revenue_quartile, quartile_description
ORDER BY revenue_quartile;

-- Cash flow volatility impact
SELECT 
    'Cash Flow Volatility Analysis' as analysis_type,
    CASE 
        WHEN cash_flow_volatility < 0.2 THEN 'Low Volatility (< 0.2)'
        WHEN cash_flow_volatility BETWEEN 0.2 AND 0.5 THEN 'Medium Volatility (0.2-0.5)'
        WHEN cash_flow_volatility BETWEEN 0.5 AND 1.0 THEN 'High Volatility (0.5-1.0)'
        ELSE 'Very High Volatility (> 1.0)'
    END as volatility_category,
    COUNT(*) as total_businesses,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sme_credit_data), 2) as percentage,
    ROUND(AVG(cash_flow_volatility), 3) as avg_volatility,
    SUM(actually_creditworthy) as creditworthy_count,
    ROUND(AVG(actually_creditworthy) * 100, 2) as creditworthy_rate,
    ROUND(AVG(credit_score), 3) as avg_credit_score
FROM sme_credit_data
GROUP BY 
    CASE 
        WHEN cash_flow_volatility < 0.2 THEN 'Low Volatility (< 0.2)'
        WHEN cash_flow_volatility BETWEEN 0.2 AND 0.5 THEN 'Medium Volatility (0.2-0.5)'
        WHEN cash_flow_volatility BETWEEN 0.5 AND 1.0 THEN 'High Volatility (0.5-1.0)'
        ELSE 'Very High Volatility (> 1.0)'
    END
ORDER BY 
    CASE 
        WHEN volatility_category = 'Low Volatility (< 0.2)' THEN 1
        WHEN volatility_category = 'Medium Volatility (0.2-0.5)' THEN 2
        WHEN volatility_category = 'High Volatility (0.5-1.0)' THEN 3
        ELSE 4
    END;

-- =============================================
-- 4. DIGITAL FINANCIAL INCLUSION ANALYSIS
-- =============================================

-- Mobile money usage analysis
SELECT 
    'Mobile Money Usage Analysis' as analysis_type,
    CASE 
        WHEN mobile_money_frequency = 0 THEN 'No Usage'
        WHEN mobile_money_frequency BETWEEN 1 AND 10 THEN 'Low Usage (1-10/month)'
        WHEN mobile_money_frequency BETWEEN 11 AND 30 THEN 'Medium Usage (11-30/month)'
        WHEN mobile_money_frequency BETWEEN 31 AND 60 THEN 'High Usage (31-60/month)'
        ELSE 'Very High Usage (60+/month)'
    END as usage_category,
    COUNT(*) as total_businesses,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sme_credit_data), 2) as percentage,
    ROUND(AVG(mobile_money_frequency), 1) as avg_frequency,
    ROUND(AVG(mobile_money_volume), 0) as avg_volume,
    ROUND(AVG(mobile_money_consistency), 3) as avg_consistency,
    ROUND(AVG(mobile_money_score), 3) as avg_mobile_score,
    SUM(actually_creditworthy) as creditworthy_count,
    ROUND(AVG(actually_creditworthy) * 100, 2) as creditworthy_rate
FROM sme_credit_data
GROUP BY 
    CASE 
        WHEN mobile_money_frequency = 0 THEN 'No Usage'
        WHEN mobile_money_frequency BETWEEN 1 AND 10 THEN 'Low Usage (1-10/month)'
        WHEN mobile_money_frequency BETWEEN 11 AND 30 THEN 'Medium Usage (11-30/month)'
        WHEN mobile_money_frequency BETWEEN 31 AND 60 THEN 'High Usage (31-60/month)'
        ELSE 'Very High Usage (60+/month)'
    END
ORDER BY 
    CASE 
        WHEN usage_category = 'No Usage' THEN 1
        WHEN usage_category = 'Low Usage (1-10/month)' THEN 2
        WHEN usage_category = 'Medium Usage (11-30/month)' THEN 3
        WHEN usage_category = 'High Usage (31-60/month)' THEN 4
        ELSE 5
    END;

-- Banking relationship analysis
SELECT 
    'Banking Relationship Analysis' as analysis_type,
    CASE has_bank_account
        WHEN 1 THEN 'Has Bank Account'
        ELSE 'No Bank Account'
    END as banking_status,
    COUNT(*) as total_businesses,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sme_credit_data), 2) as percentage,
    ROUND(AVG(CASE WHEN has_bank_account = 1 THEN bank_account_age ELSE 0 END), 2) as avg_account_age,
    ROUND(AVG(CASE WHEN has_bank_account = 1 THEN savings_balance ELSE 0 END), 0) as avg_savings_balance,
    ROUND(AVG(banking_score), 3) as avg_banking_score,
    SUM(actually_creditworthy) as creditworthy_count,
    ROUND(AVG(actually_creditworthy) * 100, 2) as creditworthy_rate,
    ROUND(AVG(credit_score), 3) as avg_credit_score
FROM sme_credit_data
GROUP BY has_bank_account
ORDER BY has_bank_account DESC;

-- Digital payment adoption analysis
SELECT 
    'Digital Payment Adoption Analysis' as analysis_type,
    CASE 
        WHEN digital_payment_adoption = 0 THEN 'No Digital Payments'
        WHEN digital_payment_adoption BETWEEN 0.01 AND 0.25 THEN 'Low Adoption (0-25%)'
        WHEN digital_payment_adoption BETWEEN 0.26 AND 0.50 THEN 'Medium Adoption (26-50%)'
        WHEN digital_payment_adoption BETWEEN 0.51 AND 0.75 THEN 'High Adoption (51-75%)'
        ELSE 'Very High Adoption (76-100%)'
    END as adoption_category,
    COUNT(*) as total_businesses,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sme_credit_data), 2) as percentage,
    ROUND(AVG(digital_payment_adoption), 3) as avg_adoption_rate,
    ROUND(AVG(digital_score), 3) as avg_digital_score,
    SUM(actually_creditworthy) as creditworthy_count,
    ROUND(AVG(actually_creditworthy) * 100, 2) as creditworthy_rate,
    ROUND(AVG(credit_score), 3) as avg_credit_score
FROM sme_credit_data
GROUP BY 
    CASE 
        WHEN digital_payment_adoption = 0 THEN 'No Digital Payments'
        WHEN digital_payment_adoption BETWEEN 0.01 AND 0.25 THEN 'Low Adoption (0-25%)'
        WHEN digital_payment_adoption BETWEEN 0.26 AND 0.50 THEN 'Medium Adoption (26-50%)'
        WHEN digital_payment_adoption BETWEEN 0.51 AND 0.75 THEN 'High Adoption (51-75%)'
        ELSE 'Very High Adoption (76-100%)'
    END
ORDER BY 
    CASE 
        WHEN adoption_category = 'No Digital Payments' THEN 1
        WHEN adoption_category = 'Low Adoption (0-25%)' THEN 2
        WHEN adoption_category = 'Medium Adoption (26-50%)' THEN 3
        WHEN adoption_category = 'High Adoption (51-75%)' THEN 4
        ELSE 5
    END;

-- =============================================
-- 5. CREDIT SCORING COMPONENT ANALYSIS
-- =============================================

-- Component score distribution analysis
SELECT 
    'Credit Score Components Analysis' as analysis_type,
    ROUND(AVG(mobile_money_score), 3) as avg_mobile_money_score,
    ROUND(AVG(business_score), 3) as avg_business_score,
    ROUND(AVG(banking_score), 3) as avg_banking_score,
    ROUND(AVG(digital_score), 3) as avg_digital_score,
    ROUND(AVG(demo_score), 3) as avg_demo_score,
    ROUND(AVG(credit_score), 3) as avg_overall_credit_score,
    ROUND(AVG(traditional_score), 3) as avg_traditional_score,
    COUNT(*) as total_businesses
FROM sme_credit_data;

-- Score correlation analysis
SELECT 
    'Score Correlation Analysis' as analysis_type,
    'Mobile Money vs Credit Score' as comparison,
    ROUND(
        (COUNT(*) * SUM(mobile_money_score * credit_score) - SUM(mobile_money_score) * SUM(credit_score)) /
        SQRT((COUNT(*) * SUM(mobile_money_score * mobile_money_score) - SUM(mobile_money_score) * SUM(mobile_money_score)) *
             (COUNT(*) * SUM(credit_score * credit_score) - SUM(credit_score) * SUM(credit_score))), 3
    ) as correlation_coefficient
FROM sme_credit_data
WHERE mobile_money_score > 0 AND credit_score > 0

UNION ALL

SELECT 
    'Score Correlation Analysis' as analysis_type,
    'Digital Score vs Credit Score' as comparison,
    ROUND(
        (COUNT(*) * SUM(digital_score * credit_score) - SUM(digital_score) * SUM(credit_score)) /
        SQRT((COUNT(*) * SUM(digital_score * digital_score) - SUM(digital_score) * SUM(digital_score)) *
             (COUNT(*) * SUM(credit_score * credit_score) - SUM(credit_score) * SUM(credit_score))), 3
    ) as correlation_coefficient
FROM sme_credit_data
WHERE digital_score > 0 AND credit_score > 0;

-- =============================================
-- 6. MODEL PERFORMANCE COMPARISON
-- =============================================

-- Traditional vs AI model performance
SELECT 
    'Model Performance Comparison' as analysis_type,
    'Traditional Model' as model_type,
    COUNT(*) as total_evaluations,
    SUM(traditional_approval) as total_approvals,
    ROUND(AVG(traditional_approval) * 100, 2) as approval_rate,
    SUM(CASE WHEN traditional_approval = 1 AND actually_creditworthy = 1 THEN 1 ELSE 0 END) as true_positives,
    SUM(CASE WHEN traditional_approval = 0 AND actually_creditworthy = 0 THEN 1 ELSE 0 END) as true_negatives,
    SUM(CASE WHEN traditional_approval = 1 AND actually_creditworthy = 0 THEN 1 ELSE 0 END) as false_positives,
    SUM(CASE WHEN traditional_approval = 0 AND actually_creditworthy = 1 THEN 1 ELSE 0 END) as false_negatives,
    ROUND(
        (SUM(CASE WHEN traditional_approval = 1 AND actually_creditworthy = 1 THEN 1 ELSE 0 END) + 
         SUM(CASE WHEN traditional_approval = 0 AND actually_creditworthy = 0 THEN 1 ELSE 0 END)) * 100.0 / COUNT(*), 2
    ) as accuracy_rate
FROM sme_credit_data

UNION ALL

SELECT 
    'Model Performance Comparison' as analysis_type,
    'AI Model' as model_type,
    COUNT(*) as total_evaluations,
    SUM(ai_approval) as total_approvals,
    ROUND(AVG(ai_approval) * 100, 2) as approval_rate,
    SUM(CASE WHEN ai_approval = 1 AND actually_creditworthy = 1 THEN 1 ELSE 0 END) as true_positives,
    SUM(CASE WHEN ai_approval = 0 AND actually_creditworthy = 0 THEN 1 ELSE 0 END) as true_negatives,
    SUM(CASE WHEN ai_approval = 1 AND actually_creditworthy = 0 THEN 1 ELSE 0 END) as false_positives,
    SUM(CASE WHEN ai_approval = 0 AND actually_creditworthy = 1 THEN 1 ELSE 0 END) as false_negatives,
    ROUND(
        (SUM(CASE WHEN ai_approval = 1 AND actually_creditworthy = 1 THEN 1 ELSE 0 END) + 
         SUM(CASE WHEN ai_approval = 0 AND actually_creditworthy = 0 THEN 1 ELSE 0 END)) * 100.0 / COUNT(*), 2
    ) as accuracy_rate
FROM sme_credit_data;

-- =============================================
-- 7. KEY INSIGHTS AND SUMMARY STATISTICS
-- =============================================

-- Overall dataset summary
SELECT 
    'Dataset Summary Statistics' as analysis_type,
    COUNT(*) as total_businesses,
    COUNT(DISTINCT business_type) as unique_business_types,
    COUNT(DISTINCT location_type) as unique_locations,
    ROUND(AVG(owner_age), 1) as avg_owner_age,
    ROUND(AVG(years_in_business), 2) as avg_years_in_business,
    ROUND(AVG(num_employees), 1) as avg_employees,
    ROUND(AVG(monthly_revenue), 0) as avg_monthly_revenue,
    SUM(actually_creditworthy) as total_creditworthy,
    ROUND(AVG(actually_creditworthy) * 100, 2) as overall_creditworthy_rate,
    ROUND(AVG(credit_score), 3) as avg_ai_credit_score,
    ROUND(AVG(traditional_score), 3) as avg_traditional_score,
    SUM(has_bank_account) as businesses_with_bank_accounts,
    ROUND(AVG(has_bank_account) * 100, 2) as bank_account_penetration,
    SUM(social_media_presence) as businesses_with_social_media,
    ROUND(AVG(social_media_presence) * 100, 2) as social_media_penetration
FROM sme_credit_data;

-- Financial inclusion gaps analysis
SELECT 
    'Financial Inclusion Gaps' as analysis_type,
    location_type,
    owner_gender,
    COUNT(*) as total_businesses,
    ROUND(AVG(has_bank_account) * 100, 2) as bank_account_rate,
    ROUND(AVG(mobile_money_frequency), 1) as avg_mobile_money_usage,
    ROUND(AVG(digital_payment_adoption) * 100, 2) as digital_payment_rate,
    ROUND(AVG(credit_score), 3) as avg_credit_score,
    ROUND(AVG(actually_creditworthy) * 100, 2) as creditworthy_rate
FROM sme_credit_data
GROUP BY location_type, owner_gender
ORDER BY location_type, owner_gender;

-- Business performance by characteristics
SELECT 
    'Business Performance Analysis' as analysis_type,
    business_type,
    location_type,
    COUNT(*) as businesses,
    ROUND(AVG(monthly_revenue), 0) as avg_revenue,
    ROUND(AVG(cash_flow_volatility), 3) as avg_cash_volatility,
    ROUND(AVG(num_customers), 1) as avg_customers,
    ROUND(AVG(num_suppliers), 1) as avg_suppliers,
    ROUND(AVG(credit_score), 3) as avg_credit_score,
    ROUND(AVG(actually_creditworthy) * 100, 2) as creditworthy_rate
FROM sme_credit_data
GROUP BY business_type, location_type
ORDER BY business_type, location_type;

-- High-performing business characteristics
SELECT 
    'High-Performing Business Characteristics' as analysis_type,
    'Top 20% Credit Scores' as segment,
    COUNT(*) as businesses,
    ROUND(AVG(credit_score), 3) as avg_credit_score,
    ROUND(MIN(credit_score), 3) as min_credit_score_in_segment,
    ROUND(AVG(monthly_revenue), 0) as avg_revenue,
    ROUND(AVG(years_in_business), 2) as avg_business_age,
    ROUND(AVG(owner_age), 1) as avg_owner_age,
    ROUND(AVG(has_bank_account) * 100, 2) as bank_account_rate,
    ROUND(AVG(mobile_money_score), 3) as avg_mobile_score,
    ROUND(AVG(digital_score), 3) as avg_digital_score,
    ROUND(AVG(actually_creditworthy) * 100, 2) as actual_creditworthy_rate
FROM (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY credit_score DESC) as rank,
           COUNT(*) OVER () as total_count
    FROM sme_credit_data
) ranked
WHERE rank <= CEILING(total_count * 0.2);

-- =============================================
-- 8. RISK ASSESSMENT MATRIX
-- =============================================

-- Risk matrix by business characteristics
SELECT 
    'Risk Assessment Matrix' as analysis_type,
    business_type,
    CASE 
        WHEN monthly_revenue < 10000 THEN 'Low Revenue'
        WHEN monthly_revenue BETWEEN 10000 AND 25000 THEN 'Medium Revenue'
        ELSE 'High Revenue'
    END as revenue_category,
    CASE 
        WHEN cash_flow_volatility < 0.3 THEN 'Low Risk'
        WHEN cash_flow_volatility BETWEEN 0.3 AND 0.7 THEN 'Medium Risk'
        ELSE 'High Risk'
    END as volatility_risk,
    COUNT(*) as businesses,
    ROUND(AVG(credit_score), 3) as avg_credit_score,
    ROUND(AVG(actually_creditworthy) * 100, 2) as creditworthy_rate,
    ROUND(AVG(monthly_revenue), 0) as avg_revenue,
    ROUND(AVG(cash_flow_volatility), 3) as avg_volatility
FROM sme_credit_data
GROUP BY 
    business_type,
    CASE 
        WHEN monthly_revenue < 10000 THEN 'Low Revenue'
        WHEN monthly_revenue BETWEEN 10000 AND 25000 THEN 'Medium Revenue'
        ELSE 'High Revenue'
    END,
    CASE 
        WHEN cash_flow_volatility < 0.3 THEN 'Low Risk'
        WHEN cash_flow_volatility BETWEEN 0.3 AND 0.7 THEN 'Medium Risk'
        ELSE 'High Risk'
    END
ORDER BY business_type, revenue_category, volatility_risk;
