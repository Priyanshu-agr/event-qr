const express = require("express");
const app = express();
const bp = require("body-parser");
const qr = require("qrcode");
const {
    getAuthToken,
    getSpreadSheet,
    getSpreadSheetValues,
    updateValues
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
app.post("/scan/:id", async (req, res) => {
    const { id } = req.params;
    console.log(id);
    try {
        const auth = await getAuthToken();
        const response = await getSpreadSheetValues({
            spreadsheetId,
            sheetName,
            auth
        })
        //   console.log('output for getSpreadSheetValues', JSON.stringify(response.data, null, 2));
        //   console.log(response.data.values[1]);
        for (let i = 1; i < response.data.values.length; i++) {
              console.log(response.data.values[i][1]);
              console.log(id);
              let id_sheet = response.data.values[i][1];
              console.log(id===id_sheet)
            if (String(id_sheet) === id) {
                if (response.data.values[i][4] === "1") {
                    res.send("Already scanned");
                    return;
                }
                else {
                    let range = `Junior_Response!E${i + 1}`;
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
                    res.send("Scanned");
                    return;
                }
            }
        }
        res.send("Not found");
    } catch (error) {
        console.log(error.message, error.stack);
    }
})

app.post("/generate", (req, res) => {
    const url = req.body.url;

    if (url.length === 0) res.send("Empty data");

    qr.toDataURL(url, (err, src) => {
        if (err) res.send("Error");
        console.log(src);

        res.render("generate", { src });
    });
});

const port = 3000;
app.listen(port, () => {
    console.log("Listening to port 3000");
})