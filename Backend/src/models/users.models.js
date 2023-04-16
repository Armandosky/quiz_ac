const {Schema, model} = require('mongoose');
const bcrypt = require('bcrypt');

const userSchema = new Schema({
    username: String,
    email: String,
    password: String,
    token: String
});

userSchema.methods.encryptPassword = async(password) => {
    const salt = await bcrypt.genSalt(10);
    return bcrypt.hash(password, salt);
}

userSchema.methods.comparePassword = function(password) {
    return bcrypt.compare(password, this.password);
}

module.exports = model('Users', userSchema)