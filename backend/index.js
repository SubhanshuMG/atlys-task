const express = require('express');
const mysql = require('mysql2');
const app = express();
const PORT = 5000;

app.use(express.json());

const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
});

db.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err.message);
    return;
  }
  console.log('Connected to the MySQL database.');
});

app.get('/api/users', (req, res) => {
  db.query('SELECT * FROM users', (err, results) => {
    if (err) {
      console.error('Error fetching users:', err.message);
      res.status(500).send('Database error');
      return;
    }
    res.json(results);
  });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});