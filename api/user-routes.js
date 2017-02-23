var express = require('express'),
    _ = require('lodash'),
    config = require('./config'),
    jwt = require('jsonwebtoken'),
    mysql = require('mysql'),
    bcrypt = require('bcrypt');

var app = module.exports = express.Router();

var conn = mysql.createConnection({
    host: 'localhost',
    user: 'iwapp',
    port: '3306',
    password: 'iwapp3741982351',
    database: 'italian_workflow',
});

const saltRounds = 10;

function createToken(user) {
    return jwt.sign(_.omit(user, 'password'), config.secret, { expiresIn: 60 * 60 * 5 });
}

app.post('/users', function (req, res) {
    var username = req.body.username;
    var password = req.body.password;

    if (!username || !password) {
        return res.status(400).send("Please enter your username and password");
    }

    var sql = 'SELECT * FROM Users WHERE username = ' + conn.escape(username);
    var query = conn.query(sql, function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }

        if (results.length > 0) {
            return res.status(400).send("There is already a user with that name");
        }

        var hash = bcrypt.hashSync(password, saltRounds);

        var user = {
            username: username,
            password: hash
        }

        var sql = 'INSERT INTO Users ? ';
        var query = conn.query("INSERT INTO Users set ? ", user, function (err, results) {
            if (err) {
                console.log(err);
                return res.status(400).send("Database error");
            }
            res.status(201).send({
                id_token: createToken(user)
            });
        })
    })
});

app.post('/sessions/create', function (req, res) {
    var username = req.body.username;
    var password = req.body.password;

    if (!username || !password) {
        return res.status(400).send("Please enter your username and password");
    }

    var hash = bcrypt.hashSync(password, saltRounds);

    var query = conn.query("SELECT * FROM Users WHERE username = ? ", [username], function (err, results) {
        if (err) {
            console.log(err);
            return res.status(400).send("Database error");
        }

        if (results.length != 1) {
            return res.status(401).send("The username or password doesn't match");
        }

        storedHash = results[0].password;

        if (bcrypt.compareSync(password, storedHash)) {
            res.status(201).send({
                id_token: createToken({ username: username, password: storedHash })
            });
        }

        else {
            return res.status(401).send("The username or password doesn't match");
        }
    })
});