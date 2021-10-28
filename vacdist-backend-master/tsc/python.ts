import { db, usersRef, ZIP_CODE_API_KEY } from './index.js';
export { writeOptimalLocation, runPythonScript };

const util     = require('util');
const exec     = util.promisify(require('child_process').exec);
const fetch    = require('node-fetch');

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
    start_date  : string, // ISO standard; YYYY-MM-DD HH:MM:SS+UTC
    end_date    : string, // ISO standard; YYYY-MM-DD HH:MM:SS+UTC
    latitude    : number, 
    longitude   : number,
    address     : string,
    descriptor  : string,
}

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

async function writeOptimalLocation(zip: number) {
    let location: {lat: number, long: number} = await findOptimalLocation(zip);
    const res = await db.collection('optimal_locations').add({
        zip: zip,
        lat: location.lat,
        long: location.long,
        date_created: new Date(Date.now())
    });
    return;
}

async function findOptimalLocation(zip: number): Promise<{lat: number, long: number}> {
    // Radius is arbitrarily set to 5 miles
    const radius: number = 5;
    let zips: number[] = await zipCodesFromRadius(zip, radius);
    let appearances: Array<{zip: number}> = await findZipAppearances(zips);
    let pyout: pyout =  await runPythonScript(`./python/optimalLocation.py`, [JSON.stringify(appearances)]);
    if(!pyout.error){
        return JSON.parse(pyout.scriptOutput);
    }
    return {
        lat: undefined,
        long: undefined,
        ...pyout
    };
}

async function findZipAppearances(zips: Array<number>): Promise<Array<{zip:number}>> {
    let results: Array<{zip: number}> = [];
    while(zips.length > 0){
        let short_zips: Array<number> = zips.splice(0,10)
        let users = await usersRef.where('zip', 'in', short_zips).get();
        results.concat(users);
    }
    results.map((el: {zip: number}) => el.zip)
    return results;
}

function zipCodeApi_get(zip: number, radius: number): Promise<any> {
    let uri: string = `https://www.zipcodeapi.com/rest/<api_key>/radius.json/<zip>/<radius>/mile`;
    uri = uri.replace('<zip>', '' + zip).replace('<radius>', '' + radius).replace('<api_key>', ZIP_CODE_API_KEY);
    return fetch(uri);
}

async function zipCodesFromRadius(zip: number, radius: number): Promise<number[]>{
    let res  = await zipCodeApi_get(zip, radius);
    let json = await res.json();
    return json.zip_codes.map((el: {zip_code: number}) => el.zip_code);
}

interface pyout {
    scriptOutput: string,
    scriptError:  string,
    error:        boolean
};

async function runPythonScript(pathToScript: string, parameters?: string[]): Promise<pyout> {
    const { stdout, stderr } = await exec(`py "${pathToScript}" ${parameters.join(' ')}`);

    return {
        scriptOutput: stdout,
        scriptError:  stderr,
        error:        !!stderr
    };
}