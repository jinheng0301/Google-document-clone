// import line like flutter
const express = require('express');
const User = require('../models/user');

const authRouter = express.Router();

authRouter.post('/api/signup', async (request, response) => {
    try {
        const { name, email, profilePic } = request.body;

        // email already exists?
        let user = await User.findOne({ email });
        if (!user) {
            user = new User({
                email,
                name,
                profilePic,
            });
            user = await user.save();
        }

        // if not, store user's data
        response.json({ user });// response allow us to send data
    }
    catch (e) { print(e); }
});

module.exports = authRouter;