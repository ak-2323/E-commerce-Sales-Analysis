# 🛒 E-commerce Sales Analysis: SQL + Python Project

## Project Overview

This project is a complete end-to-end data analysis case study based on real-world e-commerce data. Using Microsoft SQL Server for querying and Python for data handling, the project explores key business questions across various areas including revenue, customer behavior, delivery performance, product analytics, and payments. This project is ideal for analysts aiming to strengthen their SQL querying skills using practical datasets.

## ER Diagram
![ER Diagram](https://github.com/ak-2323/E-commerce-Sales-Analysis/blob/main/er-diagram.png)
---

## 📦 Requirements

- **Database**: Microsoft SQL Server (SSMS)
- **Programming**: Python (for data prep and loading)
- **Libraries**: `pandas`

## 📁 Project Structure

```plaintext
|-- data/                     # Raw & cleaned CSV files
|-- README.md                 # This documentation
|-- merge_n_clean.ipynb       # Python script to clean & load data
```
---

## 🔄 Project Workflow

### 1. Set Up the Environment
   - **Tools Used**: Visual Studio Code (VS Code), Python, SQL (SSMS)
   - **Goal**: Create a structured workspace within VS Code and organize project folders for smooth development and data handling.

### 2. Download E-commerce Sales Data
   - **Data Source**: Use the Kaggle platform to download the datasets.
   - **Dataset Link**: [E-commerce Sales Dataset](https://www.kaggle.com/datasets/bytadit/ecommerce-order-dataset)
   - **Storage**: Save the data in the `data/` folder for easy reference and access.

### 3. Data Preparation (Python)
- Read multiple CSV files into pandas DataFrames.
- merge train and test dataset to perform analysis on whole dataset.
- Clean and format data: fix nulls, types, and standardize columns.
- Load cleaned data into SQL Server.

--- 

## 📊 SQL Business Analysis
The following analysis is performed entirely within SQL Server using a variety of SQL techniques:

🔹  **Sales & Revenue Analysis:** Analyze revenue growth patterns and understand key revenue drivers using time-based and category-based breakdowns.

🔹  **Customer Insights:** Explore customer behavior, purchasing patterns, and geographic distribution to improve engagement and retention.

🔹  **Order & Delivery Performance:**
Evaluate delivery efficiency and order fulfillment metrics to uncover operational delays and performance gaps.

🔹  **Product-Level Analysis:** Drill down into product performance, inventory characteristics, and category trends to support business decisions.

🔹  **Payment Insights:** Understand customer preferences in payment methods and their impact on purchasing behavior and revenue.

--- 

## 🧠 Key Insights
Here are some of the key insights collected by applying various SQL concepts:

- **Sales & Revenue Analysis:** Uncovered top-selling categories, high-revenue months and year, and how product vs. shipping charges contribute to total revenue.

- **Customer Insights:** Highlighted cities and states with the most unique customers, repeat vs. one-time buyers, and customer spending trends.

- **Order & Delivery Performance:** Measured average delivery speed, late order percentages, and delivery delays across product categories.

- **Product-Level Analysis:** Identified the most sold products,no. product categories, and the link between size and shipping costs.

- **Payment Insights:** Revealed the most used payment types, average installment usage, and how payment behavior varies by order value.

--- 

## 📈 Future Enhancements
- Connect SQL views to Power BI/Tableau for dashboards.
- Introduce Python-based machine learning for customer segmentation or demand forecasting.

--- 

## ⚙️ Project Setup

1. Clone the Repository
    ```
    git clone https://github.com/ak-2323/E-commerce-Sales-Analysis.git
    cd your-repo-name
    ```
--- 

## 📜 License
This project is licensed under the MIT License.

---

## 🙌 Acknowledgments
- **Dataset**: Inspired by e-commerce transactional structures
- **Inspiration**: Real-world business analysis case study
