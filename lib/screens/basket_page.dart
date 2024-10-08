import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_store/cubits/basket_cubit.dart';
import 'package:easy_store/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasketPage extends StatelessWidget {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
      ),
      body: BlocBuilder<BasketCubit, List<String>>(builder: (_, state) {
        if (state.isEmpty) return const Center(child: Text('Sepetiniz Boş'));

        final totalBasketPriceNotifier = ValueNotifier(0.0);

        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  for (final productID in state)
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('products')
                          .doc(productID)
                          .get(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          final product = Product.fromFirestore(
                            snapshot.data!.data()!,
                            snapshot.data!.id,
                          );

                          final withDiscountPrice = product.price *
                              (100 - product.discountRate) /
                              100;
                          Future.delayed(
                                  Duration(milliseconds: Random().nextInt(150)))
                              .whenComplete(() => totalBasketPriceNotifier
                                  .value += withDiscountPrice);

                          return Card(
                            child: ListTile(
                                title: Text(product.title),
                                subtitle: Row(
                                  children: [
                                    Text(
                                        '\$${product.price.toString()}   İndirim Oranı: %${product.discountRate}'),
                                    const VerticalDivider(),
                                    Text(
                                        'İndirimli Fiyat : \$${withDiscountPrice.toStringAsFixed(2)}')
                                  ],
                                )),
                          );
                        }
                        return const LinearProgressIndicator();
                      },
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Toplam Sepet Tutarı :'),
                          ValueListenableBuilder(
                              valueListenable: totalBasketPriceNotifier,
                              builder: (_, totalBasketPrice, __) {
                                return Text(
                                  ' \$ ${totalBasketPrice.toStringAsFixed(2)}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                );
                              }),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStatePropertyAll(Colors.blue),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Ödeme Yap',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
