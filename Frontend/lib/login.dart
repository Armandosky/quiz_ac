// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_ac/home.dart';
import 'methods.dart';

class LoginPage extends StatefulWidget {
  final bool isLogged;
  const LoginPage({Key? key, required this.isLogged}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Metodos metodos = Metodos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.all(20.0)),
            const SizedBox(height: 100.0),
            const FlutterLogo(
              size: 70,
              style: FlutterLogoStyle.horizontal,
            ),
            const SizedBox(height: 50),
            TextField(
                key: const Key('email'),
                controller: metodos.emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Email',
                ),
                onChanged: (value) {
                  setState(() {});
                }),
            const SizedBox(height: 16.0),
            TextField(
                key: const Key('password'),
                controller: metodos.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Password',
                ),
                onChanged: (value) {
                  setState(() {});
                }),
            const SizedBox(height: 35.0),
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, left: 100, right: 100, bottom: 0),
              child: ElevatedButton(
                onPressed: metodos.isLoading ? null : metodos.submitForm,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(200, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: metodos.isLoading
                    ? const SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text('Iniciar sesión'),
              ),
            ),
            Visibility(
              visible: widget.isLogged,
              child: Padding(
                padding: const EdgeInsets.only(top: 5, left: 100, right: 100),
                child: ElevatedButton(
                  onPressed: () async {
                    await metodos.authenticate();
                    if (metodos.authorized == 'Authorized') {
                      Get.to(() => const HomeScreen(isAuthorized: true));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Iniciar sesión con datos biométricos',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
