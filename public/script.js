const API_URL = "http://localhost:3000/api";

document
  .getElementById("customerForm")
  .addEventListener("submit", async (e) => {
    e.preventDefault();

    const customer = {
      customerID: document.getElementById("customerID").value,
      name: document.getElementById("customerName").value,
      phone: document.getElementById("phone").value,
      email: document.getElementById("email").value,
    };

    const res = await fetch(`${API_URL}/customers`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(customer),
    });

    const data = await res.json();
    alert(data.message || data.error);
  });

document.getElementById("orderForm").addEventListener("submit", async (e) => {
  e.preventDefault();

  const order = {
    orderID: document.getElementById("orderID").value,
    orderDate: document.getElementById("orderDate").value,
    status: document.getElementById("status").value,
    customerID: document.getElementById("orderCustomerID").value,
  };

  const res = await fetch(`${API_URL}/orders`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(order),
  });

  const data = await res.json();
  alert(data.message || data.error);
});

async function loadOrders() {
  const res = await fetch(`${API_URL}/orders`);
  const orders = await res.json();

  const ordersDiv = document.getElementById("orders");
  ordersDiv.innerHTML = "";

  orders.forEach((order) => {
    ordersDiv.innerHTML += `
      <div class="order-card">
        <strong>Order ID:</strong> ${order.OrderID}<br>
        <strong>Date:</strong> ${order.OrderDate}<br>
        <strong>Status:</strong> ${order.Status}<br>
        <strong>Customer ID:</strong> ${order.CustomerID}
      </div>
    `;
  });
}
