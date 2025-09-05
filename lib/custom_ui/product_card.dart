import 'package:flutter/material.dart';
import 'package:grostore/configs/style_config.dart';
import 'package:grostore/configs/theme_config.dart';
import 'package:grostore/custom_classes/system_data.dart';
import 'package:grostore/custom_ui/Button.dart';
import 'package:grostore/custom_ui/Image_view.dart';
import 'package:grostore/custom_ui/BoxDecorations.dart';
import 'package:grostore/helpers/common_functions.dart';
import 'package:grostore/helpers/route.dart';
import 'package:grostore/models/product_mini_response.dart';
import 'package:grostore/presenters/cart_presenter.dart';
import 'package:grostore/screens/auth/login.dart';
import 'package:grostore/screens/product_details.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  late ProductMini product;
  late BuildContext context;
  ProductCard({Key? key, required this.product, required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return SizedBox(
        width: 160,
        height: 270, 
        child: Stack(
          children: [
            // خلفية البطاقة كلها
            Container(
              width: 160,
              decoration: BoxDecorations.shadow(radius: 8),
              child: Button(
                minWidth: 160,
                onPressed: () {
                  MakeRoute.productRoute(
                      this.context, ProductDetails(slug: product.slug));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 160,
                      height: 150,
                      alignment: Alignment.center,
                      child: Hero(
                        tag: product,
                        child: ImageView(
                          url: product.thumbnailImage,
                          width: 120,
                          height: 140,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        product.categories.isNotEmpty
                            ? product.categories.first.name
                            : '',
                        style: StyleConfig.fs10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        product.name,
                        style: StyleConfig.fs12fwBold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        showPrice(
                            '${product.price.replaceAll(RegExp(r'\.0+$'), '').replaceAll('#', '')} IQD'),
                        style: StyleConfig.fs14cRedfwBold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: -4,
              right: 17,
              child: Button.minSize(
                color: ThemeConfig.fontColor,
                onPressed: () {
                  if (SystemData.isLogIn) {
                    if (product.variations.isNotEmpty &&
                        product.variations.length == 1) {
                      Provider.of<CartPresenter>(context, listen: false)
                          .addToCart(product.variations.first.id, 1, context);
                    } else {
                      MakeRoute.productRoute(
                          this.context, ProductDetails(slug: product.slug));
                    }
                  } else {
                    MakeRoute.productRoute(this.context, const Login());
                  }
                },
                width: 40,
                height: 40,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  color: ThemeConfig.white,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print('❌ خطأ في ProductCard: $e');
      return const SizedBox(); // أو Text("حدث خطأ")
    }
  }
}
