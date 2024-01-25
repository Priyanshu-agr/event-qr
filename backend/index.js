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

// 3 response values: "Scanned", "Already scanned", "Not found"
app.post("/scan", async (req, res) => {
    const { time,email } = req.body;
    try {
        const auth = await getAuthToken();
        const response = await getSpreadSheetValues({
            spreadsheetId,
            sheetName,
            auth
        });
        // console.log('output for getSpreadSheetValues', JSON.stringify(response.data, null, 2));
        // console.log(response.data.values[1]);
        for (let i = 1; i < response.data.values.length; i++) {
            console.log(response.data.values[i][1]);
            console.log(email);
            let email_sheet = response.data.values[i][0];
            console.log(email === email_sheet)
            if (String(email_sheet) === email) {
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
                        let range = `H${i + 1}`;
                        let values = [["1"]];

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
                        let range = `I${i + 1}`;
                        let values = [["1"]];

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
                        let range = `J${i + 1}`;
                        let values = [["1"]];

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
        const qrs = [];
        for (let i = 1; i < response.data.values.length; i++) {
            const hash = crypto.createHash('md5').update(response.data.values[i][0]).digest('hex');
            qr.toDataURL(hash, (err, src) => {
                if (err) res.send("Error");
                console.log(src);
                qrs.push(src);    
                // res.render("generate", { src });
            });
        }
        const range = 'K1:K';
        const values = [qrs];
        const response2 = await updateHashes(
            spreadsheetId,
            auth,
            range,
            values
        );
        res.send('QRS generated');
        
    }
    catch (error) {
        console.log(error.message, error.stack);
    }

});

const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log("Listening to port " + port + "...");
})