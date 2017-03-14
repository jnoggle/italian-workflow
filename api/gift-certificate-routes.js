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

app.post('/gift-certificates', function (req, res) {
    var amount = req.body.amount;
    var sale_price = req.body.sale_price;
    var memo = req.body.memo;

    var determine_id_from_token = 1;
    var issuer_id = determine_id_from_token;

    if (!amount ||
        !sale_price) {
        return res.status(400).send("Please enter all required fields");
    }

    var sql = 'INSERT INTO GiftCertificates (amount, sale_price, date_sold, issuer_id, memo) VALUES ('
        + conn.escape(amount) + ' '
        + conn.escape(sale_price) + ' '
        + conn.escape(date_sold) + ' '
        + conn.escape(issuer_id) + ' '
        + conn.escape(memo);

    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }

        gc = {
            id: result.insertId,
            amount: req.body.amount,
            sale_price: req.body.sale_price,
            date_sold: req.body.date_sold,
            issuer_id: issuer_id,
            memo: req.body.memo
        }
        res.status(201).json(gc);
    });
});

app.get('/gift-certificates/:id', function (req, res) {
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
        res.status(200).json(JSON.stringify(results));
    });
});

app.get('/gift-certificates', function (req, res) {
    var sql = 'SELECT * FROM GiftCertificates';
    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }
        res.status(200).json(JSON.stringify(results));
    });
});
