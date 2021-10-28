import { MAPS_API_KEY } from './index.js';
export { latLngFromZip, zipFromLatLng, getAddress };

let fetch = require('node-fetch');

async function getAddress(location: {latitude: number, longitude: number}) {
  let uri: string = `https://maps.googleapis.com/maps/api/geocode/json?latlng=<lat,lng>&key=<api_key>`;
  uri = uri.replace('<lat,lng>', location.latitude+','+location.longitude).replace('<api_key>', MAPS_API_KEY);
  let results = await fetch(uri);
  let json    = await results.json();

  let returnValue = {
    streetNum: '',
    streetName: '',
    street1: '',
    city: '',
    stateOrProvince: '',
    postalCode: '',
    country: ''
  };

  json.results[0].address_components.forEach((element) => {
    if(element.types.includes('street_number')){
      returnValue.streetNum = element.long_name;
    } else if(element.types.includes('route')){
      returnValue.streetName = element.long_name;
    } else if(element.types.includes('locality')){
      returnValue.city = element.long_name;
    } else if(element.types.includes('administrative_area_level_1')){
      returnValue.stateOrProvince = element.short_name;
    } else if(element.types.includes('country')){
      returnValue.country = element.long_name;
    } else if(element.types.includes('postal_code')){
      returnValue.postalCode = element.long_name;
    }
  });

  returnValue.street1 = returnValue.streetNum + ' ' + returnValue.streetName;
  delete returnValue.streetNum;
  delete returnValue.streetName;
  console.log(returnValue);
  return returnValue;
}

async function latLngFromZip(zip: string): Promise<{lat: number, long: number, zip: string}> {
  let location: {lat: number, long: number, zip: string}

  let uri: string = `https://maps.googleapis.com/maps/api/geocode/json?address=<zip>&key=<api_key>`;
  uri = uri.replace('<zip>', zip).replace('<api_key>', MAPS_API_KEY);

  let results = await fetch(uri);
  let json    = await results.json();
  if(json.status === 'OK') {
    let loc: {lat: string, lng: string} = json.results[0].geometry.location;
    location = {lat: +loc.lat, long: +loc.lng, zip: zip};
  } else {
    location = {lat: NaN, long: NaN, zip: zip};
  }
  return location;
}

async function zipFromLatLng(lat: number, lng: number): Promise<string> {
  try {
    let uri: string = `https://maps.googleapis.com/maps/api/geocode/json?latlng=<lat,lng>&key=<api_key>`;
    uri = uri.replace('<lat,lng>', lat+','+lng).replace('<api_key>', MAPS_API_KEY);
    let results = await fetch(uri);
    let json    = await results.json();
    let comps = json.results[0].address_components;

    comps = comps.filter((x) => x.types.includes('postal_code'));
    return comps[0].short_name;
  } catch (e) {
    console.log(e);
    return null;
  }
}