const express = require("express");
const { Pool } = require("pg");
const cors = require("cors");
const path = require("path");
require("dotenv").config();

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

const db = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false,
  },
});

db.connect()
  .then(() => {
    console.log("Connected to Supabase PostgreSQL database");
  })
  .catch((err) => {
    console.error("Database connection failed:", err);
  });

app.post("/api/customers", async (req, res) => {
  const { customerID, name, phone, email } = req.body;

  const sql = `
    INSERT INTO Customer (CustomerID, Name, Phone, Email)
    VALUES ($1, $2, $3, $4)
  `;

  try {
    await db.query(sql, [customerID, name, phone, email]);
    res.json({ message: "Customer added successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post("/api/orders", async (req, res) => {
  const { orderID, orderDate, status, customerID } = req.body;

  const sql = `
    INSERT INTO Orders
    (OrderID, OrderDate, Status, CustomerID, Delivery_DriverEmployeeID, WaiterEmployeeID)
    VALUES ($1, $2, $3, $4, NULL, NULL)
  `;

  try {
    await db.query(sql, [orderID, orderDate, status, customerID]);
    res.json({ message: "Order added successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get("/api/orders", async (req, res) => {
  const sql = "SELECT * FROM Orders";

  try {
    const result = await db.query(sql);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(3000, () => {
  console.log("Server running at http://localhost:3000");
});
