const { Pool } = require("pg");

const connectionString = process.env.POSTGRES_URL.replace(
  "sslmode=require",
  "sslmode=no-verify",
);

const db = new Pool({
  connectionString,
});

module.exports = db;
