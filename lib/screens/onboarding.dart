import 'package:com_cipherschools_assignment/screens/common.dart';
import 'package:com_cipherschools_assignment/screens/login_screen.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currindex = 0;

  void nextPage() {
    if (currindex < pages.length - 1) {
      setState(() {
        currindex++;
      });
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purple,
      body: Padding(
        padding: const EdgeInsets.only(left: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 130,
                width: 130,
                margin: const EdgeInsets.only(left: 30),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(icon),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("CipherX", style: cTextStyle.copyWith(fontSize: 40)),
            ),
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(pages[currindex]["title"]!,
                  style: kTextStyle.copyWith(fontSize: 24)),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(pages[currindex]["subtitle"]!,
                  textAlign: TextAlign.center,
                  style: kTextStyle.copyWith(fontSize: 14)),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => buildDot(index, currindex),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0, right: 0),
                child: GestureDetector(
                  onTap: nextPage,
                  child: Container(
                    height: MediaQuery.sizeOf(context).width / 2,
                    width: MediaQuery.sizeOf(context).width / 2,
                    padding: const EdgeInsets.only(top: 80, left: 80),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              MediaQuery.sizeOf(context).width / 2)),
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: purple,
                      size: 80,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
