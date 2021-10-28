import { admin, db } from './index.js';

const geolib = require('geolib');

let express = require('express');
let router  = express.Router()

router.use((req, res, next) => { next() });

router.get('/nearby', async (req, res) => {
    let request: {authtoken: string, dist: number, lat: number, long: number} = JSON.parse(req.params);
    try {
        let decodedToken = await admin
            .auth()
            .verifyIdToken(request.authtoken);
        let qs = await db.collection('vac_site').get();
        qs.docs.forEach((doc) => {
            doc.distance = geolib.getDistance(
                {
                    latitude: request.lat,
                    longitude: request.long
                },
                {
                    latitude: doc.latitude,
                    longitude: doc.longitude
                });
        });
        qs.docs.sort((a, b) => a.distance - b.distance);
        for(let i = 0; i < qs.docs.length; i++){
            if(qs.docs[i].distance > request.dist){
                res.send(qs.docs.slice(0, i+1));
            }
        }
        res.status(200).send(qs.docs);
    }
    catch (e) {
        res.status(400).send({error: e});
    }
})

router.post('/optimal', (req, res) => {
    
});

module.exports = router;
