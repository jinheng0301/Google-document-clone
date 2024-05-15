// import line like flutter
const express = require('express');
const User = require('../models/user');
const jwt = require('jsonwebtoken');
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

        const token = jwt.sign({ id: user._id }, 'passwordKey');

        // if not, store user's data
        response.json({ user, token });// response allow us to send data
    }
    catch (e) { res.status(500).json({ error: e.message }); }
});

authRouter.get('/', async (request, response) => {
    const user = await User.findById(request.user);
    response.json({ user, token: request.token });
});

module.exports = authRouter;