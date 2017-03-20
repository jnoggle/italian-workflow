var express = require('express'),
    http = require('http'),
    cors = require('cors'),
    bodyParser = require('body-parser');

var app = express();

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());
app.use(cors());

app.use(require('./user-routes'));
app.use(require('./gift-certificate-routes'));

var port = process.env.PORT || 3001;

http.createServer(app).listen(port, function (err) {
    console.log('listening at http://localhost:' + port);
});