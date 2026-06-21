# Massachusetts General Hospital Operations & Financial Performance Analysis

![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?style=flat-square\&logo=mysql\&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=flat-square\&logo=powerbi\&logoColor=black)
![Healthcare Analytics](https://img.shields.io/badge/Healthcare-Analytics-0B5CAD?style=flat-square)

## Background and Overview

Hospital leadership needs reliable visibility into patient demand, service utilization, payer coverage, procedure cost, and repeat utilization to make informed operational and financial decisions.

This project analyzes synthetic hospital records modeled for Massachusetts General Hospital. The objective is to evaluate encounter patterns, payer coverage, procedure activity, claim costs, and 30-day return behavior to identify opportunities for better capacity planning, revenue-cycle control, and care coordination.

The analysis was completed using **MySQL** for data exploration and business-question validation and **Power BI** for dashboard development. The final report is designed for hospital operations and finance stakeholders who need a concise view of performance trends and business risk.

### Business Questions

* How has encounter volume changed over time?
* Which encounter classes account for most hospital activity?
* What share of encounters are completed within 24 hours?
* How much financial exposure is associated with zero payer coverage?
* Which procedures are most frequent and which carry the highest average base cost?
* Which patients account for the largest share of 30-day return events?

---

## Executive Summary

The hospital recorded **27,891 total encounters** across **974 unique patients**, with activity concentrated in short-duration care. **80.7% of encounters came from ambulatory, outpatient, and urgent-care services**, while **95.9% of encounters lasted less than 24 hours**, showing that operational demand is driven primarily by high-volume, short-stay services.

Financial exposure was also meaningful: **13,586 encounters had zero payer coverage**, representing **48.7% of all encounters**. These zero-coverage encounters accounted for approximately **$63.1M in claim value**, or **62.2% of total claim value**, indicating a substantial revenue-cycle risk.

The patient behavior analysis identified **771 patients with a 30-day return encounter** and **16,595 total 30-day return events**. The top 10 patients accounted for **5,664 return events**, or **34.1% of all return events**, highlighting a concentrated opportunity for targeted care coordination.

![Executive Overview](images/executive_overview.png)

---

## Data Structure Overview

The dataset contains five primary tables used for analysis, plus one derived table exported from SQL for 30-day return-event reporting.

| Table                  | Purpose                                                                                                 |
| ---------------------- | ------------------------------------------------------------------------------------------------------- |
| `encounters`           | Encounter dates, encounter class, claim cost, payer coverage, patient ID, payer ID, and organization ID |
| `patients`             | Patient demographic and geographic attributes                                                           |
| `payers`               | Insurance payer information                                                                             |
| `procedures`           | Procedure descriptions, procedure codes, base costs, and encounter linkage                              |
| `organizations`        | Hospital organization information                                                                       |
| `patient_readmissions` | Derived SQL output showing each patient's number of 30-day return events                                |

The `encounters` table is the central fact table. It connects patients, payers, organizations, and procedures, allowing the analysis to evaluate utilization, financial exposure, and patient behavior across the hospital system.

![Data Model](images/data_model.png)

### Entity Relationship Summary

```text
patients[Id]          -> encounters[PATIENT]
payers[Id]            -> encounters[PAYER]
organizations[Id]     -> encounters[ORGANIZATION]
encounters[Id]        -> procedures[ENCOUNTER]
patients[Id]          -> patient_readmissions[PATIENT]
```

---

## Insights Deep Dive

### 1. Short-duration services drive most hospital activity

**Observation:** Ambulatory, outpatient, and urgent-care services accounted for **80.7% of total encounters**. In addition, **95.9% of encounters lasted less than 24 hours**.

**Business Context:** The hospital's operational workload is driven less by long inpatient stays and more by high-volume, short-duration encounters. This means throughput, registration speed, room turnover, and scheduling efficiency are central to operational performance.

**Impact:** Improving patient flow across ambulatory, outpatient, and urgent-care settings would affect the largest share of hospital activity.

![Encounter Trends](images/encounter_trends.png)

---

### 2. Zero payer coverage creates substantial financial exposure

**Observation:** **13,586 encounters** had zero payer coverage, representing **48.7% of all encounters**. These encounters accounted for approximately **$63.1M**, or **62.2% of total claim value**.

**Business Context:** Encounters without recorded coverage can increase reimbursement risk, delay collections, and create additional administrative workload for billing and patient financial services teams.

**Impact:** Zero-coverage claims represent a disproportionate share of total claim value and should be treated as a revenue-cycle priority. Procedure analysis also helps separate high-volume operational workload from high-cost financial intensity.

![Cost and Procedure Performance](images/cost_procedure_performance.png)

---

### 3. 30-day return activity is concentrated among a small patient group

**Observation:** **771 patients** had a qualifying 30-day return encounter, producing **16,595 total 30-day return events**. The top 10 patients generated **5,664 events**, or **34.1%** of all return events.

**Business Context:** Repeat utilization is not evenly distributed across the patient population. A limited group of patients is responsible for a disproportionate share of return activity.

**Impact:** Targeted care coordination, discharge follow-up, and case-management workflows could reduce avoidable repeat utilization more efficiently than broad interventions applied across the entire patient population.

![Patient Behavior](images/patient_behavior.png)

---

## Recommendations

### 1. Prioritize staffing and workflow improvements in short-duration care settings

Because **80.7% of encounters** came from ambulatory, outpatient, and urgent-care services, hospital operations should focus improvement efforts on these high-volume areas. Leadership should review appointment scheduling, registration throughput, room turnover, and discharge processes to reduce bottlenecks.

### 2. Strengthen payer verification and financial-assistance workflows

Zero-coverage encounters represented **62.2% of total claim value**, making payer verification a material financial-control opportunity. The hospital should implement eligibility checks earlier in the encounter process and flag high-value zero-coverage claims for immediate review.

### 3. Monitor high-cost and high-volume procedures separately

Procedure-volume and average-cost visuals should be reviewed together. High-volume procedures should inform staffing and capacity planning, while high-cost procedures should be monitored for utilization appropriateness and financial exposure.

### 4. Build a targeted care-management workflow for high-utilization patients

The top 10 patients accounted for **34.1% of 30-day return events**. These patients should be prioritized for follow-up scheduling, medication review, discharge outreach, and case-management support.

---

## Caveats and Assumptions

* The dataset is synthetic and was generated through Synthea; it does not represent actual Massachusetts General Hospital patient records.
* The 30-day return metric follows the project-defined SQL logic and should not be interpreted as a formal CMS inpatient readmission measure.
* The return-event calculation identifies subsequent encounters within 30 days of a previous encounter; additional clinical review would be needed to determine preventability.
* The 2022 data is incomplete and only includes activity through early February, so it should not be compared directly against complete calendar years.
* Claim costs represent recorded claim values in the dataset and do not include final reimbursement, contractual adjustments, denials, or collections.
* The `patient_readmissions` table was created by exporting SQL CTE results into a CSV so the result could be visualized in Power BI.

---

## Tools Used

* **MySQL:** Data validation, aggregations, joins, CTEs, window functions, and business-question analysis
* **Power BI:** Data modeling, KPI development, dashboard design, slicers, drilldown visuals, and stakeholder reporting
* **Power Query:** Data typing and calculated helper fields
* **CSV:** Source-data storage and SQL result export

---

## Key SQL Techniques Used

* `GROUP BY` aggregations
* `CASE WHEN` conditional logic
* percentage calculations
* `TIMESTAMPDIFF()` for encounter duration
* payer and encounter joins
* CTEs
* `LEAD()` window function for next-encounter analysis
* Top N analysis

---

## Repository Structure

```text
hospital-performance-analysis/
|
├── README.md
|
├── data/
|   ├── encounters.csv
|   ├── patients.csv
|   ├── payers.csv
|   ├── procedures.csv
|   ├── organizations.csv
|   └── patient_readmissions.csv
|
├── sql/
|   └── hospital_analytics_queries.sql
|
├── dashboard/
|   └── hospital_performance_dashboard.pbix
|
└── images/
    ├── executive_overview.png
    ├── data_model.png
    ├── encounter_trends.png
    ├── cost_procedure_performance.png
    └── patient_behavior.png
```

---

## Data Source

The dataset was provided through the Maven Analytics Hospital Analytics project and generated using Synthea, an open-source synthetic patient generator.

**Reference:** Walonoski, J., Kramer, M., Nichols, J., et al. (2018). *Synthea: An approach, method, and software mechanism for generating synthetic patients and the synthetic electronic health care record*. Journal of the American Medical Informatics Association, 25(3), 230–238.
