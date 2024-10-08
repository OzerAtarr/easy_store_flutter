class Product{
  final String uid;
  final String title;
  final String imageUrl;
  final bool isFavorite;
  final int price;
  final double discountRate;

  const Product({required this.uid, required this.title, required this.imageUrl, required this.isFavorite, required this.price, required this.discountRate});

  factory Product.fromFirestore(Map map, String uid){
    return Product(
        uid: uid,
        title: map['title'],
        imageUrl: map['imageUrl'],
        isFavorite: map['isFavorite'],
        price: map['price'],
        discountRate: map['discountRate']
    );
  }
}