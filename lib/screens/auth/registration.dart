import 'package:flutter/material.dart';
import 'package:grostore/app_lang.dart';
import 'package:grostore/configs/style_config.dart';
import 'package:grostore/configs/theme_config.dart';
import 'package:grostore/custom_ui/Button.dart';
import 'package:grostore/custom_ui/BoxDecorations.dart';
import 'package:grostore/custom_ui/input_decorations.dart';
import 'package:grostore/helpers/common_functions.dart';
import 'package:grostore/helpers/device_info_helper.dart';
import 'package:grostore/presenters/auth/auth_presenter.dart';
import 'package:grostore/screens/auth/login.dart';
import 'package:provider/provider.dart';
import '../../custom_ui/auth_ui.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthPresenter>(context).setContext(context);
    return AuthScreen.buildScreen(
        context, buildBody(context, getWidth(context)));
  }

  Widget buildBody(BuildContext context, double screenWidth) {
    return Consumer<AuthPresenter>(builder: (context, data, child) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: StyleConfig.padding),
        width: screenWidth * (3 / 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: getWidth(context),
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                AppLang.local(context).create_new_account_ucf,
                style: StyleConfig.fs24fwBold,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                AppLang.local(context).name,
                style: TextStyle(
                    color: ThemeConfig.fontColor, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                height: 36,
                child: TextField(
                  controller: data.regNameController,
                  autofocus: false,
                  decoration: InputDecorations.basic(
                      prefixIcon: Icon(
                        Icons.person_outline,
                        size: 18,
                        color: ThemeConfig.mediumGrey,
                      ),
                      hint_text: "Mr. John"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                AppLang.local(context).email,
                style: TextStyle(
                    color: ThemeConfig.fontColor, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 36,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: data.regEmailController,
                      autofocus: false,
                      decoration: InputDecorations.basic(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            size: 18,
                            color: ThemeConfig.mediumGrey,
                          ),
                          hint_text: "user@example.com"),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                AppLang.local(context).phone,
                style: TextStyle(
                    color: ThemeConfig.fontColor, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                  decoration: BoxDecorations.basic(),
                  height: 36,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Icon(
                          Icons.phone,
                          size: 18,
                          color: ThemeConfig.mediumGrey,
                        ),
                      ),
                      SizedBox(
                       
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                getAssetFlag("iq.png"),
                              ),
                            ),
                            Text(
                              "+964",
                              style: StyleConfig.fs14fwNormal,
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        width: getWidth(context) - 200,
                        child: TextField(
                          style: StyleConfig.fs14fwNormal,
                          decoration: const InputDecoration.collapsed(
                              hintText: ""),
                          controller: data.regPhoneNumberController,
                        ),
                      )
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                AppLang.local(context).password,
                style: TextStyle(
                    color: ThemeConfig.fontColor, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 36,
                    child: TextField(
                      controller: data.regPasswordController,
                      autofocus: false,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecorations.basic(
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 18,
                            color: ThemeConfig.mediumGrey,
                          ),
                          hint_text: "• • • • • • • •"),
                    ),
                  ),
                  Text(
                    AppLang.local(context).password_must_be_at_last_6_digit,
                    style: TextStyle(
                        color: ThemeConfig.lightGrey,
                        fontStyle: FontStyle.italic),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                AppLang.local(context).confirm_password_ucf,
                style: TextStyle(
                    color: ThemeConfig.fontColor, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                height: 36,
                child: TextField(
                  controller: data.regPasswordConfirmController,
                  autofocus: false,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecorations.basic(
                      prefixIcon: Icon(
                        Icons.lock,
                        size: 18,
                        color: ThemeConfig.mediumGrey,
                      ),
                      hint_text: "• • • • • • • •"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: SizedBox(
                height: 45,
                child: Button.minSize(
                    width: getWidth(context),
                    height: 50,
                    color: ThemeConfig.accentColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0))),
                    child: Text(
                      AppLang.local(context).sign_up_ucf,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      data.onPressSignUp();
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                    AppLang.local(context).already_have_an_account,
                    style:
                        TextStyle(color: ThemeConfig.fontColor, fontSize: 12),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Button(
                    minWidth: 20,
                    child: Text(
                      AppLang.local(context).login,
                      style: TextStyle(
                          color: ThemeConfig.accentColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const Login();
                      }));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  AlertDialog buildFilterDialog(AuthPresenter data) {
    return AlertDialog(
      title: const Text('Search Country'),
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              onChanged: data.filterCountry,
              decoration: const InputDecoration(
                hintText: 'Search',
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<AuthPresenter>(
                    builder: (context, filterData, child) {
                  return Column(
                    children: List.generate(filterData.filteredCountry.length,
                        (index) {
                      final country = filterData.filteredCountry[index];
                      return ListTile(
                        leading: Image.asset(
                          getAssetFlag("${country.code.toLowerCase()}.png"),
                          height: 30,
                          width: 30,
                        ),
                        title: Text(country.name),
                        onTap: () {
                          data.onChangeCountry(country);
                          Navigator.of(context).pop();
                          filterData.filteredCountry = filterData.country;
                        },
                      );
                    }),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
