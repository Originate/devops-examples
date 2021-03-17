'use strict';

const express = require('express');
const { Pool } = require('pg');

// Server config
const HOST = process.env.HOST || '0.0.0.0';
const PORT = process.env.PORT || 3000;

// App
const app = express();
const pool = new Pool();

app.get('/', (req, res) => {
  res.send('Hello, World');
});

app.get('/healthcheck', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.send('Healthy');
  } catch (err) {
    console.log(err.stack);
    res.status(500).send('Unhealthy');
  }
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
