import { writeOptimalLocation, runPythonScript } from './python.js';
import { createUser } from './createusers.js';
import { verifyToken } from './tokens.js';
export { db, usersRef, ZIP_CODE_API_KEY, admin };

const dotenv = require('dotenv');   // Env vars testing
dotenv.config();

//Env vars initialization
const ZIP_CODE_API_KEY    : string = process.env.ZIP_CODE_API_KEY;
const API_KEY             : string = process.env.API_KEY;
const AUTH_DOMAIN         : string = process.env.AUTH_DOMAIN;
const PROJECT_ID          : string = process.env.PROJECT_ID;
const STORAGE_BUCKET      : string = process.env.STORAGE_BUCKET;
const MESSAGING_SENDER_ID : string = process.env.MESSAGING_SENDER_ID;
const APP_ID              : string = process.env.APP_ID;

const util     = require('util');
const exec     = util.promisify(require('child_process').exec);
const fetch    = require('node-fetch');
const firebase = require('firebase'); // Firebase functionality
                 require('firebase/firestore');
const CronJob  = require('cron').CronJob;                              
                 
// initialize firestore connection
const admin          = require("firebase-admin"); // Firebase admin authentication
const serviceAccount = require(__dirname + "/secrets/vacdist-backend-firebase-adminsdk.json");
const fbConfig       = {
    credential: admin.credential.cert(serviceAccount), // TBD, change to GCP convention
};
const fbApp       = admin.initializeApp(fbConfig);

const db        = admin.firestore();
const usersRef  = db.collection('users');

const express   = require('express');  // Server setup

// Initialize firebase app
const firebaseConfig = {
    apiKey:             API_KEY,
    authDomain:         AUTH_DOMAIN,
    projectId:          PROJECT_ID,
    storageBucket:      STORAGE_BUCKET,
    messagingSenderId:  MESSAGING_SENDER_ID,
    appId:              APP_ID,
};

// let google_provider =  firebase.auth.GoogleAuthProivder();

// Initialize server
const app   = express();

var users = require('./users');
var sites = require('./sites');

app.use('/users', users);
app.use('/sites', sites);

// Host/Port variables
const PORT: number  = 8080;
let   host: string;
let   port: number;

app.get('/*', (req, res) => {
    res.send(`VacDist Firebase API. Listening at http://${host}:${port}`);
});

const server = app.listen(PORT, () => {
    host     = server.address().address;
    port     = server.address().port;

    console.log(`Server listening at http://${host}:${port}`);
});