# Vacdist Backend

## Back-end functionality for the Vacdist Patient and Vacdist Provider applications. Utilized GCP, Firebase, Firestore, and compute engines.

### Architecture
The Vacdist back-end architecture consists of 4 compute engines running Debian 10.
3 of these Debian VMs are tasked with administrating our Firebase project: authorizing user access/login, CRUD Firestore operations, and managing app testing. This is done through TypeScript-compiled JavaScript: 3 identical RESTful APIs created with ExpressJS.
The fourth VM instance operates an NGINX HTTPS load balancer with SSL encryption. The VM distributes the API calls to the 3 Firebase administrator instances and conducts periodic health checks.

### Setup
The back-end for Vacdist has been set up on the Google Cloud Platform and thus needs no setup.

## Modules and Packages Utilized

- [cron](https://www.npmjs.com/package/cron): task scheduling, conduct firestore data managment
- [dotenv](https://www.npmjs.com/package/dotenv): enviornment variable testing during development
- [express](https://www.npmjs.com/package/express): manage API get/post requests
- [firebase](https://www.npmjs.com/package/firebase): connect to firebase
- [firebase-admin](https://www.npmjs.com/package/firebase-admin): authorize users, manage firestore data
- [forever](https://www.npmjs.com/package/forever): ensure scripts run continously
- [Geolib](https://www.npmjs.com/package/geolib): distance calculation for coordinate pairs
- [node-fetch](https://www.npmjs.com/package/node-fetch): create get/post requests to Google and external APIs
- [Node Schedule](https://www.npmjs.com/package/node-schedule): task scheduling, conduct firestore data managment
