import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_store/cubits/basket_cubit.dart';
import 'package:easy_store/screens/basket_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasketButtonWidget extends StatelessWidget {
  const BasketButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    return IconButton(
        icon: Stack(
          children: [
            Image.asset(
              'assets/images/bag.png',
              width: 24,
              height: 24,
            ),
            Positioned.fill(
              child: BlocBuilder<BasketCubit, List<String>>(
                  builder: (_, basket) {
                    if(basket.isEmpty) return SizedBox();
                    return Align(
                      alignment: Alignment.topRight,
                      child: ColoredBox(
                        color: Colors.red,
                        child: Text(
                          '${basket.length}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<BasketCubit>(context),
                  child: const BasketPage(),
              ),
          ));
        });
  }
}
