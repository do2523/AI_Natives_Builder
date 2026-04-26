const db = require("./db");

module.exports = async function handler(req, res) {
  try {
    if (req.method === "POST") {
      const { orderID, orderDate, status, customerID } = req.body;

      await db.query(
        `
        INSERT INTO Orders
        (OrderID, OrderDate, Status, CustomerID, Delivery_DriverEmployeeID, WaiterEmployeeID)
        VALUES ($1, $2, $3, $4, NULL, NULL)
        `,
        [orderID, orderDate, status, customerID],
      );

      return res.status(200).json({ message: "Order added successfully" });
    }

    if (req.method === "GET") {
      const result = await db.query("SELECT * FROM Orders");
      return res.status(200).json(result.rows);
    }

    res.status(405).json({ error: "Method not allowed" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
