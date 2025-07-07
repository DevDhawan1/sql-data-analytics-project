# sql-data-analytics-project

# 📊 SQL Data Analysis & Reporting Project

This project showcases the end-to-end SQL-based data analysis workflow on a simulated sales dataset. It includes data cleaning, trend analysis, performance evaluation, segmentation, and final report generation — modularized across separate SQL files.

---

## 📁 Project Structure

| File Name                  | Description                                                |
|----------------------------|------------------------------------------------------------|
| `00_compiled_scripts.sql` | Master script combining all analysis modules               |
| `01_time_analysis_trends.sql` | Yearly & monthly sales trend analysis                     |
| `02_cumulative_analysis.sql` | Running totals & moving average calculation               |
| `03_performance_analysis.sql` | Compare product performance vs target and YoY changes     |
| `04_data_segmentation.sql` | Grouping products based on price segments                 |
| `05_part_to_whole_analysis.sql` | Category-wise contribution to total sales              |
| `06_customer_report.sql`  | Customer segmentation (VIP, Regular, New)                  |
| `07_product_report.sql`   | Final cleaned product summary/reporting                    |
| `LICENSE`                 | Open-source license file (optional placeholder)            |
| `README.md`               | Project overview and documentation                         |

---

## 💡 Key Features

### 🔧 Data Cleaning
- Replaces blank/invalid values in date columns
- Null handling for price and sales-related calculations

### 📅 Time Trend Analysis
- Sales trends grouped by **month** and **year**
- Aggregates metrics: total sales, customers, quantity

### 📈 Cumulative Insights
- Computes **running totals** and **moving averages** using window functions

### 🎯 Performance Evaluation
- Tracks actual sales vs average and prior years
- Labels products as *Above Average*, *Below Average*, *No Change*, etc.

### 🧩 Product Segmentation
- Products grouped by pricing brackets: Below 100, 100–500, etc.

### 🧠 Customer Segmentation
- Groups customers as:
  - **VIP** – High spenders with long history
  - **Regular** – Medium spenders or stable users
  - **New** – Recent/low-value customers

### 📊 Category Contribution
- Calculates each category’s percentage share in overall revenue

---

## 🛠 Requirements

- **MySQL 8.0+** (for window functions like `ROW_NUMBER()` and `LAG`)
- A schema with the following tables:
  - `fact_sales`
  - `dim_products`
  - `dim_customers`

Optional CSVs or mock data should be placed in the `csv files/` directory.

---

## ▶️ How to Use

1. **Import the Database Schema & Data**.
2. Run the scripts in order or start with `00_compiled_scripts.sql` to execute everything at once.
3. View insights from each section independently using the modular `.sql` files.

---

## 👤 Author  
**Devansh Dhawan**  
*Bridging Data and Decisions — Turning Raw Data into Business & Financial Insights*

---

### 🔗 Connect with Me

Feel free to connect, collaborate, or explore more of my work:

- 💼 [LinkedIn – Devansh Dhawan](https://www.linkedin.com/in/devanshdhawan)
- 🗂️ [GitHub Profile](https://github.com/DevDhawan1)
- 📬 Email: [devanshdhawan8943@gmail.com](mailto:devanshdhawan8943@gmail.com)
- 🔖 [LinkedIn Project Post](https://www.linkedin.com/posts/devanshdhawan_project-sql-data)

---

## 📄 License

This project is licensed under the MIT License – see the `LICENSE` file for details.
