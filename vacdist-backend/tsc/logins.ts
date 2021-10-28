import { db } from './index.js';
import { verifyToken } from './tokens.js';

let express    = require('express');
let router     = express.Router();

router.use((req, res, next) => { next() });

router.post('/save', async (req, res) => {
    let error: string;
    let body: {authtoken: string, zip: string} = req.body;
    try {
        let valid: {code: number, error: string, uid} = await verifyToken(body.authtoken);
        if(valid.code === 200){
            await db.collection('logins').add({zip: body.zip, date: Date.now()});
            res.status(200).send('');
            return;
        }
        error = valid.error;
    } catch (e) {
        error = e.toString();
    }
    res.status(400).send(error);
});

module.exports = router;

