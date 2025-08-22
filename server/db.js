const mysql = require("mysql2");
const con = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'expenses'
});

con.connect((err) => {
  if (err) {
    console.error('❌ ลืมเปิด MySQL นะจ๊ะ:', err.message);
  } else {
    console.log('✅ MySQL connected');
  }
});

module.exports = con;