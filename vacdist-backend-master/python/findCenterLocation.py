# input:
# { zip: appearance_count, zip: appearance_count,
# output:
# { latitude: double, longitude: double }

def findCenterLocation(zipcodeDict, API_KEY):
    import googlemaps
    gmaps = googlemaps.Client(key=API_KEY)

    total_coordinates = 0
    lat_total = 0
    lng_total = 0

    for code, count in zipcodeDict.items():
        # Get the lat and lng of this zipcode
        geocode_result = gmaps.geocode(code)
        lat = geocode_result[0]['geometry']['location']['lat']
        lng = geocode_result[0]['geometry']['location']['lng']

        # Update the total count of zipcodes
        total_coordinates += count

        # Update the sum of all lats and lngs
        lat_total += lat * count
        lng_total += lng * count
    
    # Get the center of the coordinates using an arithmetic average
    lat_center = lat_total / total_coordinates
    lng_center = lng_total / total_coordinates

    center_coordinates = {'latitude': lat_center, 'longitude': lng_center}
    return center_coordinates


# Node communication module
import sys
import demjson as json

zips = json.decode(sys.argv[1])
api_key = sys.argv[2]

print(findCenterLocation(zips, api_key))

sys.exit(0)
