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




// -------- add new expenses ---------




// -------- delete expenses ---------


app.listen(3000, () => { 
    console.log('Server is working'); 
});