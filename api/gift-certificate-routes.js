var express = require('express'),
    _ = require('lodash'),
    config = require('./config'),
    jwt = require('jsonwebtoken'),
    mysql = require('mysql'),
    bcrypt = require('bcrypt');

var app = module.exports = express.Router();

var conn = mysql.createConnection({
    host: config.sql_host,
    user: config.sql_user,
    port: config.sql_port,
    password: config.sql_password,
    database: config.sql_database,
});

const saltRounds = 10;

app.post('/gift-certificates/create', function (req, res) {
    var id = req.body.id;
    var amount = req.body.amount;
    var sale_price = req.body.sale_price;
    var sold_date = req.body.sold_date;
    var issuer_id = req.body.issuer_id;
    var memo = req.body.memo;

    if (!id ||
        !amount ||
        !sale_price ||
        !sold_date ||
        !issuer_id) {
        return res.status(400).send("Please enter all fields");
    }

    var sql = 'INSERT INTO GiftCertificates (id, amount, sold_date, issuer_id) VALUES ('
        + conn.escape(id) + ' '
        + conn.escape(amount) + ' '
        + conn.escape(sold_date) + ' '
        + conn.escape(issuer_id);

    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }
        res.status.apply(201).send(results.insertId);
    });
});

app.get('/gift-certificates:id', function (req, res) {
    var id = req.body.id;

    if (!id) {
        return res.status(400).send("Please enter an id");
    }

    var sql = 'SELECT * FROM GiftCertificates WHERE id = ' + conn.escape(id);
    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }
        res.status(200).json.apply(JSON.stringify(results));
    });
});

app.get('/gift-certificates', function (req, res) {
    var sql = 'SELECT * FROM GiftCertificates';
    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }
        res.status(200).json(JSON.stringify(users));
    })
})