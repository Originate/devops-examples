'use strict';

const express = require('express');

// Constants
const HOST = process.env.HOST || '0.0.0.0';
const PORT = process.env.PORT || 3000;

// App
const app = express();
app.get('/', (req, res) => {
  res.send('Hello, World');
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
