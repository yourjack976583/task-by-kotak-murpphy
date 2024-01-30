'use strict';

const express = require('express')
const app = express();

const port = 8080;
const host = '0.0.0.0';

app.get('/', (req, res) => {
  res.send('Hello World from Jayant kute docker image jxkute !');
})

app.listen(port, host);
console.log(`Running on http://${host}:${port}`);
