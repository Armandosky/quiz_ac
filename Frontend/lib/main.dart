// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.dart';

import 'methods.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final Metodos metodos = Metodos();

  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(isLogged: false),
    );
  }

  @override
  void initState() {
    super.initState();
    metodos.iniciado();
  }
}


// Boleano Login (isAuthenticate) = iniciar normal/iniciar datos biometricos
// Boleano home (enableFingerprint) = habilitar huella/deshabilitar huella

// Hacer un init hacer método que valide si hay un token en el secure_storage e igualarlo con la base de datos (Boleano 1)

// Si es verdadero, mandarlo para el home donde le salga deshabilitar huella (Inicializar boleano home true)

// Si no hay nada, se dirige al login donde debe salir el login normal sin huella (Inicializar boleano login false)