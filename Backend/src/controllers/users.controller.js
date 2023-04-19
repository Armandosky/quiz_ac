const { Router } = require('express');
const router = Router();
const User = require('../models/user.models');
const jwt = require('jsonwebtoken');
const config = require('../config');

router.post('/signup', async(req, res) => {
    try {
        const { username, email, password } = req.body;
        const user = new User({ username, email, password });
        user.password = await user.encryptPassword(password);
        await user.save();

        const token = jwt.sign({ id: user.id }, config.secret, {
            expiresIn: '1d'
        });
        res.status(200).json({ auth: true, token });
    } catch (error) {
        console.log(error);
        res.status(500).send("Can't register");
    }
});

router.post('/login', async(req, res) => {
    try {
        const user = await User.findOne({ email: req.body.email })
        if (!user) {
            return res.status(404).send({ message: "Email doesn't exist" });
        }
        const validPassword = await user.validatePassword(req.body.password, user.password);
        if (!validPassword) {
            return res.status(404).send({ message: 'Incorrect password' });
        }
        const token = jwt.sign({ id: user.id, email: user.email }, config.secret || "Secret", { expiresIn: "1d" });
        res.status(200).json({ token: token });
    } catch (error) {
        console.log(error);
        res.status(500).send("Can't start");
    }
});


router.post("/validate", (req, res) => {
    const { token } = req.body;
    try {
        jwt.verify(token, config.secret || "secretoken")
        res.json({ message: "Ok" })
    } catch {
        res.status(401).json({ message: "Error" });
    }
});

router.get('/logout', function(req, res) {
    res.status(200).send({ auth: false, token: null });
});

router.post('/users/:email', async(req, res) => {
    try {
        const email = req.params.email;
        const newData = req.body.newData;
        const user = await User.findOneAndUpdate(email);

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        user.token = newData;
        await user.save();
        return res.status(200).json({ message: 'Added token' });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Can't add token" });
    }
});


router.delete('/users/:email/token', async(req, res) => {
    try {
        const email = req.params.email;
        const user = await User.findOneAndUpdate(email);
        if (!user) {
            return res.status(404).send({ message: 'User not found' });
        }
        user.token = "";
        await user.save();
        return res.status(200).json({ message: 'The token has been deleted' });
    } catch (error) {
        console.error(error);
        return res.status(500).send({ message: "Can't delete token" });
    }
});

router.get('/users/:email/token', (req, res) => {
    try {
        const email = req.params.email;
        User.findOne({ email: email }, { token: 1 }, (err, user) => {
            if (err) {
                res.status(500).send(err);
            } else if (!user) {
                res.status(404).send('User not found');
            } else {
                res.status(200).send(user.token);
            }
        });
    } catch (error) {
        console.error(error);
        return res.status(500).send({ message: "Can't get token" });
    }
});

module.exports = router;