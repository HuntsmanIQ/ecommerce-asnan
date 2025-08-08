import 'package:flutter/material.dart';
import 'package:grostore/helpers/device_info_helper.dart';
import 'package:grostore/helpers/route.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  bool showFirst = true;
  late AnimationController _textController;
  late Animation<Offset> _textAnimation;

  @override
  void initState() {
    super.initState();
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _textAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    Future.delayed(const Duration(milliseconds: 100), () {
      _textController.forward();
    });

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        showFirst = false;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/img.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 2),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: showFirst
                  ? Column(
                      key: ValueKey('first'),
                      children: [
                        AnimatedContainer(
                          duration: const Duration(seconds: 2),
                          width: getWidth(context),
                          height: getHeight(context) - 180,
                          curve: Curves.easeInOut,
                          child: Image.asset(
                            'assets/images/landing_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 5),
                        SlideTransition(
                          position: _textAnimation,
                          child: const Text(
                            'مرحبا بك في متجرنا!',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SlideTransition(
                          position: _textAnimation,
                          child: const Center(
                            child: Text(
                              'أول تطبيق بالعراق مختص \n     بعنـاية الفم والأسـنان',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      key: ValueKey('second'),
                      children: [
                        Image.asset(
                          'assets/images/landing_logo.png',
                          width: getWidth(context),
                          height: getHeight(context) - 130,
                        ),
                        Positioned(
                          bottom: 40,
                          left: 130,
                          child: ElevatedButton(
                            onPressed: () {
                              
                              MakeRoute.goName(context, "/main");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'ابدأ الآن',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
