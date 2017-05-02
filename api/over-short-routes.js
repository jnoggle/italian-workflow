"use strict";

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

app.post('/over-shorts', function (req, res) {
    var amount = req.body.amount;
    var billable = req.body.billable;
    var memo = req.body.memo;

    var determine_id_from_token = 1;
    var issuer_id = determine_id_from_token;
    var date_recorded = getToday();

    if (amount == null ||
        billable == null ||
        memo == null) {
        return res.status(400).send("Please enter all required fields");
    }

    var sql = 'INSERT INTO OverShorts (amount, billable, date_recorded, issuer_id, memo) VALUES ('
        + conn.escape(amount) + ', '
        + conn.escape(billable) + ', '
        + conn.escape(date_recorded) + ', '
        + conn.escape(issuer_id) + ', '
        + conn.escape(memo) + ')';

    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }

        var os = {
            over_short_id: results.insertId,
            amount: amount,
            billable: billable,
            date_recorded: date_recorded,
            username: issuer_id.toString(),
            memo: memo
        }

        res.status(201).json(os);
    });
});

app.post('/over-shorts/bydates', function (req, res) {
    var begin_date = req.body.begin_date;
    var end_date = req.body.end_date;

    if (!begin_date || !end_date) {
        return res.status(400).send("Invalid request, expected begin_date and end_date");
    }

    var sql =
        'SELECT OS.over_short_id, OS.amount, OS.billable, OS.amountPaid, OS.date_recorded, OS.last_contacted, U.username, OS.memo ' +
        'FROM OverShorts AS OS ' +
        'INNER JOIN Users AS U ON U.user_id = OS.issuer_id ' +
        'WHERE date_recorded BETWEEN ' + conn.escape(begin_date) + ' AND ' + conn.escape(end_date) + ' ' +
        'ORDER BY OS.over_short_id DESC';

    // var sql = 'SELECT * FROM OverShorts WHERE date_recorded BETWEEN ' + conn.escape(begin_date) + ' AND ' + conn.escape(end_date);
    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }

        res.status(200).json(results);
    })
})

app.get('/over-shorts/today', function (req, res) {
    var today = getToday();

    var sql =
        'SELECT OS.over_short_id, OS.amount, OS.billable, OS.amountPaid, OS.date_recorded, OS.last_contacted, U.username, OS.memo ' +
        'FROM OverShorts AS OS ' +
        'INNER JOIN Users AS U ON U.user_id = OS.issuer_id ' +
        'WHERE date_recorded = ' + conn.escape(today) + ' ' +
        'ORDER BY OS.over_short_id DESC';

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