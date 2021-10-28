# Vacdist Backend

## Back-end functionality for the VacDist Patient and VacDist Provider applications. Utilized GCP, Firebase, Firestore, compute engines, and python child processes.

## To utilize properly:
(Ensure python3, pip, node, and node-typescript are installed)

1. Create a `.env` file with the following format:
    ```
    API_KEY=<Firebase API key>
    AUTH_DOMAIN=<Firebase auth domain>
    PROJECT_ID=<Firebase project id>
    STORAGE_BUCKET=<Firebase storage bucket>
    MESSAGING_SENDER_ID=<Firebase messaging sender ID>
    APP_ID=<Firebase app ID>
    ZIP_CODE_API_KEY=<ID for ZipCodeApi>
    ```
1. Place your `project-firebase-adminsdk.json` in `project-root/secret/`
1. `npm run-script f_install` to install all dependencies
1. `npm run-script b_start` to compile typescript files and start server