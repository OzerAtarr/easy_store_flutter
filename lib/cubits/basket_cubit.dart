import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasketCubit extends Cubit<List<String>>{
  BasketCubit(String userUID): super([]){
    basketDoc = FirebaseFirestore.instance.collection('users').doc(userUID);

    basketDoc.snapshots()
        .listen((event){
          List cartArray = event.data()?['cart'] ?? [];
          emit([...cartArray]);
    });
  }

  late DocumentReference<Map<String, dynamic>> basketDoc;

  // Ürün varsa sepetten çıkarır, ürün yoksa sepete ekler
  void addOrDeleteBasketItem(String productId) {
    basketDoc.update({
      'cart': state.contains(productId)
          ? FieldValue.arrayRemove([productId])
          : FieldValue.arrayUnion([productId])
    });
  }

}

/*
  final Map<String, dynamic> data = basket.data!.data() as Map<String, dynamic>;
  final List cartArray = data.containsKey('cart') ? List.from(data['cart']) : [];*/