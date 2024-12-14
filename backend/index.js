const express = require('express');
const mysql = require('mysql2');
const app = express();
const PORT = 5000;

app.use(express.json());

const db = mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'subhanshu',
  password: process.env.DB_PASSWORD || 'atlys123',
  database: process.env.DB_NAME || 'atlys'
});

db.connect(err => {
  if (err) throw err;
  console.log('Database connected!');
});

app.get('/api/users', (req, res) => {
  db.query('SELECT * FROM users', (err, results) => {
    if (err) throw err;
    res.json(results);
  });
});

app.post('/api/users', (req, res) => {
  const { name, email } = req.body;
  db.query('INSERT INTO users (name, email) VALUES (?, ?)', [name, email], (err, result) => {
    if (err) throw err;
    res.json({ id: result.insertId, name, email });
  });
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
