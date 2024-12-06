import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monlivreur/screens/phonelogin.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _FirstScreen();
}

class _FirstScreen extends State<MyWidget> {
  final controller = PageController();
  bool isLastPage = false;

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required String subtitle,
  }) =>
      Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              urlImage,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            const SizedBox(height: 64),
            Text(
              title,
              style: TextStyle(
                color: Colors.teal.shade700,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(),
              child: Text(
                subtitle,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 60),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            buildPage(
              color: Colors.yellow,
              urlImage: 'assets/images/img2.png',
              title: 'Commander vos Norriture',
              subtitle: 'welcome',
            ),
            buildPage(
              color: Colors.yellow,
              urlImage: 'assets/images/img3.png',
              title: 'Avoir des colis',
              subtitle: 'welcome',
            ),
            buildPage(
              color: Colors.yellow,
              urlImage: 'assets/images/img1.png',
              title: 'Fast delivry',
              subtitle: 'welcome',
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1),
                ),
                primary: Colors.white,
                backgroundColor: Colors.teal.shade700,
                minimumSize: const Size.fromHeight(80),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('showHome', true);
                
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MyPhone()),
                );
              },
              child: const Text('Get Started'),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              height: 80,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          controller.jumpToPage(2);
                        },
                        child: const Text('Skip')),
                    Center(
                        child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      onDotClicked: (index) => controller.animateToPage(index,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                    )),
                    TextButton(
                        onPressed: () {
                          controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Next')),
                  ]),
            ),
    );
  }
}
