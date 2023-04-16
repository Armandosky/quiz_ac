import { Router } from 'express';
import { methods } from '../controllers/users.controller';

const Router = Router;

Router.post('/signup', methods.signup);
Router.post('/login', methods.login);
Router.post('/validate', methods.validate);
Router.post('/logout', methods.logout);
