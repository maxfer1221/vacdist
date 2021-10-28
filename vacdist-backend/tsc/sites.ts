import { db, usersRef } from './index.js';
import { writeOptimalLocation } from './optimallocation.js';
import { verifyToken } from './tokens.js';
import { zipFromLatLng, getAddress } from './geocoding.js';
import { QuerySnapshot, DocumentData } from '@firebase/firestore-types';

const geolib = require('geolib');

let express = require('express');
let router  = express.Router()

/*  Vaccination Site interface
    id:         unique identification string for vaccine site
    name:       name to be shown on screen for users
    latitude:   latitude of vaccination site
    longitude:  longitude of vaccination site
    descriptor: description of vaccination site
*/
interface vacSite {
    id          : string,
    name        : string, 
    startDate   : string, // ISO standard; YYYY-MM-DD HH:MM:SS+UTC
    endDate     : string, // ISO standard; YYYY-MM-DD HH:MM:SS+UTC
    latitude    : number, 
    longitude   : number,
    address     : {
        street1         : string,
        street2         : string,
        street3         : string,
        city            : string,
        stateOrProvince : string,
        postalCode      : string,
        country         : string
    },
    descriptor  : string,
    spotsLeft   : number
}


router.use((req, res, next) => { next() });

router.get('/all', async (req, res) => {
    let request: {authtoken: string, dist: string, latitude: string, longitude: string} = req.query;
    try {
        let valid = await verifyToken(request.authtoken);
        if(valid.code === 200){
            let qs = await db.collection('vac_site').get();
            let sendArr = qs.docs.map(doc => docToVacSite(doc) );
            res.status(200).send(sendArr);
        } else {
            res.status(400).send(valid.error);
        }
    }
    catch (e) {
        console.log(e);
        res.status(400).send({error: e});
    }
});

router.get('/nearby', async (req, res) => {
    let request: {authtoken: string, dist: string, latitude: string, longitude: string} = req.query;
    try {
        let valid = await verifyToken(request.authtoken);
        if(valid.code === 200){
            let qs = await db.collection('vac_site').get();
            let sendArr = withinDistance(qs, +request.latitude, +request.longitude, +request.dist);
            res.status(200).send(sendArr);
        } else {
            res.status(400).send(valid.error);
        }
    }
    catch (e) {
        console.log(e);
        res.status(400).send({error: e});
    }
});


router.get('/provider', async (req, res) => {
    let request: {authtoken: string, dist: string, latitude: number, longitude: number} = req.query;
    try {
        let valid = await verifyToken(request.authtoken);
        if(valid.code === 200){
            let sites = [];

            let usersSnapshot = await usersRef.where('email', '==', valid.uid).get();
            let provider = usersSnapshot.docs[0];
            let providerName = provider.data().name;
            let qs = await db.collection('vac_site').where('provider', '==', providerName).get();

            qs.forEach((docSnap) => {
                let docData = docSnap.data();
                docData.id  = docSnap.id;
                sites.push(docData);
            })
            console.log(sites);
            res.status(200).send(sites);
        } else {
            res.status(400).send(valid.error);
        }
    }
    catch (e) {
        console.log(e);
        res.status(400).send(e.toString());
    }
})

router.get('/optimal_location', async (req, res) => {
    let query: {authtoken: string, radius: number, latitude: number, longitude: number} = req.query;
    try {
        let valid = await verifyToken(query.authtoken);
        if(valid.code === 200){
            let zipcode: string = await zipFromLatLng(query.latitude, query.longitude);
            let ol: {latitude: number, longitude: number} = await writeOptimalLocation(zipcode, query.radius);
            let address = await getAddress(ol);
            console.log(address);
            res.status(200).send({address: address, optimalCoordinates: ol});
        } else {
            res.status(400).send(valid.error);
        }
    }
    catch (e) {
        console.log(e);
        res.status(400).send(e.toString());
    }
});

router.post('/create', async (req, res) => {
    let error: string;
    let body: {string: string} = req.body;
    let decodedBody = JSON.parse(body.string);
    try {
        let valid: {code: number, error: string, uid} = await verifyToken(decodedBody.authtoken);
        if(valid.code === 200){
            let qs = await usersRef.where('email', '==', valid.uid).get()
            let providerName = qs.docs[0].data().name;
            decodedBody.site.provider = providerName;

            if(decodedBody.site.id !== ''){
                let siteRef = await db.collection('vac_site').doc(decodedBody.site.id);
                delete decodedBody.site.id;    
                await siteRef.set(decodedBody.site, { merge: true });
            } else {
                delete decodedBody.site.id;
                await db.collection('vac_site').add(decodedBody.site);
            }
            
            res.status(200).send({error:''});
            return;
        }
        error = valid.error;
    } catch (e) {
        error = e.toString();
    }
    console.log(error);
    res.status(400).send({error:error});
});

router.post('/delete', async (req, res) => {
    let error: string;
    let body: {string: string} = req.body;
    let decodedBody = JSON.parse(body.string);
    try {
        let valid: {code: number, error: string, uid} = await verifyToken(decodedBody.authtoken);
        if(valid.code === 200){
            await db.collection('vac_site').doc(decodedBody.site.id).delete();
            res.status(200).send({error:''});
            return;
        }
        error = valid.error;
    } catch (e) {
        error = e.toString();
    }
    console.log(error);
    res.status(400).send({error:error});
});

function withinDistance(qs: QuerySnapshot, lat: number, long: number, distance: number): Array<vacSite> {
    let retArr: Array<vacSite> = [];
    qs.docs.forEach((doc) => {
        let currDist = geolib.getDistance(
            {
                latitude: lat,
                longitude: long
            },
            {
                latitude: doc.data().latitude,
                longitude: doc.data().longitude
            }, 100);
        console.log(currDist*0.000621371);
        if(currDist * 0.000621371 < distance) {
            retArr.push(docToVacSite(doc));
        }
    });    
    console.log(retArr);
    return retArr;
}

function docToVacSite(doc): vacSite {
    let d = doc.data();
    let a = d.address;
    let v: vacSite = {
        id          : doc.id,
        name        : d.name, 
        startDate   : d.startDate, 
        endDate     : d.endDate, 
        latitude    : d.latitude, 
        longitude   : d.longitude,
        address     : {
            street1         : a.street1,
            street2         : a.street2 ?? '',
            street3         : a.street3 ?? '',
            city            : a.city,
            stateOrProvince : a.stateOrProvince,
            postalCode      : a.postalCode,
            country         : a.country
        },
        descriptor  : d.descriptor,
        spotsLeft   : d.spotsLeft
    };
    return v;
}

module.exports = router;
