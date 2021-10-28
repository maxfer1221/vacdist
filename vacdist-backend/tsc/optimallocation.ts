import { app } from 'firebase-admin';
import { latLngFromZip } from './geocoding.js';
import { db, MAPS_API_KEY, usersRef, ZIP_CODE_API_KEY } from './index.js';
export { writeOptimalLocation };

const util     = require('util');
const exec     = util.promisify(require('child_process').exec);
const fetch    = require('node-fetch');

/*  Location interface
    lat:  latitude of location
    long: longitude of location
*/
interface location {
    lat  : number,
    long : number,
}

// ======================== //
// Optimal Location Scripts //
// ======================== //

async function writeOptimalLocation(zip: string, radius: number): Promise<{latitude: number, longitude: number}> {
    let location: {latitude: number, longitude: number} = await findOptimalLocation(zip);
    const res = await db.collection('optimal_locations').add({
        zip: zip,
        lat: location.latitude,
        long: location.longitude,
        date_created: new Date(Date.now())
    });
    return location;
}

async function findOptimalLocation(zip: string): Promise<{latitude: number, longitude: number}> {
    const radius: number = 5;
    let zips: Array<any> = await zipCodesFromRadius(zip, radius);
    let appearances: Array<{zip: string, appearances: number}> = await findZipAppearances(zips);
    let optimalCoords = await calculateOptimalLocation(appearances);
    
    return optimalCoords;
}

async function findZipAppearances(zips: Array<string>): Promise<Array<{zip: string, appearances: number}>> {
    let results: Array<any> = [];
    while(zips.length){
        let short_zips: Array<string> = zips.splice(0,10)
        let loginColl = await db.collection('logins');
        let res = await loginColl.where('zip', 'in', short_zips).get();
        res.docs.forEach((doc) => {
            results.push(doc.data().zip);
        })
    }
    let appearances = [];
    results.forEach((zip) => {
        for(let i = 0; i < appearances.length; i++) {
            if(appearances[i].zip === zip) {
                appearances[i].apps = appearances[i].appearances + 1;
                continue;
            }
        }
        appearances.push({zip: zip, appearances: 1});
    })
    return appearances;
}

function zipCodeApi_get(zip: string, radius: number): Promise<any> {
    let uri: string = `https://www.zipcodeapi.com/rest/<api_key>/radius.json/<zip>/<radius>/mile`;
    uri = uri.replace('<zip>', zip).replace('<radius>', '' + radius).replace('<api_key>', ZIP_CODE_API_KEY);
    return fetch(uri);
}

async function zipCodesFromRadius(zip: string, radius: number): Promise<Array<{zip_code: string}>>{
    let res  = await zipCodeApi_get(zip, radius);
    let json = await res.json();
    return json.zip_codes.map((el: {zip_code: number}) => el.zip_code);
}

async function calculateOptimalLocation(appearances: Array<{zip: string, appearances: number}>): Promise<{latitude: number, longitude: number}> { 
    let coords: Array<{lat: number, long:number, weight: number}> = []; 
    let ret: Array<{lat: number, long: number, zip: string}> = await Promise.all(appearances.map((zip) => latLngFromZip(zip.zip)));
    appearances.forEach(el => {
        for(let i = 0; i < ret.length; i++){
            if(ret[i].zip === el.zip){
                coords.push({lat: ret[i].lat, long: ret[i].long, weight: el.appearances})
                ret.splice(i,1);
                continue;
            }
        }
    })

    let weightSums = 0;
    let latSum = 0;
    let lngSum = 0;
    let ideal: {latitude: number, longitude: number};
    coords.forEach(coord => {
        latSum += coord.lat  * coord.weight;
        lngSum += coord.long * coord.weight;
        weightSums += coord.weight;
    });
    
    ideal = {latitude: latSum/weightSums, longitude: lngSum/weightSums};

    console.log(ideal);

    return ideal;
}