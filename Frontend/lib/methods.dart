// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'login.dart';

class Metodos {
  final LocalAuthentication auth = LocalAuthentication();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isAuthenticated = false;
  bool isConfirmado = false;
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  int nIngresos = 0;
  late String token;
  late String token2;
  late String correo;
  String authorized = 'Not Authorized';
  bool isAuthenticating = false;
  bool enableFingerprint = false;
  final storage = const FlutterSecureStorage();
  late String _correo;
  final formKey = GlobalKey<FormState>();

  Future<void> authenticate() async {
    bool authenticated = false;
    try {
      isAuthenticating = true;
      authorized = 'Authenticating';

      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      isAuthenticating = false;
      authorized = 'Authenticating';
    } on PlatformException catch (e) {
      print(e);

      isAuthenticating = false;
      authorized = 'Error - ${e.message}';

      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';

    authorized = message;
  }

  Future<void> updateUser(String userEmail, String newData) async {
    final url = 'http://192.168.1.4:3000/users/$userEmail ';
    final response = await http.post(
      Uri.parse(url),
      body: {'newData': newData},
    );

    if (response.statusCode == 200) {
      print('Usuario actualizado con éxito');
    } else {
      print('Error al actualizar el usuario: ${response.reasonPhrase}');
    }
  }

  Future<void> submitForm() async {
    print("utilizando");
    isLoading = true;
    errorMessage = null;

    final email = emailController.text;
    final password = passwordController.text;
    final url = Uri.parse('http://192.168.1.4:3000/login');
    try {
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'email': email,
              'password': password,
            },
          ));
      final responseData = json.decode(response.body);

      if (response.statusCode == 404) {
        errorMessage = responseData['message'];
        isLoading = false;
      } else if (response.statusCode == 200) {
        final tokenv = responseData['token'];

        nIngresos++;
        if (nIngresos == 1) {
          print("Ha ingresado 1 vez");

          Get.to(() => const HomeScreen(
                isAuthorized: false,
              ));
          token = tokenv;
        } else {
          print("Ha ingresado 2 veces");
          Get.to(() => const HomeScreen(
                isAuthorized: true,
              ));
          token2 = token;
        }
        isLoading = false;

        print('Su token es: $token');
        Get.to(() => const HomeScreen(
              isAuthorized: true,
            ));
        correo = email;
      }
    } catch (error) {
      errorMessage = 'Error al intentar iniciar sesión';
      isLoading = false;
    }
  }

  Future<void> modalLogin(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Confirmar inicio de sesión con huella",
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center),
                const SizedBox(height: 15),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(width: 3)),
                    labelText: 'Correo electrónico',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su correo electrónico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(width: 3)),
                    labelText: 'Contraseña',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su contraseña';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        isConfirmado = true;
                        updateUser(correo, token2);
                        storage.write(key: "token2", value: token2);
                      }
                    },
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(fontSize: 15),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> iniciado() async {
    final token = await storage.read(key: 'token');
    if (token != null) {
      print('Token recuperado: $token');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      print(decodedToken);

      _correo = decodedToken["email"] as String;

      final url2 = Uri.parse('http://192.168.1.4:3000/users/$_correo/token');
      final response2 = await http.get(url2);
      if (response2.statusCode == 200) {
        final almacenamiento = await storage.read(key: 'token2');
        if (response2.body == almacenamiento.toString()) {
          isAuthenticated = true;

          Get.to(() => const HomeScreen(isAuthorized: true));
        } else {
          Get.to(() => const LoginPage(isLogged: false));
        }
      } else {
        print(response2.statusCode);
      }
    } else {
      Get.to(() => const LoginPage(isLogged: false));
    }
  }
}
