import 'package:easy_store/screens/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _loading = false;
  var _email = "";
  var _password = "";
  var _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Giriş Sayfası')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_errorMessage.isNotEmpty)
              Text(
                'Error Message : $_errorMessage',
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),
            TextField(
              decoration: InputDecoration(hintText: "Email"),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                _email = value;
                debugPrint(value);
                if (_errorMessage.isNotEmpty) {
                  _errorMessage = "";
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(hintText: "Password"),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              onChanged: (value) {
                _password = value;
                debugPrint(value);
                if (_errorMessage.isNotEmpty) {
                  _errorMessage = "";
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 36),
            if (_loading)
              const CircularProgressIndicator()
            else
              TextButton(
                onPressed: () {
                  final regexExp = RegExp(
                      r"^[A-Za-z0-9._+\-\']+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$");
                  final isValid =
                      regexExp.hasMatch(_email) && _password.length > 5;
                  if (isValid) {
                    _loading = true;
                    setState(() {});
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _email, password: _password)
                        .catchError((errorMessage) {
                      _errorMessage = errorMessage.toString();
                      _loading = false;
                      setState(() {});
                    });
                  } else {
                    _errorMessage = 'Email ve şifre kısmı boş geçilemez';
                    setState(() {});
                  }
                },
                child: const Text('Giriş Yap'),
              ),
            const Divider(
              height: 48,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) {
                    return const RegisterPage();
                  }),
                );
              },
              child: const Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
