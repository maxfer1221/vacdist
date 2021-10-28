import { db } from './index.js';
import { verifyToken } from './tokens.js';

let express = require('express');
let router  = express.Router();

router.use((req, res, next) => { next() });
    
router.get('/all', async (req, res) => {
    let query: {authtoken: string} = req.query;
    let valid: {code: number} = await verifyToken(query.authtoken);

    if(valid.code === 200){
        let allsites: Array<string> = [];
        let qs = await db.collection('supported_countries').get();
        qs.docs.forEach((doc) => {
            allsites = allsites.concat(doc.data().countries);
        });
        res.status(200).send(allsites);
        return;
    }
    res.status(403).send('Invalid token');
});

module.exports = router;