const { google } = require('googleapis');
const sheets = google.sheets('v4');

const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];

async function getAuthToken() {
    const auth = new google.auth.GoogleAuth({
        scopes: SCOPES
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


module.exports = {
    getAuthToken,
    getSpreadSheet,
    getSpreadSheetValues,
    updateValues
}
