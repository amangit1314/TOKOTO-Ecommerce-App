// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../components/section_tile.dart';
// import '../../../../models/product.dart';
// import '../../../../providers/product_provider.dart';
// import '../../../../utils/constants.dart';
// import '../../../../utils/size_config.dart';
// import '../../../details/detail_screen.dart';
// class Fashionable extends StatefulWidget {
//   const Fashionable({super.key});
//   @override
//   State<Fashionable> createState() => _FashionableState();
// }
// class _FashionableState extends State<Fashionable> {
//   final CollectionReference _refProducts =
//       FirebaseFirestore.instance.collection('products');
//   late Stream<QuerySnapshot> _streamProducts;
//   @override
//   void initState() {
//     super.initState();
//     _streamProducts = _refProducts.snapshots();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: getProportionateScreenWidth(20),
//           ),
//           child: SectionTitle(
//             title: "Fashion Collection",
//             press: () {},
//           ),
//         ),
//         SizedBox(height: getProportionateScreenWidth(20)),
//         Container(
//           height: 250,
//           padding: const EdgeInsets.only(left: 20.0),
//           child: Consumer<ProductProvider>(
//             builder: (context, productProvider, _) {
//               return StreamBuilder<QuerySnapshot>(
//                 stream: _streamProducts,
//                 builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.active) {
//                     return productProvider.products.isEmpty
//                         ? const Center(child: CircularProgressIndicator())
//                         : ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: productProvider.products.length,
//                             itemBuilder: (context, index) {
//                               return FashionsCard(
//                                 image: productProvider
//                                         .products[index].images.isNotEmpty
//                                     ? productProvider
//                                         .products[index].images[index]
//                                     : '',
//                                 product: productProvider.products[index],
//                                 category: productProvider
//                                         .products[index].categories.isNotEmpty
//                                     ? productProvider
//                                         .products[index].categories.first
//                                     : '',
//                               );
//                             },
//                           );
//                   }
//                   return const Center(
//                     child: Text('Something went wrong'),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
// class FashionsCard extends StatelessWidget {
//   final Product product;
//   final String? image;
//   final String? category;
//   const FashionsCard({
//     super.key,
//     required this.product,
//     this.image,
//     this.category,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (_) => DetailsScreenFirebase(
//               product: product,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: 170,
//         margin: const EdgeInsets.only(right: 10),
//         padding: const EdgeInsets.only(
//           top: 8,
//           left: 8,
//           right: 8,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(
//             color: kPrimaryColor.withOpacity(.2),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 148,
//               width: 170,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(
//                     image! == '' ? 'https://picsum.photos/250?image=9' : image!,
//                   ),
//                   fit: BoxFit.cover,
//                 ),
//                 borderRadius: const BorderRadius.all(
//                   Radius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 2.0),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         category! == '' ? 'Fashion' : category!,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           color: Colors.grey.shade700,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.title,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 8.0, top: 4, bottom: 8),
//               child: Text(
//                 '\$ ${product.price}',
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: kPrimaryColor,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../components/section_tile.dart';
import '../../../../components/skelton.dart';
import '../../../../models/product.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/size_config.dart';
import '../../../details/detail_screen.dart';
import '../../../showMore/show_more_screen.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({Key? key}) : super(key: key);

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  final CollectionReference _refProducts =
      FirebaseFirestore.instance.collection('products');

  Future<List<Product>> fetchProductsFromFirestore() async {
    final List<Product> products = [];
    // filtering if isPopular
    final QuerySnapshot snapshot =
        await _refProducts.where('isPopular', isEqualTo: true).get();
    for (var element in snapshot.docs) {
      products.add(Product.fromMap(element.data() as Map<String, dynamic>));
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: SectionTitle(
            title: "Popular Products",
            press: () {
              // navigate to ShowMore
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ShowMore(),
                ),
              );
            },
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        Container(
          height: 250,
          padding: const EdgeInsets.only(left: 20.0),
          child: FutureBuilder<List<Product>>(
            future: fetchProductsFromFirestore(),
            builder: (context, snapshot) {
              final List<Product> products = snapshot.data ?? [];

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return const LoadingShimmerSkelton();
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 8);
                    },
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return FashionsCard(
                    image: products[index].images.isNotEmpty
                        ? products[index].images[0]
                        : '',
                    product: products[index],
                    category: products[index].categories.isNotEmpty
                        ? products[index].categories[0]
                        : '',
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

class LoadingShimmerSkelton extends StatelessWidget {
  const LoadingShimmerSkelton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        const Skelton(),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Skelton(height: 10),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Skelton(height: 14),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 8.0, top: 4, bottom: 8),
          child: Skelton(height: 12),
        ),
      ],
    );
  }
}

class FashionsCard extends StatelessWidget {
  final Product product;
  final String? image;
  final String? category;
  const FashionsCard({
    super.key,
    required this.product,
    this.image,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailsScreenFirebase(
              product: product,
            ),
          ),
        );
      },
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.only(
          top: 8,
          left: 8,
          right: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: kPrimaryColor.withOpacity(.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 148,
              width: 170,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    image! == '' ? 'https://picsum.photos/250?image=9' : image!,
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        category! == '' ? 'Fashion' : category!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 4, bottom: 8),
              child: Text(
                '₹ ${product.price}',
                style: const TextStyle(
                  fontSize: 12,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
