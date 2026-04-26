const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");
const path = require("path");

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, "docs")));

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "admin@123",
  database: "PizzeriaDB",
});

db.connect((err) => {
  if (err) {
    console.error("Database connection failed:", err);
    return;
  }
  console.log("Connected to MySQL database");
});

app.post("/api/customers", (req, res) => {
  const { customerID, name, phone, email } = req.body;

  const sql = `
    INSERT INTO Customer (CustomerID, Name, Phone, Email)
    VALUES (?, ?, ?, ?)
  `;

  db.query(sql, [customerID, name, phone, email], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: "Customer added successfully" });
  });
});

app.post("/api/orders", (req, res) => {
  const { orderID, orderDate, status, customerID } = req.body;

  const sql = `
    INSERT INTO \`Order\`
    (OrderID, OrderDate, Status, CustomerID, Delivery_DriverEmployeeID, WaiterEmployeeID)
    VALUES (?, ?, ?, ?, NULL, NULL)
  `;

  db.query(sql, [orderID, orderDate, status, customerID], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: "Order added successfully" });
  });
});

app.get("/api/orders", (req, res) => {
  const sql = "SELECT * FROM `Order`";

  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

app.listen(3000, () => {
  console.log("Server running at http://localhost:3000");
});
