import 'package:flutter/material.dart';
import 'package:grostore/configs/style_config.dart';
import 'package:grostore/configs/theme_config.dart';
import 'package:grostore/helpers/common_functions.dart';
import 'package:grostore/helpers/device_info_helper.dart';

class AuthScreen {
  static Widget buildScreen(BuildContext context, Widget child) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        height: getHeight(context),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(top: 48.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      width: 250,
                      height: 200,
                      decoration: BoxDecoration(
                          color: ThemeConfig.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Image.asset(
                        getAssetLogo("logo.png"),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: StyleConfig.padding - 3),
                    child: child,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
