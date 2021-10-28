export { admin, db, usersRef, ZIP_CODE_API_KEY, MAPS_API_KEY  };

const dotenv = require('dotenv');   // Env vars testing
dotenv.config();

//Env vars initialization
const MAPS_API_KEY        : string = process.env.MAPS_API_KEY;
const ZIP_CODE_API_KEY    : string = process.env.ZIP_CODE_API_KEY;
                
// initialize firestore connection
const admin          = require("firebase-admin"); // Firebase admin authentication
var serviceAccount   = require("./secrets/vacdist-backend-firebase-adminsdk.json");
admin.initializeApp({credential: admin.credential.cert(serviceAccount)});

const db        = admin.firestore();
      db.settings({ignoreUndefinedProperties: true});
const usersRef  = db.collection('users');
const express   = require('express');  // Server setup
let bodyParser = require('body-parser');

// Initialize server
const app   = express();

let users               = require('./users');
let sites               = require('./sites');
let supported_countries = require('./supported_countries');
let logins              = require('./logins');
let complaints          = require('./complaints');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use('/users', users);
app.use('/sites', sites);
app.use('/logins', logins);
app.use('/supported_countries', supported_countries);
app.use('/complaints', complaints);


// Host/Port variables
const PORT: number  = 80;
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