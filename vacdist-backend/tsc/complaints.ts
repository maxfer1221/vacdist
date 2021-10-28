import { db } from './index.js';
import { verifyToken } from './tokens.js';

let express    = require('express');
let router     = express.Router();

router.use((req, res, next) => { next() });

router.post('/file', async (req, res) => {
    let error: string;
    let body: {authtoken: string, complaint: string, email: string} = req.body;
    try {
        let valid: {code: number, error: string, uid} = await verifyToken(body.authtoken);
        if(valid.code === 200){
            await db.collection('complaints').add({complaint: body.complaint, date: Date.now(), email: body.email});
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