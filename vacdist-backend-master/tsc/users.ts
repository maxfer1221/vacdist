import { db, usersRef, admin } from './index.js';

let express = require('express');
let router  = express.Router();

router.use((req, res, next) => { next() });
    
router.get('/login', async (req, res) => {
    let query: {email: string, pass: string} = req.query;
    let qs = await usersRef.where('email', '==', query.email)
                        .where('passwordHash', '==', query.pass)
                        .get();
    if(qs.empty){
        res.status(401).send('Email and password combination could not be found'); 
        return;
    }
    let userData = qs.docs[0].data();
    let customToken = await admin.auth().createCustomToken(userData.email);
    res.status(200).send({'customToken': customToken});
});

router.post('/signup', async (req, res) => {

});

module.exports = router;