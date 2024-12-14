const mysql = require('mysql2');

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

module.exports = db;