const express = require('express');
const bcrypt = require('bcrypt');
const app = express();
const con = require('./db');

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// -------- generate password --------
app.get('/password/:raw', (req, res) => {
    const raw = req.params.raw;
    bcrypt.hash(raw, 10, (err, hash) => {
        if(err) return res.status(500).send('Error creating password');
        res.send(hash);
    });
});

// -------- login ---------
app.post('/login', (req, res) => {
    const { username, password } = req.body;
    const sql = "SELECT * FROM users WHERE username = ?";
    con.query(sql, [username], (err, results) => {
        if(err) {
            return res.status(500).send("Database error");
        }
        if(results.length !== 1) {
            return res.status(401).send("Wrong username");
        }

        bcrypt.compare(password, results[0].password, (err, same) => {
        if(err) {
            return res.status(500).send("Hashing error");
        }
        if(same) {
            return res.send("Login OK");
        }
            return res.status(401).send("Wrong password");
        });
    });
});


// -------- get all expenses ---------



// -------- get today expenses ---------



// -------- search expenses ---------
// -------- search expenses ---------
app.get('/expenses/search', (req, res) => {
  const keyword = (req.query.keyword || '').trim();
  if (!keyword) return res.json([]);

  const params = [`%${keyword}%`];

  const sql = `
    SELECT
      id,
      item,
      paid AS amount,
      CONCAT(DATE_FORMAT(date, '%Y-%m-%d %H:%i:%s'), '.000') AS created_at
    FROM expense
    WHERE item LIKE ?
    ORDER BY id ASC
  `;

  con.query(sql, params, (err, rows) => {
    if (err) {
      console.error('[search] error:', err);
      return res.status(500).send('Database error');
    }
    return res.json(rows || []);
  });
});

// -------- add new expenses ---------

app.post('/expenses', (req, res) => {
  const item = (req.body.item || '').trim();
  const paid = parseFloat(req.body.paid);

  if (!item || !Number.isFinite(paid) || paid <= 0) {
    return res.status(400).send('Invalid input');
  }

  const sql = `INSERT INTO expense (user_id, item, paid, date) VALUES (?, ?, ?, NOW())`;
  con.query(sql, [1, item, paid], (err, result) => {
    if (err) {
      console.error('[add] error:', err);
      return res.status(500).send('Database error');
    }
    return res.status(201).send("Inserted!"); //
  });
});



// -------- delete expenses ---------


app.listen(3000, () => { 
    console.log('Server is working'); 
});