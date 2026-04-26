const API_URL = "/api";

document
  .getElementById("customerForm")
  .addEventListener("submit", async (e) => {
    e.preventDefault();

    const customer = {
      customerID: Number(document.getElementById("customerID").value),
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

    if (res.ok) {
      e.target.reset();
    }
  });

document.getElementById("orderForm").addEventListener("submit", async (e) => {
  e.preventDefault();

  const order = {
    orderID: Number(document.getElementById("orderID").value),
    orderDate: document.getElementById("orderDate").value,
    status: document.getElementById("status").value,
    customerID: Number(document.getElementById("orderCustomerID").value),
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

  if (res.ok) {
    e.target.reset();
    loadOrders();
  }
});

async function loadOrders() {
  const res = await fetch(`${API_URL}/orders`);
  const orders = await res.json();

  const ordersDiv = document.getElementById("orders");
  ordersDiv.innerHTML = "";

  if (!res.ok) {
    ordersDiv.innerHTML = `<p>${orders.error}</p>`;
    return;
  }

  orders.forEach((order) => {
    ordersDiv.innerHTML += `
      <div class="order-card">
        <strong>Order ID:</strong> ${order.orderid}<br>
        <strong>Date:</strong> ${order.orderdate}<br>
        <strong>Status:</strong> ${order.status}<br>
        <strong>Customer ID:</strong> ${order.customerid}
      </div>
    `;
  });
}
