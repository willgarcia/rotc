const express = require('express');
const app = express();
const prometheus = require('prom-client');
const collectDefaultMetrics = prometheus.collectDefaultMetrics;

// gauge metrics
const nodeRandomValue = new prometheus.Gauge({
    name: 'node_random_value',
    help: 'random value generated in node'
});

// Probe every 5th second.
collectDefaultMetrics({ timeout: 5000 });

app.get('/', (req, res) => {
    console.log('request made');
    nodeRandomValue.set(Math.random());
    res.send("home page");
})

app.get('/metrics', (req, res) => {
    res.set('Content-Type', prometheus.register.contentType)
    res.end(prometheus.register.metrics())
  })

app.listen(8082, () => console.log(`Example app listening on port 8082!`))