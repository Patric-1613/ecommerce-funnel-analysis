# E-Commerce Funnel Analysis

## Project Overview
End-to-end sales funnel analysis of an e-commerce business using SQL and Google BigQuery.
The analysis covers 5,000 unique visitors over 12 months, tracking user journeys from
first page view through to purchase.

## Tools Used
- Google BigQuery (SQL)
- Google Cloud Platform
- Git / GitHub

## Key Findings
- Overall conversion rate: 17% (826 out of 5,000 visitors)
- Biggest drop-off: Page view to cart (only 31% add anything)
- Best performing channel: Email (34% conversion rate)
- Worst performing channel: Social media (7% conversion rate)
- Average time from first view to purchase: 24.6 minutes
- Average order value: $106.51
- Total revenue: $87,975

## Analysis Performed
| Analysis | Description |
|----------|-------------|
| Funnel Stage Analysis | Drop-off rates across all 5 funnel stages |
| Traffic Source Analysis | Conversion rates by channel |
| Time-to-Conversion | Average minutes from view to purchase |
| Revenue Analysis | AOV, revenue per buyer, revenue per visitor |

## Files in this Repo
| File | Description |
|------|-------------|
| `funnel_analysis.sql` | All BigQuery SQL queries |
| `Funnel_Analysis_Report.docx` | Full written report with recommendations |
| `*.csv` | Query result outputs |

## Recommendations Summary
1. **UX** — Fix top-of-funnel product discovery; do not touch the checkout flow
2. **Marketing** — Redirect social budget to email capture; double down on email
3. **Financial** — Set strict CAC limits per channel based on $106 AOV
