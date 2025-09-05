import 'dart:io';

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
          backgroundColor: const Color(0xffACD7FD),
          extendBody: true,
          body: data.bottomAppbarChildren[data.bottomAppbarIndex],

          bottomNavigationBar: Container(
            alignment: const Alignment(0, -0.7),
            height: 80, //60
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 245, 245, 245),
                  Color.fromARGB(255, 232, 236, 236)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                top: BorderSide(
                    color: Colors.brown.withOpacity(0.3), width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          ),
          //
          floatingActionButton: (() {
            final cart = Provider.of<CartPresenter>(context);
            final cartCount = cart.cartResponse.cartCount;

            if (cartCount == 0) return null;

            return FloatingActionButton(
              shape: const CircleBorder(
                side: BorderSide(
                  color: ThemeConfig.white,
                  width: 3,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              onPressed: () {
                if (SystemData.isLogIn) {
                  MakeRoute.go(context, const Cart());
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                }
              },
              backgroundColor: const Color(0xff56DFCF),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: badges.Badge(
                  position: badges.BadgePosition.custom(end: 13, bottom: 10),
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.circle,
                    badgeColor: ThemeConfig.red,
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(width: 1, color: ThemeConfig.white),
                  ),
                  badgeContent: Text(
                    "$cartCount",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                  child: Image.asset(
                    getAssetIcon("cart.png"),
                    color: ThemeConfig.white,
                    height: 20,
                  ),
                ),
              ),
            );
          })(),

          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 39, 219, 186).withOpacity(0.8)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: AnimatedScale(
          scale: isSelected ? 1.2 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Row(
            children: [
              Image.asset(
                icon,
                width: 24,
                height: 24,
                color: isSelected ? Colors.white : Colors.black54,
              ),
              if (isSelected) const SizedBox(width: 6),
              if (isSelected)
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
