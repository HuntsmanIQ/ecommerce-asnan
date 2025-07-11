import 'package:flutter/material.dart';
import 'package:grostore/app_lang.dart';
import 'package:grostore/configs/style_config.dart';
import 'package:grostore/configs/theme_config.dart';
import 'package:grostore/custom_classes/system_data.dart';
import 'package:grostore/custom_ui/BoxDecorations.dart';
import 'package:grostore/custom_ui/Button.dart';
import 'package:grostore/custom_ui/Image_view.dart';
import 'package:grostore/helpers/common_functions.dart';
import 'package:grostore/helpers/device_info_helper.dart';
import 'package:grostore/helpers/route.dart';
import 'package:grostore/presenters/auth/auth_presenter.dart';
import 'package:grostore/screens/address/addresses.dart';
import 'package:grostore/screens/auth/login.dart';
import 'package:grostore/screens/coupons.dart';
import 'package:grostore/screens/help_center.dart';
import 'package:grostore/screens/main.dart';
import 'package:grostore/screens/order/orders.dart';
import 'package:grostore/screens/pages.dart';
import 'package:grostore/screens/profile_edit.dart';
import 'package:grostore/screens/setting.dart';
import 'package:grostore/screens/stock_locations.dart';
import 'package:grostore/screens/track_order.dart';
import 'package:grostore/screens/wishlist.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.accentColor,
      appBar: AppBar(
        backgroundColor: ThemeConfig.accentColor,
        elevation: 0,
        leading: const SizedBox.shrink(),
        actions: [
          buildBackButtonContainer(context),
        ],
      ),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 160, 
            width: getWidth(context),
            padding: EdgeInsets.symmetric(
                horizontal: StyleConfig.padding, vertical: 10),
            child: SystemData.isLogIn
                ? Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageView(
                              url: SystemData.userInfo.avatar,
                              width: 80,
                              height: 80,
                              radius: 10),
                          const SizedBox(
                            width: 14,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                SystemData.userInfo.name,
                                style: StyleConfig.fs16cWhitefwBold,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                SystemData.userInfo.email,
                                style: StyleConfig.fs12cWhitefwBold,
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      Button(
                        onPressed: () {
                          MakeRoute.go(context, const ProfileEdit());
                        },
                        minWidth: 60,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        shape: StyleConfig.buttonRadius(8).copyWith(
                            side:
                                const BorderSide(width: 1, color: ThemeConfig.white))
                        // RoundedRectangleBorder(borderRadius: BorderRadius.c),
                        ,
                        child: Text(
                          AppLang.local(context).edit_profile_ucf,
                          style: StyleConfig.fs12cWhitefwBold,
                        ),
                      )
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                            color: ThemeConfig.extraDarkGrey),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        child: Image.asset(
                          getAssetIcon("profile.png"),
                          color: ThemeConfig.lightGrey,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Button(
                        minWidth: 20,
                       
                        onPressed: () {
                          MakeRoute.go(context, const Login());
                        },
                        child: Text(
                          "تـسجيل الدخـول",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          )
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.only(
                  left: StyleConfig.padding,
                  right: StyleConfig.padding,
                  top: 40),
              decoration: BoxDecorations.customRadius(
                  radius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: ThemeConfig.white),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    optionModel(AppLang.local(context).pick_a_location,
                        getAssetIcon("address.png"), const StockLocations()),
                    if (SystemData.isLogIn)
                      Column(
                        children: [
                          optionModel(
                              AppLang.local(context).voucher_n_offers_ucf,
                              getAssetIcon("coupons.png"),
                              const Coupons()),
                          optionModel(AppLang.local(context).favorite,
                              getAssetIcon("favorite.png"), const Wishlist()),
                          optionModel(
                              AppLang.local(context).order_n_recording_ucf,
                              getAssetIcon("orders.png"),
                              Orders(
                                fromBottomBar: false,
                              )),
                          
                          optionModel(AppLang.local(context).address,
                              getAssetIcon("address.png"), const Addresses()),
                          
                          optionModel(AppLang.local(context).track_my_order_ucf,
                              getAssetIcon("track.png"), const TrackOrder()),
                         
                         
                        ],
                      ),
                    optionModel(AppLang.local(context).help_center_ucf,
                        getAssetIcon("help_center.png"), const HelpCenter()),
                    optionModel(AppLang.local(context).settings,
                        getAssetIcon("setting.png"), const Setting()),
                    optionModel(
                        AppLang.local(context).terms_n_conditions_ucf,
                        getAssetIcon("terms_condition.png"),
                        const Pages(slug: "terms-conditions")),
                    if (SystemData.isLogIn)
                      logoutModel(AppLang.local(context).log_out_ucf,
                          getAssetIcon("logout.png"), () {
                        Provider.of<AuthPresenter>(context, listen: false)
                            .logout(context);
                        MakeRoute.goAndRemoveAll(context, const Main());
                      }),
                    if (!SystemData.isLogIn)
                      optionModel(AppLang.local(context).login,
                          getAssetIcon("login.png"), const Login()),
                    const SizedBox(height: 50)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildBackButtonContainer(BuildContext context) {
    return Container(
      height: 47,
      alignment: Alignment.topRight,
      child: SizedBox(
        width: 47,
        child: Button(
          minWidth: 0,
          padding: EdgeInsets.zero,
          onPressed: () {
            pop(context);
          },
          child: const Icon(
            Icons.close,
            size: 30,
            color: ThemeConfig.white,
          ),
        ),
      ),
    );
  }

  Widget optionModel(String title, String logo, Widget route) {
    return Container(
      margin: EdgeInsets.only(bottom: StyleConfig.xsSectionSpacer),
      height: 40,
      child: Button(
        minWidth: 40,
        onPressed: () {
          MakeRoute.go(context, route);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(logo,
                width: 18, height: 18, color: ThemeConfig.extraDarkGrey),
            const SizedBox(
              width: 26,
            ),
            Text(
              title,
              style: StyleConfig.fs14fwNormal,
            ),
            const Spacer(),
            // Image.asset(getAssetIcon("next.png"), width: 14,
            //     height: 14,
            //     color: ThemeConfig.fontColor),
          ],
        ),
      ),
    );
  }

  Widget logoutModel(String title, String logo, dynamic onPress) {
    return Container(
      margin: EdgeInsets.only(bottom: StyleConfig.padding),
      height: 40,
      child: Button(
        minWidth: 40,
        onPressed: onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(logo,
                width: 18, height: 18, color: ThemeConfig.extraDarkGrey),
            const SizedBox(
              width: 26,
            ),
            Text(
              title,
              style: StyleConfig.fs14fwNormal,
            ),
            const Spacer(),
            // Image.asset(getAssetIcon("next.png"), width: 14,
            //     height: 14,
            //     color: ThemeConfig.fontColor),
          ],
        ),
      ),
    );
  }
}