# vacdist_provider

Assists in decentralizing vaccine distribution and opening 2-way communication between healthcare providers and patients in developing countries.

## Build Instructions

Place your `google-services.json` file under `android/app`. Also ensure you have a `.env` file in the top-level directory, formatted like so:

```
export ANDROID_GOOGLE_MAPS_API_KEY=<Key goes here>
export IOS_GOOGLE_MAPS_API_KEY=<Key goes here>
export API_URI=<API URI goes here>
```

Remember to omit the brackets.

Ensure that your [SHA-1 fingerprint of your debug signing certificate](https://developers.google.com/android/guides/client-auth) is registered with Firestore.

Run `source .env` in your Terminal shell to bring the variables into the active environment. Then, run `make` to replace the environment variables and build the app. If it is successful, you can start up your Android emulator and do `make test` to run it on the emulator. Alternatively you can let your editor (IntelliJ or Visual Studio Code) handle the emulator.
