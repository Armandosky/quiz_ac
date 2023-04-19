import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_ac/login.dart';

import 'methods.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required bool isLogged});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final Metodos metodos = Metodos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('BIENVENIDO',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const Text('¿Quieres habilitar el login con datos biométricos?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  await metodos.authenticate();
                  if (metodos.authorized == 'Authorized') {
                    Get.to(() => const LoginPage(isLogged: true));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Habilitar'))
          ],
        ),
      ),
    );
  }
}
