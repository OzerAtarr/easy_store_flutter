import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_store/cubits/basket_cubit.dart';
import 'package:easy_store/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomepageProductWidget extends StatefulWidget {
  const HomepageProductWidget({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<HomepageProductWidget> createState() => _HomepageProductWidgetState();
}



class _HomepageProductWidgetState extends State<HomepageProductWidget> {
  @override
  Widget build(BuildContext context) {

    bool _favorideMi = false;

    final user = FirebaseAuth.instance.currentUser!;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    return Card(
      child: Container(
        width: 148, // Kart genişliği
        height: 215, // Kart yüksekliği
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    widget.product.imageUrl,
                    width: 148, // Resim genişliği
                    height: 104, // Resim yüksekliği
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                    top: 4,
                    right: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50), // Köşeleri yumuşatmak için ClipRRect kullanıyoruz
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), // Blur efekti için sigma değerlerini ayarlıyoruz
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.64), // %64 opaklık (hex: #FFFFFFA3)
                            borderRadius: BorderRadius.circular(50), // Köşeleri yuvarlatma
                          ),
                          child: IconButton(
                            onPressed: () {
                              _favorideMi = !_favorideMi;
                              setState(() {});
                            },
                            icon: widget.product.isFavorite
                                ? const Icon(Icons.favorite, color: Colors.red, size: 16)
                                : const Icon(Icons.favorite_border, size: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 4,
                  left: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50), // Köşeleri yumuşatmak için ClipRRect kullanıyoruz
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), // Blur efekti için sigma değerlerini ayarlıyoruz
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.64), // %64 opaklık (hex: #FFFFFFA3)
                          borderRadius: BorderRadius.circular(50), // Köşeleri yuvarlatma
                        ),
                        child: BlocBuilder<BasketCubit, List<String>>(
                          builder: (_, basket) {
                            final inCart = basket.contains(widget.product.uid);

                            return IconButton(
                              onPressed: () {
                                 context.read<BasketCubit>().addOrDeleteBasketItem(widget.product.uid);
                              },
                              icon: inCart
                                  ? const Icon(Icons.shopping_bag, color: Colors.red, size: 16)
                                  : const Icon(Icons.shopping_bag_outlined, size: 16),
                            );
                          }
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.title,
                style: TextStyle(
                  color: Color(0xFF1F2937),
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${widget.product.price * widget.product.discountRate}",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(
                    "\$${widget.product.price}",
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Inter',
                      decoration: TextDecoration.lineThrough,
                      color: Color(0xA39CA3AF),
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(
                    "%${widget.product.discountRate} OFF",
                    style: TextStyle(
                      color: Color(0xFFEA580C),
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.yellow),
                  Text(
                    " 4.8 (692 reviews)",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
