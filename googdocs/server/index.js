const express = require('express');
const mongoose = require('mongoose');
const authRouter = require('./route/auth');
const cors = require('cors');
const documentRouter = require('./route/document');

const PORT = process.env.PORT | 3001;

const app = express();

app.use(cors());
app.use(express.json());
app.use(authRouter);
// authRouter: a middleware between server and client side
app.use(documentRouter);

const DB = 'mongodb+srv://jinheng:FPac!vA3Qf.zXZB@cluster0.slq3oxv.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';

mongoose.connect(DB).then(() => {
    console.log('connection successsful');
}).catch((err) => {
    console.log(err);
})

app.listen(PORT, '0.0.0.0', function () {
    console.log(`connected at port ${PORT}`);
    // backtick `` is present of the escape key
});