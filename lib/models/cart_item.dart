import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String price;
  final String uid;
  final String productUrl;
  final String productName;
  final bool isInCart;

  const CartItem({
    this.isInCart = false,
    required this.price,
    required this.uid,
    required this.productUrl,
    required this.productName,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'productUrl': productUrl,
        'productName': productName,
        'isInCart': isInCart,
        'price': price,
      };

  static CartItem fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CartItem(
      isInCart: snapshot['isInCart'] as bool,
      productName: snapshot['productName'] as String,
      uid: snapshot['uid'] as String,
      productUrl: snapshot['productUrl'] as String,
      price: snapshot['price'] as String,
    );
  }
}
