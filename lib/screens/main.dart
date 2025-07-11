import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:grostore/app_lang.dart';
import 'package:grostore/configs/theme_config.dart';
import 'package:grostore/custom_classes/system_data.dart';
import 'package:grostore/helpers/common_functions.dart';
import 'package:grostore/helpers/route.dart';
import 'package:grostore/presenters/main_persenter.dart';
import 'package:grostore/presenters/stock_locations_presenter.dart';
import 'package:grostore/screens/auth/login.dart';
import 'package:grostore/screens/cart.dart';
import 'package:provider/provider.dart';
import '../presenters/cart_presenter.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    Provider.of<MainPresenter>(context, listen: false).setContext(context);
    Future.delayed(const Duration(seconds: 1)).then((value) {
      Provider.of<StockLocationsPresenter>(context, listen: false)
          .fetchLocations(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainPresenter>(builder: (context, data, child) {
      return WillPopScope(
        onWillPop: () async {
          if (data.bottomAppbarIndex != 0) {
            data.onTapped(0);
          } else {
            return Future.delayed(Duration.zero);
          }
          return Future.delayed(Duration.zero);
        },
        child: Scaffold(
          extendBody: true,
          body: data.bottomAppbarChildren[data.bottomAppbarIndex],

          // ✅ Bottom Bar جديد بالشكل المطلوب
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            elevation: 10,
            color: const Color(0xffFAD79C).withOpacity(0.4),
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildNavItem(
                        icon: getAssetIcon("home.png"),
                        label: AppLang.local(context).home,
                        index: 0,
                        selectedIndex: data.bottomAppbarIndex,
                        onTap: data.onTapped,
                      ),
                      _buildNavItem(
                        icon: getAssetIcon("categories.png"),
                        label: AppLang.local(context).categories,
                        index: 1,
                        selectedIndex: data.bottomAppbarIndex,
                        onTap: data.onTapped,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildNavItem(
                        icon: getAssetIcon("orders.png"),
                        label: AppLang.local(context).orders,
                        index: 2,
                        selectedIndex: data.bottomAppbarIndex,
                        onTap: data.onTapped,
                      ),
                      _buildNavItem(
                        icon: getAssetIcon("profile.png"),
                        label: AppLang.local(context).profile,
                        index: 3,
                        selectedIndex: data.bottomAppbarIndex,
                        onTap: data.onTapped,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ✅ زر السلة العائم
          floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(
                side: BorderSide(
                    color: ThemeConfig.white,
                    width: 3,
                    strokeAlign: BorderSide.strokeAlignOutside),
              ),
              onPressed: () {
                if (SystemData.isLogIn) {
                  MakeRoute.go(context, const Cart());
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                  return;
                }
              },
              backgroundColor: const Color(0xff56DFCF),
              child: Consumer<CartPresenter>(
                builder: (context, cart, child) {
                  final cartCount = cart.cartResponse.cartCount;

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: cartCount == 0
                        ? Image.asset(
                            getAssetIcon("cart.png"),
                            color: ThemeConfig.white,
                            height: 20,
                          )
                        : badges.Badge(
                            position: badges.BadgePosition.custom(
                                end: 13, bottom: 10),
                            badgeStyle: badges.BadgeStyle(
                              shape: badges.BadgeShape.circle,
                              badgeColor: ThemeConfig.red,
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  width: 1, color: ThemeConfig.white),
                            ),
                            badgeContent: Text(
                              "$cartCount",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                  fontSize: 10, color: Colors.white),
                            ),
                            child: Image.asset(
                              getAssetIcon("cart.png"),
                              color: ThemeConfig.white,
                              height: 20,
                            ),
                          ),
                  );
                },
              )
             
              ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      );
    });
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required int index,
    required int selectedIndex,
    required Function(int) onTap,
  }) {
    final isSelected = selectedIndex == index;

    return MaterialButton(
      onPressed: () => onTap(index),
      minWidth: 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            color: isSelected ? ThemeConfig.accentColor : ThemeConfig.grey,
            height: 20,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? ThemeConfig.accentColor : ThemeConfig.grey,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
