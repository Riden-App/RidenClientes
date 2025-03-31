import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_usuario/ui/pages/login/login_page.dart';

import '/utils/button.dart' as btn;

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 27),
        child: Column(
          children: [
            const SizedBox(height: 72),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              width: MediaQuery.of(context).size.width,
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Bienvenido\n',
                    ),
                    TextSpan(
                      text: 'a Ride It',
                    ),
                  ],
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 11),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              width: MediaQuery.of(context).size.width,
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Viaja y gana\n',
                    ),
                    TextSpan(
                      text: 'con nosotros',
                    ),
                  ],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 31),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/img/car.png',
                fit: BoxFit.cover,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: btn.button(
                  label: 'Comenzar',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPage()));
                  },
                  type: 'white'),
            )
          ],
        ),
      ),
    );
  }
}
