const express = require("express");
const app = express();
const bp = require("body-parser");
const crypto = require('crypto');
const qr = require("qrcode");
const {
    getAuthToken,
    getSpreadSheet,
    getSpreadSheetValues,
    updateValues,
    updateHashes
} = require('./googleSheetsService.js');
require('dotenv').config();

const spreadsheetId = process.env.SHEETID;
const sheetName = process.env.SHEETNAME;

app.set("view engine", "ejs");
app.use(bp.urlencoded({ extended: false }));
app.use(bp.json());

app.get("/", (req, res) => {
    res.render("index");
})

// 4 response values: "Scanned", "Already scanned", "Not found", "no_checkin"
app.post("/scan", async (req, res) => {
    const { time, email } = req.body;
    const algorithm = 'aes256';
    // const secret = 'hackjnu3.0';

    try {
        const key = 'ExchangePasswordPasswordExchange';
        const encryptedArray = email.split('::');
        const iv = encryptedArray[1];
        const auth = await getAuthToken();
        const response = await getSpreadSheetValues({
            spreadsheetId,
            sheetName,
            auth
        });
        let decipher = crypto.createDecipheriv(algorithm, key, iv);
        let decrypted = decipher.update(encryptedArray[0], 'hex', 'utf8') + decipher.final('utf8');
        // console.log('output for getSpreadSheetValues', JSON.stringify(response.data, null, 2));
        // console.log(response.data.values[1]);
        for (let i = 1; i < response.data.values.length; i++) {
            console.log(response.data.values[i][1]);
            console.log(decrypted);
            let email_sheet = response.data.values[i][0];
            console.log(decrypted === email_sheet)
            if (String(email_sheet) === decrypted) {
                if (time === 'lunch') {
                    if (response.data.values[i][3] === "1") {
                        res.send("already_scanned");
                        return;
                    }
                    else if (response.data.values[i][2] == 'rsvp') {
                        res.send("no_checkin");
                        return;
                    }
                    else {
                        const range = `H${i + 1}`;
                        const values = [["1"]];

                        try {
                            const response = await updateValues({
                                spreadsheetId,
                                auth,
                                sheetName,
                                range,
                                values
                            })
                            console.log('output for updateValues', JSON.stringify(response.data, null, 2));
                        } catch (error) {
                            console.log(error.message, error.stack);
                        }
                        res.send("scanned");
                        return;
                    }
                }
                else if (time === 'dinner') {
                    if (response.data.values[i][4] === "1") {
                        res.send("already_scanned");
                        return;
                    }
                    else if (response.data.values[i][2] == 'rsvp') {
                        res.send("no_checkin");
                        return;
                    }
                    else {
                        const range = `I${i + 1}`;
                        const values = [["1"]];

                        try {
                            const auth = await getAuthToken();
                            const response = await updateValues({
                                spreadsheetId,
                                auth,
                                sheetName,
                                range,
                                values
                            })
                            console.log('output for updateValues', JSON.stringify(response.data, null, 2));
                        } catch (error) {
                            console.log(error.message, error.stack);
                        }
                        res.send("scanned");
                        return;
                    }
                }
                else if (time === 'breakfast') {
                    if (response.data.values[i][5] === "1") {
                        res.send("already_scanned");
                        return;
                    }
                    else if (response.data.values[i][2] == 'rsvp') {
                        res.send("no_checkin");
                        return;
                    }
                    else {
                        const range = `J${i + 1}`;
                        const values = [["1"]];

                        try {
                            const auth = await getAuthToken();
                            const response = await updateValues({
                                spreadsheetId,
                                auth,
                                sheetName,
                                range,
                                values
                            })
                            console.log('output for updateValues', JSON.stringify(response.data, null, 2));
                        } catch (error) {
                            console.log(error.message, error.stack);
                        }
                        res.send("scanned");
                        return;
                    }
                }
            }
        }
        res.send("not_found");
        res.return(response.data.values);
    } catch (error) {
        console.log(error.message, error.stack);
    }
});

app.get("/generate", async (req, res) => {
    try {
        const auth = await getAuthToken();
        const response = await getSpreadSheetValues({
            spreadsheetId,
            sheetName,
            auth
        });
        const algorithm = 'aes256';
        // const secret = 'hackjnu3.0';
        const key = 'ExchangePasswordPasswordExchange';
        const iv = crypto.randomBytes(8).toString('hex');
        const qrs = [];
        for (let i = 1; i < response.data.values.length; i++) {
            // const hash = crypto.createHash('md5').update(response.data.values[i][0]).digest('hex');
            const cipher = crypto.createCipheriv(algorithm, key, iv);
            const encrypte = cipher.update(response.data.values[i][0], 'utf8', 'hex') + cipher.final('hex');
            const encrypted = encrypte + '::' + iv;

            const generateQR = async text => {
                try {
                    return (await qr.toDataURL(text))
                } catch (err) {
                    console.error(err)
                }
            }
            // console.log(encrypted);
            const qrd = await generateQR(encrypted);
            qrs.push(qrd);
        }
        let values = [qrs];
        let range = 'K2:K';
        const response2 = await updateHashes({
            spreadsheetId,
            auth,
            range,
            values
        });
        console.log('output for updateValues', JSON.stringify(response2.data, null, 2));
        res.send('QRs generated');
    }
    catch (error) {
        console.log(error.message, error.stack);
    }

});

const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log("Listening to port " + port + "...");
})