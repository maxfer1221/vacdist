"use strict";
exports.__esModule = true;
exports.admin = exports.ZIP_CODE_API_KEY = exports.usersRef = exports.db = void 0;
var dotenv = require('dotenv'); // Env vars testing
dotenv.config();
//Env vars initialization
var ZIP_CODE_API_KEY = process.env.ZIP_CODE_API_KEY;
exports.ZIP_CODE_API_KEY = ZIP_CODE_API_KEY;
var API_KEY = process.env.API_KEY;
var AUTH_DOMAIN = process.env.AUTH_DOMAIN;
var PROJECT_ID = process.env.PROJECT_ID;
var STORAGE_BUCKET = process.env.STORAGE_BUCKET;
var MESSAGING_SENDER_ID = process.env.MESSAGING_SENDER_ID;
var APP_ID = process.env.APP_ID;
var util = require('util');
var exec = util.promisify(require('child_process').exec);
var fetch = require('node-fetch');
var firebase = require('firebase'); // Firebase functionality
require('firebase/firestore');
var CronJob = require('cron').CronJob;
// initialize firestore connection
var admin = require("firebase-admin"); // Firebase admin authentication
exports.admin = admin;
var serviceAccount = require(__dirname + "/secrets/vacdist-backend-firebase-adminsdk.json");
var fbConfig = {
    credential: admin.credential.cert(serviceAccount)
};
var fbApp = admin.initializeApp(fbConfig);
var db = admin.firestore();
exports.db = db;
var usersRef = db.collection('users');
exports.usersRef = usersRef;
var express = require('express'); // Server setup
// Initialize firebase app
var firebaseConfig = {
    apiKey: API_KEY,
    authDomain: AUTH_DOMAIN,
    projectId: PROJECT_ID,
    storageBucket: STORAGE_BUCKET,
    messagingSenderId: MESSAGING_SENDER_ID,
    appId: APP_ID
};
// let google_provider =  firebase.auth.GoogleAuthProivder();
// Initialize server
var app = express();
var users = require('./users');
var sites = require('./sites');
app.use('/users', users);
app.use('/sites', sites);
// Host/Port variables
var PORT = 8080;
var host;
var port;
app.get('/*', function (req, res) {
    res.send("VacDist Firebase API. Listening at http://" + host + ":" + port);
});
var server = app.listen(PORT, function () {
    host = server.address().address;
    port = server.address().port;
    console.log("Server listening at http://" + host + ":" + port);
});
