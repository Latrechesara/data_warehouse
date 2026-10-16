---
video_url: "https://www.youtube.com/watch?v=LIEN_DE_TA_VIDEO_ICI"
prev_url: 02-environment.md
next_url: 04-staging.md
---

# Data Ingestion in Mysql 



## 🧭 Understanding the Northwind Domains

The classic **Northwind** database is an exceptional tutorial schema modeling a small-business ERP. It is structured across three core functional domains:

1. **Catalog & Inventory Domain (`products`, `categories`, `suppliers`)**: 
   Manages product listings, pricing, item classification categories, and vendor relationships.
2. **Sales & Ordering Domain (`orders`, `order_details` / `order_items`, `customers`, `employees`)**: 
   Tracks transactional sales, granular line-item performance, client directories, and sales representative data.
3. **Fulfillment & Logistics Domain (`shippers`)**: 
   Oversees shipping carriers, order dispatch, and delivery tracking.

---

## 📥 Downloading the Source Data

We will use the community-maintained MySQL version of the Northwind database. 

You can access and download the raw SQL structure and data files directly from the [busynovadad/northwind-MySQL GitHub Repository](https://github.com/busynovadad/northwind-MySQL). Specifically, we need:
- **Schema definition:** [`northwind.sql`](https://github.com/busynovadad/northwind-MySQL/blob/master/northwind.sql)
- **Data payload:** `northwind-data.sql`

---

## 🛠️ Restoring the Database Locally in MySQL

First by using the datarestore in mysql try to upload the sql schema of the database then populate the database

<img width="1636" height="907" alt="how_to_restore_data" src="https://github.com/user-attachments/assets/f8a2e809-2039-49d8-86d9-1232088839b6" />
