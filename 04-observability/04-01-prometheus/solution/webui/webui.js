var express = require('express');
var app = express();
var redis = require('redis');
var swStats = require('swagger-stats');    

var client = redis.createClient(6379, 'redis');
client.on("error", function (err) {
    console.error("Redis error", err);
});

app.get('/', function (req, res) {
    res.redirect('/index.html');
});

app.use(swStats.getMiddleware());

app.get('/json', function (req, res) {
    client.hlen('wallet', function (err, coins) {
        client.get('hashes', function (err, hashes) {
            var now = Date.now() / 1000;
            res.json( {
                coins: coins,
                hashes: hashes,
                now: now
            });
        });
    });
});

app.get('/info', function (req, res) {
  res.setHeader('Content-Type', 'application/json');
  res.end(JSON.stringify({ version: 3 }));
})

app.use(express.static('files'));

var server = app.listen(80, function () {
    console.log('WEBUI running on port 80');
});

