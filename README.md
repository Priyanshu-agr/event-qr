# event-qr
An application or rather a web service to record and validate QRs for events.

## History
This project was made as a temporary arrangement for recording and validating students' entry and food coupons for the event "Anveshna", the Freshers' for School of Engineering, Jawaharlal Nehru University, New Delhi for the batch of 2022.
Although a one nighter, this works fine and got the task done with no issues after deployment. The process of scanning and validation was very smooth.

## Components
1. The backend or the web service; written in node js.
    - This service uses Google API to access and modify data from Google Sheets.
2. An android application made in Flutter.
    - This application is used to scan the QRs and send the data to the web service.

## Future Plans
1. Scale the same for general use case and make it more generic.
2. Add more features to the android application.
3. Add more features to the web service.
4. Add more validation and authentication constraints.
