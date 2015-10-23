/**
 * Created by santi8ago8 on 10/17/2015.
 */


var express = require('express');
var app = express();
var fs = require('fs');

var compression = require('compression')


app.use(compression());
app.use('/', express.static('./'));

app.get('*', function (req, res) {
    res.send(fs.readFileSync('./index.html'));
});

var server = app.listen(3000, function () {
    var host = server.address().address;
    var port = server.address().port;

    console.log('Example app listening at http://%s:%s', host, port);
});

