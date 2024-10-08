import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  var _loading = false;
  var _nameSurname = "";
  var _email = "";
  var _password = "";
  var _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Kayıt Sayfası')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(_errorMessage.isNotEmpty)
              Text(
                'Error Message : $_errorMessage',
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),
            TextField(
              decoration: InputDecoration(hintText: "İsim Soyisim"),
              keyboardType: TextInputType.name,
              onChanged: (value){
                _nameSurname = value;
                debugPrint(value);
                if(_errorMessage.isNotEmpty){
                  _errorMessage = "";
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(hintText: "Email"),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value){
                _email = value;
                debugPrint(value);
                if(_errorMessage.isNotEmpty){
                  _errorMessage = "";
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(hintText: "Şifre"),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              onChanged: (value){
                _password = value;
                debugPrint(value);
                if(_errorMessage.isNotEmpty){
                  _errorMessage = "";
                  setState(() {});
                }
              },
            ),
            SizedBox(height: 48),
            if(_loading)
              const CircularProgressIndicator()
            else
              TextButton(
                onPressed: (){
                  if(_email.isNotEmpty && _password.isNotEmpty){
                    _loading = true;
                    setState(() {});
                    FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _email,
                        password: _password).catchError((errorMessage){
                      _errorMessage = errorMessage.toString();
                      _loading = false;
                      setState(() {});
                    }).then((value) async {
                      final uuid = value.user?.uid;
                      final userData = {
                        'name': _nameSurname,
                        'email': _email,
                        'registerDate': FieldValue.serverTimestamp(),
                      };

                      //uuid uniq ise o id ile doc oluşturur yoksa otomatik doldurur
                      if(uuid == null){
                        await FirebaseFirestore.instance.collection('users').add(userData);
                      }else{
                        await FirebaseFirestore.instance.collection('users').doc(uuid).set(userData);
                      }
                      //eğer ekrandaysa context ile giriş sayfasına döner
                      if(mounted)
                        Navigator.of(context).pop();
                    });
                  }else{
                    _errorMessage = "İsim Soyisim, email adresi ve şifre kısmı boş geçilemez!";
                    setState(() {});
                  }
                },
                child: const Text('Kayıt Ol'),
              ),
          ],
        ),
      ),
    );
  }
}
