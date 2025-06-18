import 'package:flutter/material.dart';
import 'package:grostore/apis/auth_api.dart';
import 'package:grostore/apis/setting_api.dart';
import 'package:grostore/configs/app_config.dart';
import 'package:grostore/configs/style_config.dart';
import 'package:grostore/configs/theme_config.dart';
import 'package:grostore/custom_classes/system_data.dart';
import 'package:grostore/helpers/common_functions.dart';
import 'package:grostore/helpers/device_info_helper.dart';
import 'package:grostore/helpers/route.dart';
import 'package:grostore/helpers/shared_value_helper.dart';
import 'package:grostore/presenters/auth/auth_presenter.dart';
import 'package:grostore/presenters/cart_presenter.dart';
import 'package:grostore/presenters/setting_presenter.dart';
import 'package:grostore/screens/landing_pages/landing_page.dart';
import 'package:grostore/screens/main.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSettings();

    system_currency.load().then((value) {
      Provider.of<SettingPresenter>(context, listen: false).initState();
    });

    Future.delayed(const Duration(seconds: 2)).then((value) {
      access_token.load();
      show_landing_page.load().then((value) {
        checkLogin();
      });
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Main()), (route) => false);
    });
  }

  checkLogin() async {
    await show_landing_page.load();
    var res = await AuthApi.tokenCheck(context);
    if (res.result) {
      SystemData.isLogIn = true;
      SystemData.userInfo = res.user;
      await app_language.load();
      await stock_location_id.load();
      Provider.of<CartPresenter>(context, listen: false).fetchCart();
    }
    if (show_landing_page.$) {
      show_landing_page.$ = false;
      show_landing_page.save();
      MakeRoute.goAndRemoveAll(context, const LandingPage());
    } else {
      Provider.of<AuthPresenter>(context, listen: false).tokenCheck(context);

      MakeRoute.goAndRemoveAll(context, Main());
    }
  }

  getSettings() async {
    var res = await SettingApi.getSettings();
    SystemData.settings = res.object;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // خلفية عصرية وناعمة
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  getAssetLogo('logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              strokeWidth: 4,

              valueColor: AlwaysStoppedAnimation(Color(0xFF00CFC1)), // لون حديث
            ),
            const SizedBox(height: 20),
            const Text(
              'جاري تحميل التطبيق...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
