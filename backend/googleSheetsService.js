const { google } = require('googleapis');
const sheets = google.sheets('v4');
require('dotenv').config();

const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];
const GCLOUD_PROJECT = process.env.PROJECTID;


async function getAuthToken() {
    const auth = new google.auth.GoogleAuth({
        scopes: SCOPES,
        keyFile: './qr-code-412309-ab8317250450.json'
    });
    const authToken = await auth.getClient();
    return authToken;
}

async function getSpreadSheet({ spreadsheetId, auth }) {
    const res = await sheets.spreadsheets.get({
        spreadsheetId,
        auth,
    });
    return res;
}

async function getSpreadSheetValues({ spreadsheetId, auth, sheetName }) {
    const res = await sheets.spreadsheets.values.get({
        spreadsheetId,
        auth,
        range: sheetName
    });
    return res;
}

async function updateValues({ spreadsheetId, auth, sheetName, range, values }) {
    const resource = { values };
    try {
        const res = await sheets.spreadsheets.values.update({
            spreadsheetId,
            auth,
            range,
            valueInputOption: 'USER_ENTERED',
            resource,
        });
        console.log(`Updated ${res.data.updatedCells} cells`);
        return res;
    } catch (err) {
        throw err;
    }
}

async function updateHashes({ spreadsheetId, auth, range, values }) {
    const resource = {
        majorDimension: 'COLUMNS',
        values: values,
        
    };
    try {
        const res = await sheets.spreadsheets.values.update({
            resource,
            spreadsheetId,
            auth,
            range,
            valueInputOption: "USER_ENTERED"
        });
        console.log(`Updated ${res.data.updatedCells} cells`);
        return res;
    }
    catch (err) {
        throw err;
    }
}


module.exports = {
    getAuthToken,
    getSpreadSheet,
    getSpreadSheetValues,
    updateValues,
    updateHashes
}
