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


        var query = conn.query("INSERT INTO Users set ? ", user, function (err, results) {
            if (err) {
                console.log(err);
                return res.status(400).send("Database error");
            }
            res.status(200).send({
                id_token: createToken(user)
            });
        });
    });
});

app.post('/authenticate', function (req, res) {
    var username = req.body.username;
    var password = req.body.password;

    if (!username || !password) {
        return res.status(400).send("Please enter your username and password");
    }



    var searchField = req.body.searchField;

    var query = 'SELECT * FROM GiftCertificates ORDER BY ? ' + [searchField];

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

app.get('/users/:page?', function (req, res) {
    var users = [{ name: 'Alice', id: '1' }, { name: 'Bob', id: '2' }];
    return res.status(200).json(JSON.stringify(users));
});

app.delete('/users/:id', function (req, res) {
    if (!req.params.id) {
        return res.status(400).send("No id supplied");
    }

    return res.status(200);
});

app.get('/users/:id', function (req, res) {
    if (!req.params.id) {
        return res.status(400).send("No id supplied");
    }

    if (req.params.id !== 1) {
        return res.status(401).send("Resource not found");
    }

    user = {
        username: 'Alice',
        last_name: 'Brown',
        first_name: 'Alice'
    }

    return res.status(200).json(user);
});