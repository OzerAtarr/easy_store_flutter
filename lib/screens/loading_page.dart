import 'package:easy_store/cubits/basket_cubit.dart';
import 'package:easy_store/screens/home_page.dart';
import 'package:easy_store/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          final isAuth = snapshot.hasData && snapshot.data != null;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: isAuth
                ? BlocProvider(
                    create: (_) => BasketCubit(snapshot.data!.uid),
                    child: HomePage(),
                  )
                : const LoginPage(),
          );
        });
  }
}
