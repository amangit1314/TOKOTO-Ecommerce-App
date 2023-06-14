import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../components/section_tile.dart';
import '../../../../models/product.dart';
import '../../../../utils/size_config.dart';
import '../../../details/detail_screen.dart';
import '../../../loading/shimmer_box.dart';
import '../products_search_screen_item_card.dart';

class ShoesSection extends StatefulWidget {
  const ShoesSection({super.key});

  @override
  State<ShoesSection> createState() => _ShoesSectionState();
}

class _ShoesSectionState extends State<ShoesSection> {
  final CollectionReference _refProducts =
      FirebaseFirestore.instance.collection('products');

  Future<List<Product>> fetchProductsFromFirestore() async {
    final List<Product> products = [];
    final QuerySnapshot snapshot = await _refProducts.get();

    for (var element in snapshot.docs) {
      final productData = element.data() as Map<String, dynamic>;
      final productCategories = List<String>.from(productData['categories']);

      if (productCategories.contains('shoes')) {
        products.add(Product.fromMap(productData));
      }
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(title: 'Shoe\'s', press: () {}),
        SizedBox(height: getProportionateScreenHeight(10)),
        SizedBox(
          height: 190,
          child: FutureBuilder<List<Product>>(
            future: fetchProductsFromFirestore(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: 150,
                  width: getProportionateScreenWidth(170),
                  child: ShimmerBox(
                    child: SizedBox(
                      height: getProportionateScreenHeight(150),
                      width: getProportionateScreenWidth(170),
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }

              final List<Product> products = snapshot.data ?? [];

              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DetailsScreenFirebase(
                            product: products[index],
                          ),
                        ),
                      );
                    },
                    child: ProductSearchScreenItemCard(
                      width: 170,
                      productName: products[index].title,
                      productImage: products[index].images.isNotEmpty
                          ? products[index].images[0]
                          : '',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DetailsScreenFirebase(
                              product: products[index],
                            ),
                          ),
                        );
                      },
                      // productDesc: '\$${products[index].price}',
                      price: '₹ ${products[index].price}',
                      product: products[index],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
