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
    dateStrings: config.dateStrings
});

const saltRounds = 10;

app.post('/gift-certificates', function (req, res) {
    var amount = req.body.amount;
    var sale_price = req.body.sale_price;
    var memo = req.body.memo;

    var determine_id_from_token = 1;
    var issuer_id = determine_id_from_token;
    var date_sold = getToday();

    if (!amount ||
        !sale_price) {
        return res.status(400).send("Please enter all required fields");
    }



    var sql = 'INSERT INTO GiftCertificates (amount, sale_price, date_sold, issuer_id, memo) VALUES ('
        + conn.escape(amount) + ', '
        + conn.escape(sale_price) + ', '
        + conn.escape(date_sold) + ', '
        + conn.escape(issuer_id) + ', '
        + conn.escape(memo) + ')';

    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }

        var gc = {
            gift_certificate_id: results.insertId,
            amount: req.body.amount,
            sale_price: req.body.sale_price,
            date_sold: date_sold,
            username: issuer_id.toString(),
            memo: req.body.memo
        };
        console.log(gc);
        res.status(201).json(gc);
    });
});

app.put('/gift-certificates/redeem', function (req, res) {
    var id = req.body.id;

    if (!id) {
        return res.status(400).send("Invalid request, expected id");
    }

    var sql = 'SELECT * FROM GiftCertificates WHERE gift_certificate_id = ' + conn.escape(id);
    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }
        if (results.length != 1) {
            return res.status(400).send("Can't find id");
        }

        var date_redeemed = getToday();

        var sql = 'UPDATE GiftCertificates SET date_redeemed = '
            + conn.escape(date_redeemed)
            + ' WHERE gift_certificate_id = '
            + conn.escape(id);

        var query = conn.query(sql, function (err, results) {
            if (err) {
                console.log(err);
                return res.status(400).send("Database error");
            }

            return res.status(200).send("Success");
        });
    });
});

app.get('/gift-certificates/byid', function (req, res) {
    var id = req.body.id;

    if (!id) {
        return res.status(400).send("Invalid request, expected id");
    }

    var sql = 'SELECT * FROM GiftCertificates WHERE gift_certificate_id = ' + conn.escape(id);
    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }
        res.status(200).json(JSON.stringify(results));
    });
});

app.get('/gift-certificates/bydate', function (req, res) {
    var date = req.body.date;

    if (!date) {
        return res.status(400).send("Invalid request, expected date");
    }

    var sql = 'SELECT * FROM GiftCertificates WHERE date_sold = ' + conn.escape(date);
    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }

        res.status(200).json(results);
    });
});

app.get('/gift-certificates/today', function (req, res) {
    var today = getToday();

    var sql =
        'SELECT GC.gift_certificate_id, GC.amount, GC.sale_price, GC.date_sold, GC.date_redeemed, U.username, GC.memo ' +
        'FROM GiftCertificates AS GC ' +
        'INNER JOIN Users AS U ON U.user_id = GC.issuer_id ' +
        'WHERE date_sold = ' + conn.escape(today) + ' ' +
        'ORDER BY GC.gift_certificate_id DESC';

    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }

        res.status(200).json(results);
    });
});

app.post('/gift-certificates/bydates', function (req, res) {
    var begin_date = req.body.begin_date;
    var end_date = req.body.end_date;

    if (!begin_date || !end_date) {
        return res.status(400).send("Invalid request, expected begin_date and end_date");
    }

    var sql = 'SELECT * FROM GiftCertificates WHERE date_sold BETWEEN ' + conn.escape(begin_date) + ' AND ' + conn.escape(end_date);
    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }

        res.status(200).json(results);
    });
});

app.get('/gift-certificates', function (req, res) {
    var sql = 'SELECT * FROM GiftCertificates ORDER BY date_sold DESC, gift_certificate_id DESC';
    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }

        res.status(200).json(results);
    });
});

function getToday() {
    var date = new Date();
    var year = date.getFullYear();
    var month = pad(date.getMonth() + 1);
    var day = pad(date.getDate());

    return [year, month, day].join("-");
}

function pad(number) {
    var r = String(number);
    if (r.length === 1) {
        r = '0' + r;
    }
    return r;
}