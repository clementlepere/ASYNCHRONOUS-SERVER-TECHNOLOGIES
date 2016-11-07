var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send('Hello World!');
});

app.post('/', function (req, res) {
  res.send('POST request to homepage');
});

app.put('/', function (req, res) {
  res.send('PUT request to homepage');
});

app.delete('/', function (req, res) {
  res.send('DELETE request to homepage');
});

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});
