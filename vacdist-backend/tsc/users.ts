import { auth } from 'firebase-admin';
import { usersRef, admin, db } from './index.js';
import { verifyToken } from './tokens.js';

let express    = require('express');
let router     = express.Router();

router.use((req, res, next) => { next() });
    
router.get('/login', async (req, res) => {
    try {
        let query: {email: string, pass: string} = req.query;
        let qs = await usersRef.where('email', '==', query.email.toLowerCase()).get();

        if(qs.docs.empty){
            res.status(401).send('Email and password combination could not be found'); 
            return;
        } else {
            let userData = qs.docs[0].data();
            if(userData.passwordHash === query.pass){
                let customToken = await admin.auth().createCustomToken(userData.email);
                res.status(200).json({'customToken': customToken});
                return;
            } else {
                res.status(401).send('Email and password combination could not be found'); 
                return;
            }
        }
    }
    catch (e) {
        res.status(403).send('Invalid Credentials');
    }
});

router.get('/reservation_status', async (req, res) => {
    let error: string;
    let query: {authtoken: string, site: string} = req.query;
    try {
        let valid: {code: number, error: string, uid} = await verifyToken(query.authtoken);
        if(valid.code === 200){
            let user = await usersRef.doc(valid.uid).get();
            if(!user.exists){
                res.status(200).json({reservationStatus: false});
                return;
            }
            let reservationStatus = user.data().reservationStatus;
            res.status(200).json({ reservationStatus: reservationStatus === query.site })
            return;
        }
        error = valid.error;
    } catch (e) {
        error = e.toString();
    }
    res.status(400).send(error);
});

router.get('/reservation_site', async (req, res) => {
    let error: string;
    let query: {authtoken: string, site: string} = req.query;
    try {
        let valid: {code: number, error: string, uid} = await verifyToken(query.authtoken);
        if(valid.code === 200){
            let user = await usersRef.doc(valid.uid).get();
            if(!user.exists){
                res.status(300).json('');
                return;
            }
            let reservationStatus = user.data().reservation;
            console.log(user.id);
            let site = await db.collection('vac_site').doc(reservationStatus).get();
            let siteData = site.data();
            siteData.id = reservationStatus;
            res.status(200).json(siteData);
            return;
        }
        error = valid.error;
    } catch (e) {
        error = e.toString();
    }
    console.log(error);
    res.status(400).send(error);
});

router.post('/reservation_status', async (req, res) => {
    let error: string;
    let body: {authtoken: string, reservation: string} = req.body;
    try {
        let valid: {code: number, error: string, uid} = await verifyToken(body.authtoken);
        if(valid.code === 200) {
            await usersRef.doc(valid.uid).set({reservation: body.reservation}, { merge:true });
            res.status(200).send('');
            return;
        }
        error = valid.error;
    } catch (e) {
        error = e.toString();
    }
    res.status(400).send(error);
});

router.get('/providers', async (req, res) => {
    let error: string;
    try {
        let qs  = await usersRef.where('type', '==', 'provider').get();
        let ret = qs.docs.map((doc) => { return {id: doc.id, name: doc.data().name} });
        res.status(200).send(ret);
    } catch (e) {
        error = e.toString();
    }
    res.status(400).send(error);
});

router.post('/signup', async (req, res) => {

});

router.get('/testdir', async (req, res) => {
    let qs = await usersRef.get();
    let firstDoc = qs.docs[0].data();
    res.send(firstDoc);
});

module.exports = router;