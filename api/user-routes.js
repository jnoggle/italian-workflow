var express = require('express'),
    _ = require('lodash'),
    config = require('./config'),
    jwt = require('jsonwebtoken'),
    mysql = require('mysql');

var app = module.exports = express.Router();

var users = [{
    id: 1,
    username: 'admin',
    password: 'admin'
}];

function createToken(user) {
    return jwt.sign(_.omit(user, 'password'), config.secret, { expiresIn: 60 * 60 * 5 });
}

app.post('/users', function (req, res) {
    if (!req.body.username || !req.body.password) {
        return res.status(400).send("Please enter your username and password");
    }

    if (_.find(users, req.body.username)) {
        return res.status(400).send("There is already a user with that name");
    }

    var user = _.pick(req.body, 'username', 'password');
    user.id = _.max(users, 'id').id + 1;

    users.push(user);

    res.status(201).send({
        id_token: createToken(user)
    });
});

app.post('/sessions/create', function (req, res) {
    if (!req.body.username || !req.body.password) {
        return res.status(400).send("Please enter your username and password");
    }

    var user = _.find(users, { username: req.body.username });

    if (!user) {
        return res.status(401).send("The username or password doesn't match");
    }

    if (user.password !== req.body.password) {
        return res.status(401).send("The username or password doesn't match");
    }

    res.status(201).send({
        id_token: createToken(user)
    });
});