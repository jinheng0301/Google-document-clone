const mongoose = require('mongoose');

// the structure of user
const userSchema = mongoose.Schema({
    // properties
    name: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
    },
    profilePic: {
        type: String,
        required: true,
    }
});

const User = mongoose.model('User', userSchema);
module.exports = User;
// the "User" is just like private variable and cannot accessed by other class
// so use "module.exports = User;" to let private variables become public variable