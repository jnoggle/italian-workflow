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
    var sold_date = req.body.sold_date;
    var seller_id = req.body.seller_id;
    var redeemed_date = req.body.redeemed_date;

    if (!id ||
        !amount ||
        !sold_date ||
        !seller_id ||
        !redeemed_date) {
        return res.status(400).send("Please enter all fields");
    }

    var sql = 'INSERT INTO GiftCertificates (id, amount, sold_date, seller_id) VALUES ('
        + conn.escape(id) + ' '
        + conn.escape(amount) + ' '
        + conn.escape(sold_date) + ' '
        + conn.escape(seller_id);

    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }
        res.status.apply(201).send(results.insertId);
    });
});

app.get('/gift-certificates:id', function (req, res) {

})