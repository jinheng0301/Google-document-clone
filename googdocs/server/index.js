const express = require('express');
const mongoose = require('mongoose');

const PORT = process.env.PORT | 3001;

const app = express();

const DB = 'mongodb+srv://jinheng:FPac!vA3Qf.zXZB@cluster0.slq3oxv.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';
mongoose.connect(DB).then(() => {
    console.log('connection successsful');
}).catch((err) => {
    console.log(err);
})

app.listen(PORT, '0.0.0.0', function () {
    console.log(`connected at port ${PORT}`);
    console.log(`connected at port ${PORT}`);
    // backtick `` is present of the escape key
});