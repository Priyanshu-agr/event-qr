const express = require("express");
const app = express();
const bp = require("body-parser");
const qr = require("qrcode");

app.set("view engine", "ejs");
app.use(bp.urlencoded({extended: false}));
app.use(bp.json());

app.get("/", (req,res) => {
    res.render("index");
})

app.post("/scan/:id", (req,res) => {
    const { id } = req.params;
    console.log(id);
})

app.post("/generate", (req,res) => {
    const url = req.body.url;

    if(url.length === 0) res.send("Empty data");

    qr.toDataURL(url, (err, src) => {
        if(err) res.send("Error");
        console.log(src);

        res.render("generate", {src});
    });
});

const port = 3000;
app.listen(port, () => {
    console.log("Listening to port 3000");
})