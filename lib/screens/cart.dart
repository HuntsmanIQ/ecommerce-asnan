import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:grostore/app_lang.dart';
import 'package:grostore/configs/style_config.dart';
import 'package:grostore/configs/theme_config.dart';
import 'package:grostore/custom_ui/BoxDecorations.dart';
import 'package:grostore/custom_ui/Button.dart';
import 'package:grostore/custom_ui/Image_view.dart';
import 'package:grostore/custom_ui/common_appbar.dart';
import 'package:grostore/helpers/device_info_helper.dart';
import 'package:grostore/helpers/route.dart';
import 'package:grostore/presenters/cart_presenter.dart';
import 'package:grostore/screens/check_out.dart';
import 'package:provider/provider.dart';
import '../helpers/common_functions.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.xxlightGrey,
      appBar: CommonAppbar.show(
        title: AppLang.local(context).cart,
        context: context,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: SizedBox(
            height: getHeight(context),
            width: getWidth(context),
            child: Column(
              children: [
                // قائمة المنتجات
                Expanded(
                  child: Consumer<CartPresenter>(
                    builder: (context, data, child) {
                      if (data.isCartResponseFetch &&
                          data.cartResponse.carts.isNotEmpty) {
                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          itemCount: data.cartResponse.carts.length,
                          itemBuilder: (context, index) {
                            final item = data.cartResponse.carts[index];
                            return Container(
                              margin: EdgeInsets.only(
                                left: StyleConfig.padding,
                                right: StyleConfig.padding,
                                bottom: 5,
                              ),
                              decoration: BoxDecorations.shadow(),
                              width: getWidth(context),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ImageView(
                                    url: item.thumbnailImage ?? '',
                                    width: 120,
                                    height: 100,
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: getWidth(context) * 0.4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.category ?? '',
                                          style: StyleConfig.fs10,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          item.name ?? '',
                                          style: StyleConfig.fs12fwBold,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              item.unit ?? '',
                                              style: StyleConfig.fs12,
                                              maxLines: 1,
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              '${showPrice(item.price).replaceAll(RegExp(r'\.0+$'), '').replaceAll('#', '')} IQD',
                                              style: StyleConfig.fs12,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 1,
                                    child: quantitySection(context, data, index),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return Center(
                        child: Text(
                          'السلة فارغة',
                          style: StyleConfig.fs14fwBold,
                        ),
                      );
                    },
                  ),
                ),

                // كود الخصم ومعلومات الطلب
                Consumer<CartPresenter>(
                  builder: (context, data, child) {
                    if (data.cartResponse.carts.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          margin: EdgeInsets.symmetric(
                            horizontal: StyleConfig.padding,
                            vertical: 14,
                          ),
                          decoration: BoxDecorations.customRadius(
                            radius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: getWidth(context) * 0.6,
                                child: TextField(
                                  controller: data.couponTxtController,
                                  decoration: InputDecoration.collapsed(
                                    hintText:
                                        AppLang.local(context).promo_code_ucf,
                                  ),
                                ),
                              ),
                              Button(
                                minWidth: 40,
                                shape: StyleConfig.buttonRadius(8),
                                color: ThemeConfig.amber,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                onPressed: () {
                                  data.applyCoupon(
                                    context,
                                    data.couponTxtController.text.trim(),
                                  );
                                },
                                child: Text(
                                  AppLang.local(context).apply,
                                  style: StyleConfig.fs16cWhitefwBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecorations.customRadius(
                            radius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ).copyWith(color: ThemeConfig.white),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                AppLang.local(context).order_info_ucf,
                                style: StyleConfig.fs16fwBold,
                              ),
                              orderRow(
                                AppLang.local(context).subtotal,
                                showPrice(data.cartResponse.subTotal),
                              ),
                              orderRow(
                                AppLang.local(context).coupon_discount_ucf,
                                showPrice(data.cartResponse.couponDiscount),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: StyleConfig.padding,
                                  vertical: 5,
                                ),
                                child: DottedLine(
                                  lineLength: double.infinity,
                                  lineThickness: 1.0,
                                  dashLength: 4.0,
                                  dashColor: ThemeConfig.grey,
                                  dashGapLength: 4.0,
                                  dashGapColor: Colors.transparent,
                                ),
                              ),
                              orderRow(
                                AppLang.local(context).total,
                                showPrice(data.cartResponse.total),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: StyleConfig.padding,
                                  vertical: 1,
                                ),
                                child: Button(
                                  shape: StyleConfig.buttonRadius(4),
                                  color: ThemeConfig.accentColor,
                                  onPressed: () {
                                    MakeRoute.go(context, const CheckOut());
                                  },
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  minWidth: getWidth(context),
                                  child: Text(
                                    AppLang.local(context)
                                        .review_n_payment_ucf,
                                    style: StyleConfig.fs16cWhitefwBold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget orderRow(String label, String value) {
  return Padding(
    padding:
        EdgeInsets.symmetric(horizontal: StyleConfig.padding, vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$label:", style: StyleConfig.fs14fwNormal),
        Text(
          '${value.replaceAll(RegExp(r'\.0+$'), '').replaceAll('#', '')} IQD',
          style: StyleConfig.fs14fwNormal,
        ),
      ],
    ),
  );
}

Widget quantitySection(BuildContext context, CartPresenter data, int index) {
  return SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Button(
          minWidth: 20,
          shape: const CircleBorder(),
          color: ThemeConfig.fontColor,
          padding: const EdgeInsets.all(8),
          onPressed: () {
            data.updateCart(
              cartId: data.cartResponse.carts[index].id,
              action: "decrease",
              context: context,
            );
          },
          child: const Icon(
            Icons.remove,
            color: ThemeConfig.white,
            size: 10,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          constraints: const BoxConstraints(minWidth: 40),
          alignment: Alignment.center,
          child: Text(
            "${data.cartResponse.carts[index].quantity}",
            style: StyleConfig.fs12fwBold,
          ),
        ),
        Button(
          minWidth: 20,
          shape: const CircleBorder(),
          color: ThemeConfig.accentColor,
          padding: const EdgeInsets.all(8),
          onPressed: () {
            data.updateCart(
              cartId: data.cartResponse.carts[index].id,
              action: "increase",
              context: context,
            );
          },
          child: const Icon(
            Icons.add,
            color: ThemeConfig.white,
            size: 10,
          ),
        ),
      ],
    ),
  );
}
