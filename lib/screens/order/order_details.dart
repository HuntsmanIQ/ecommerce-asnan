import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:grostore/app_lang.dart';
import 'package:grostore/configs/style_config.dart';
import 'package:grostore/configs/theme_config.dart';
import 'package:grostore/custom_ui/BoxDecorations.dart';
import 'package:grostore/custom_ui/common_appbar.dart';
import 'package:grostore/custom_ui/order_item.dart';
import 'package:grostore/helpers/device_info_helper.dart';
import 'package:grostore/presenters/order_details_presenter.dart';

import '../../helpers/common_functions.dart';

class OrderDetails extends StatefulWidget {
  final code;

  const OrderDetails({super.key, this.code});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrderDetailsPresenter orderDetailsPresenter = OrderDetailsPresenter();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      orderDetailsPresenter.initState(widget.code);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.xxlightGrey,
      appBar: CommonAppbar.show(
          title: AppLang.local(context).order_details, context: context),
      body: ListenableBuilder(
          listenable: orderDetailsPresenter,
          builder: (context, child) {
            return RefreshIndicator(
              onRefresh: () {
                return orderDetailsPresenter.onRefresh(widget.code);
              },
              child: SingleChildScrollView(
                child: orderDetailsPresenter.isInitDetails
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: StyleConfig.padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            Container(
                              width: getWidth(context),
                              decoration: BoxDecorations.shadow(radius: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order Id: ${orderDetailsPresenter.orderInfo?.code ?? ''}",
                                    style: StyleConfig.fs12fwBold,
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Text(
                                    "Ordered at: ${orderDetailsPresenter.orderInfo?.date ?? ''}",
                                    style: StyleConfig.fs14fwBold,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Text(
                              "عنوان الفاتورة",
                              style: StyleConfig.fs14fwBold,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                decoration: BoxDecorations.shadow(radius: 8),
                                child: buildBillingAddress(context)),
                            const SizedBox(
                              height: 14,
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Text(
                              "المنـتـج",
                              style: StyleConfig.fs14fwBold,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              //decoration: BoxDecorations.shadow(radius: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: Column(
                                children: [
                                  /*Row(

                              children: [
                                Container(
                                    width: getWidth(context)*0.35,
                                    child: Text("Product Name")),
                                Container(
                                    width: getWidth(context)*0.18,
                                    child: Text("Unit Price")),
                                Container(
                                    width: getWidth(context)*0.1,
                                    child: Text("QTY")),
                                Container(
                                    width: getWidth(context)*0.18,
                                    child: Text("Total Price")),
                              ],
                            ),
                            Divider(color: ThemeConfig.fontColor,),*/
                                  GridView.builder(
                                      //padding: EdgeInsets.only(left: StyleConfig.padding,right: StyleConfig.padding,bottom: 20),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 16,
                                              mainAxisSpacing: 8,
                                              childAspectRatio: 0.62),
                                      itemBuilder: (context, index) =>
                                          OrderItem(
                                            context: context,
                                            onReq: (value) {
                                              if (value) {
                                                orderDetailsPresenter
                                                    .onRefresh(widget.code);
                                              }
                                            },
                                            item: orderDetailsPresenter
                                                .orderInfo!.items[index],
                                          )
                                      /*Container(
                                  child: Row(

                                    children: [
                                      Container(
                                        width: getWidth(context)*0.35,
                                          child: Text(orderDetailsPresenter.orderInfo?.items[index].product?.name??"")),
                                      Container(
                                        width: getWidth(context)*0.18,
                                          child: Text(showPrice(orderDetailsPresenter.orderInfo?.items[index].unitPrice??""))),
                                      Container(
                                          width: getWidth(context)*0.1,
                                          child: Text("${orderDetailsPresenter.orderInfo?.items[index].qty??''}")),
                                      Container(
                                          width: getWidth(context)*0.18,
                                          child: Text(showPrice(orderDetailsPresenter.orderInfo?.items[index].totalPrice??""))),
                                    ],
                                  ),
                                ),
                                ,
                                separatorBuilder: (context, index) => Column(
                                  children: [
                                    SizedBox(
                                          height: 15,
                                        ),
                                    Divider(color: ThemeConfig.fontColor,),
                                  ],
                                )*/
                                      ,
                                      itemCount: orderDetailsPresenter
                                              .orderInfo?.items.length ??
                                          0),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Divider(
                              color: ThemeConfig.fontColor.withOpacity(0.3),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "سعر المنتج",
                                  style: StyleConfig.fs14fwBold,
                                ),
                                Text(
                                  showPrice(
                                      '${orderDetailsPresenter.orderInfo?.subTotalAmount.replaceAll(RegExp(r'\.0+$'), '').replaceAll('#', '')} IQD'),
                                  style: StyleConfig.fs14fwNormal,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "تكلفة التوصيل",
                                  style: StyleConfig.fs14fwBold,
                                ),
                                Text(
                                  showPrice(
                                      '${orderDetailsPresenter.orderInfo?.totalShippingCost.replaceAll(RegExp(r'\.0+$'), '').replaceAll('#', '')} IQD'),
                                  style: StyleConfig.fs14fwNormal,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "كوبون الخـصـم",
                                  style: StyleConfig.fs14fwBold,
                                ),
                                Text(
                                  showPrice(
                                      '${orderDetailsPresenter.orderInfo?.couponDiscountAmount.replaceAll(RegExp(r'\.0+$'), '').replaceAll('#', '')} IQD'),
                                  style: StyleConfig.fs14fwNormal,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            const DottedLine(),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "المجموع الكلي",
                                  style: StyleConfig.fs14fwBold,
                                ),
                                Text(
                                  showPrice(
                                      '${orderDetailsPresenter.orderInfo?.totalPrice.replaceAll(RegExp(r'\.0+$'), '').replaceAll('#', '')} IQD'),
                                  style: StyleConfig.fs14fwNormal,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: getHeight(context),
                        child:
                            const Center(child: CircularProgressIndicator())),
              ),
            );
          }),
    );
  }

  Column buildBillingAddress(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          orderDetailsPresenter.orderInfo?.billingAddress?.address ?? "",
          style: StyleConfig.fs14fwNormal,
          maxLines: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            children: [
              Text(
                "${AppLang.local(context).city}: ",
                style: StyleConfig.fs14fwBold,
              ),
              Text(
                orderDetailsPresenter.orderInfo?.billingAddress?.cityName ?? "",
                style: StyleConfig.fs14fwNormal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            children: [
              Text(
                "${AppLang.local(context).state}: ",
                style: StyleConfig.fs14fwBold,
              ),
              Text(
                orderDetailsPresenter.orderInfo?.billingAddress?.stateName ??
                    "",
                style: StyleConfig.fs14fwNormal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            children: [
              Text(
                "${AppLang.local(context).country}: ",
                style: StyleConfig.fs14fwBold,
              ),
              Text(
                orderDetailsPresenter.orderInfo?.billingAddress?.countryName ??
                    "",
                style: StyleConfig.fs14fwNormal,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column buildShippingAddress(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          orderDetailsPresenter.orderInfo?.shippingAddress?.address ?? "",
          style: StyleConfig.fs14fwNormal,
          maxLines: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            children: [
              Text(
                "${AppLang.local(context).city}: ",
                style: StyleConfig.fs14fwBold,
              ),
              Text(
                orderDetailsPresenter.orderInfo?.shippingAddress?.cityName ??
                    "",
                style: StyleConfig.fs14fwNormal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            children: [
              Text(
                "${AppLang.local(context).state}: ",
                style: StyleConfig.fs14fwBold,
              ),
              Text(
                orderDetailsPresenter.orderInfo?.shippingAddress?.stateName ??
                    "",
                style: StyleConfig.fs14fwNormal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            children: [
              Text(
                "${AppLang.local(context).country}: ",
                style: StyleConfig.fs14fwBold,
              ),
              Text(
                orderDetailsPresenter.orderInfo?.shippingAddress?.countryName ??
                    "",
                style: StyleConfig.fs14fwNormal,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
