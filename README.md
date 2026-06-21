Massachusetts General Hospital Operations & Financial Performance Analysis

 (https://img.shields.io/badge/SQL-MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)
 (https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=flat-square&logo=powerbi&logoColor=black)
 (https://img.shields.io/badge/Healthcare-Analytics-0B5CAD?style=flat-square)

---

Executive Overview

Healthcare organizations must balance patient demand, operational efficiency, and financial sustainability while delivering quality care. Hospital leadership requires visibility into utilization patterns, payer performance, procedure costs, and repeat patient activity to make informed operational and financial decisions.

This project analyzes synthetic healthcare data modeled after Massachusetts General Hospital to evaluate encounter volume, service utilization, payer coverage, claim exposure, procedure activity, and patient return behavior.

Using MySQL and Power BI, I developed an analytics solution designed to help hospital operations and finance leaders identify performance trends, revenue-cycle risk, and opportunities for targeted intervention.

Stakeholders

- Director of Hospital Operations
- Revenue Cycle Leadership
- Finance and Budget Teams
- Care Coordination Teams

Business Objectives

- Understand drivers of patient demand
- Identify financial exposure associated with payer coverage gaps
- Evaluate procedure utilization and cost patterns
- Analyze repeat utilization behavior
- Support operational planning and resource allocation

---

Business Questions

Utilization & Operations

- How has encounter volume changed over time?
- Which encounter classes generate the highest operational demand?
- What percentage of encounters are completed within 24 hours?

Financial Performance

- How much claim value is associated with zero payer coverage?
- Which procedures generate the highest average costs?
- Where is the organization most exposed to reimbursement risk?

Patient Utilization

- Which patients account for the highest volume of 30-day return activity?
- How concentrated is repeat utilization across the patient population?

---

Executive Summary

Analysis of 27,891 encounters across 974 unique patients revealed that hospital activity is heavily concentrated in short-duration care settings.

Key Findings

High-Volume Services Drive Operational Demand

- Ambulatory, outpatient, and urgent-care services represented 80.7% of all encounters.
- 95.9% of encounters were completed within 24 hours.

These findings suggest that patient throughput, scheduling efficiency, registration workflows, and room turnover are primary operational drivers.

Payer Coverage Gaps Create Significant Financial Exposure

- 13,586 encounters had zero payer coverage.
- These encounters represented 48.7% of all encounters.
- Zero-coverage encounters accounted for approximately $63.1 million in claim value.
- This represented 62.2% of total claim value analyzed.

This indicates that reimbursement risk is concentrated among encounters lacking recorded payer coverage and may warrant additional eligibility verification and financial-assistance processes.

Repeat Utilization Is Highly Concentrated

- 771 patients experienced a qualifying 30-day return encounter.
- These patients generated 16,595 total return events.
- The top 10 patients accounted for 34.1% of all return activity.

This concentration suggests that targeted care coordination programs may be more effective than broad population-wide interventions.

"Executive Overview" (images/executive_overview.png)

---

Data Architecture

Data Sources

Table| Description
encounters| Encounter activity, claim costs, payer coverage, encounter class
patients| Demographic and geographic patient information
payers| Insurance payer information
procedures| Procedure descriptions and base costs
organizations| Hospital organization information
patient_readmissions| Derived table identifying 30-day return activity

Data Model

The encounters table serves as the central fact table connecting patients, payers, procedures, and organizations.

"Data Model" (images/data_model.png)

Entity Relationships

patients[Id] → encounters[PATIENT]

payers[Id] → encounters[PAYER]

organizations[Id] → encounters[ORGANIZATION]

encounters[Id] → procedures[ENCOUNTER]

patients[Id] → patient_readmissions[PATIENT]

---

Analytical Insights

1. Operational Demand Is Concentrated in Short-Stay Services

Ambulatory, outpatient, and urgent-care encounters account for over four-fifths of total hospital activity.

Operational Implication

Performance improvements in patient flow, registration efficiency, scheduling, and discharge workflows will impact the majority of patient encounters.

"Encounter Trends" (images/encounter_trends.png)

---

2. Revenue-Cycle Risk Is Concentrated in Zero-Coverage Encounters

Nearly half of all encounters lacked payer coverage and represented over $63 million in claim value.

Financial Implication

Improving payer verification and eligibility workflows could reduce reimbursement risk and improve revenue-cycle performance.

"Cost and Procedure Performance" (images/cost_procedure_performance.png)

---

3. Repeat Utilization Is Driven by a Small Patient Population

Return activity is heavily concentrated among a limited number of patients.

Operational Implication

Care-management resources can be deployed more effectively by prioritizing high-utilization patients rather than applying broad interventions across the entire population.

"Patient Behavior" (images/patient_behavior.png)

---

Recommendations

1. Optimize High-Volume Care Settings

Focus operational improvement initiatives on ambulatory, outpatient, and urgent-care workflows where the majority of patient demand occurs.

2. Strengthen Revenue-Cycle Controls

Implement earlier payer eligibility verification and proactively review high-value encounters lacking recorded coverage.

3. Separate Capacity Planning From Cost Monitoring

Monitor high-volume procedures for staffing and scheduling decisions while evaluating high-cost procedures for financial exposure and utilization management.

4. Develop High-Utilization Patient Programs

Prioritize follow-up care, discharge outreach, and case-management support for patients demonstrating frequent return activity.

---

Technical Approach

SQL

- Data validation
- Multi-table joins
- Aggregations
- Common Table Expressions (CTEs)
- Window functions
- Business metric calculations

Power BI

- Interactive dashboards
- KPI development
- Data modeling
- Drill-through analysis
- Executive reporting

Power Query

- Data transformation
- Data typing
- Helper field creation

---

Key SQL Techniques

- GROUP BY
- CASE WHEN
- CTEs
- LEAD()
- Window functions
- TIMESTAMPDIFF()
- Percentage calculations
- Top-N analysis

---

Tools

- MySQL
- Power BI
- Power Query
- CSV Data Sources

---

Caveats

- Data was generated using Synthea and does not represent actual Massachusetts General Hospital patient records.
- Results should be interpreted as an analytical case study rather than a clinical performance evaluation.
- The 30-day return metric reflects project-defined business logic and is not equivalent to CMS readmission methodology.
- Claim costs represent recorded claim values and do not reflect final reimbursement outcomes.

---

Data Source

This project uses synthetic healthcare data generated using Synthea and provided through the Maven Analytics Hospital Analytics project.

Walonoski, J., Kramer, M., Nichols, J., et al. (2018). Synthea: An approach, method, and software mechanism for generating synthetic patients and synthetic electronic health records. Journal of the American Medical Informatics Association, 25(3), 230–238.