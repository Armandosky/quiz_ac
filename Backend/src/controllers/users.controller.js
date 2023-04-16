const User = require('../models/users.models');
const jwt = require('jsonwebtoken');
const config = require('../config');

const signup = async(req, res) => {
    try {
        const {username, email, password} = req.body;
        const user = new User({username, email, password});
        user.password = await user.encryptPassword(password);
        await user.save();

        const token = jwt.sign({id: user.id}, config.secret, {
            expiresIn: '1d'
        });
        res.status(200).json({auth: true, token});
    } catch (error) {
        console.log(error);
        res.status(500).send("Can't register");
    }
};

const login = async(req, res) => {
    try {
        const user = await User.findOne({email: req.body.email})
        if (!user){
            return res.status(404).send({message: "Email doesn't exist"});
        }
        const validPassword = await user.validatePassword(req.body.password, user.password);
        if (!validPassword){
            return res.status(404).send({message: 'Incorrect password'});
        }
        const token = jwt.sign({
            id: user.id,
            email: user.email
        },
        config.secret || "Secret", {expiresIn: "1d"}
        )
        res.status(200).json({token: token})
    } catch (error) {
        console.log(error);
        res.status(500).send("Can't start")
    }
};

const validate = async(req, res) => {
    const {token} = req.body;
    try {
        jwt.verify(token, config.secret || "mysecrettoken")
        res.json({message: "Ok"})
    } catch {
        res.status(401).send("Error")
    }
};

const logout = async(req, res) => {
    res.status(200).send({auth: false, token: null})
};

export const methods = {signup, login, validate, logout};