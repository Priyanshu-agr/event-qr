const {
    getAuthToken,
    getSpreadSheet,
    getSpreadSheetValues,
    updateValues
  } = require('./googleSheetsService.js');
  
require('dotenv').config();
const qr = require("qrcode");

  const spreadsheetId = process.env.SHEETID;
  const sheetName = process.env.SHEETNAME;
  
  async function testGetSpreadSheet() {
    try {
      const auth = await getAuthToken();
      const response = await getSpreadSheet({
        spreadsheetId,
        auth
      })
      console.log('output for getSpreadSheet', JSON.stringify(response.data, null, 2));
    } catch(error) {
      console.log(error.message, error.stack);
    }
  }
  
  async function testGetSpreadSheetValues() {
    try {
      const auth = await getAuthToken();
      const response = await getSpreadSheetValues({
        spreadsheetId,
        sheetName,
        auth
      })
    //   console.log('output for getSpreadSheetValues', JSON.stringify(response.data, null, 2));
    //   console.log(response.data.values[1]);
    for(let i = 1; i < response.data.values.length; i++){
        console.log(response.data.values[i][1]);
        let range = `test!F${i+1}`;
        let values = [[await qr.toDataURL(response.data.values[i][1])]];

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
    }
    } catch(error) {
      console.log(error.message, error.stack);
    }
  }

  async function testUpdateValues() {
    let range = "test!F2";
    // console.log(qr.toDataURL(""));
    let values = [ [ "New data"] ];
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
  }
  
  function main() {
    // testGetSpreadSheet();
    testGetSpreadSheetValues();
    // testUpdateValues()
  }
  
  main()