const db = require("./db");

module.exports = async function handler(req, res) {
  if (req.method !== "POST") {
    return res.status(405).json({ error: "Method not allowed" });
  }

  const { customerID, name, phone, email } = req.body;

  try {
    await db.query(
      `
      INSERT INTO Customer (CustomerID, Name, Phone, Email)
      VALUES ($1, $2, $3, $4)
      `,
      [customerID, name, phone, email],
    );

    return res.status(200).json({ message: "Customer added successfully" });
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};
