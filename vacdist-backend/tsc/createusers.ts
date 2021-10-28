import { usersRef } from './index.js';
export { createUser };

async function createUser(email: string, password: string): Promise<{code: number, error: string}> {
    try {
        const res = await usersRef.add({
            email: email,
            passwordHash: password,
            type: 'provider',
        })
        return {code: 200, error: null};
    } catch(e) {
        return {code: 400, error: e.toString()};
    }
}