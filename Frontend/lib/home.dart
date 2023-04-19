import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_ac/login.dart';

import 'methods.dart';

class HomeScreen extends StatefulWidget {
  final bool isAuthorized;
  const HomeScreen({Key? key, required this.isAuthorized}) : super(key: key);
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
            Text(
                widget.isAuthorized
                    ? '¿Quieres deshabilitar el login con datos biométricos?'
                    : '¿Quieres habilitar el login con datos biométricos?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (widget.isAuthorized) {
                  await metodos.authenticate();
                  if (metodos.authorized == 'Authorized') {
                    Get.to(() => const HomeScreen(isAuthorized: false));
                  }
                } else {
                  await metodos.authenticate();
                  if (metodos.authorized == 'Authorized') {
                    await metodos.modalLogin(context);
                    Get.to(() => const LoginPage(isLogged: true));
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(
                widget.isAuthorized ? 'Deshabilitar' : 'Habilitar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
