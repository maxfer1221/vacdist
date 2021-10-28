import { admin } from './index.js';
export { verifyToken };

async function verifyToken(idToken: string): Promise<{code: number, error: string, uid: any}> {
    try {
        let decodedToken = await admin.auth().verifyIdToken(idToken);
        const uid = decodedToken.uid;
        return {code: 200, error: '', uid: uid};
    } catch(error) {
        console.log(error);
        return {code: 403, error: 'Unauthorized', uid: ''};
    }
}