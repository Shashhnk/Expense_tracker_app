// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:com_cipherschools_assignment/providers/auth_provider.dart';
import 'package:com_cipherschools_assignment/screens/change_income.dart';
import 'package:com_cipherschools_assignment/screens/common.dart';
import 'package:com_cipherschools_assignment/screens/expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  void _login() async {
    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Accept Terms and Conditions')),
      );
      return;
    }
    setState(() => _isLoading = true);
    final authRepo = ref.read(authRepositoryProvider);

    try {
      await authRepo.signInWithGoogle();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in successfully!')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        if (firstSeen!) return ChangeIncome(true);
        return const ExpenseScreen();
      }));
    } catch (e) {
      debugPrint(e as String?);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget buttonGradient(String text, void Function() onTap) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: double.maxFinite,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white),
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(google),
                      Text(
                        text,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: sora),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            SizedBox(
                height: 130,
                width: 130,
                child: Image.asset(
                  icon,
                  color: purple,
                )),
            const SizedBox(
              height: 30,
            ),
            Text("CipherX",
                style: cTextStyle.copyWith(fontSize: 40, color: purple)),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 200,
              child: Center(
                child: SizedBox(
                  height: 150,
                  child: DefaultTextStyle(
                    style: aTextStyle,
                    child: AnimatedTextKit(
                      pause: const Duration(milliseconds: 500),
                      repeatForever: true,
                      animatedTexts: [
                        RotateAnimatedText(pages[0]["title"]!),
                        RotateAnimatedText(pages[1]["title"]!),
                        RotateAnimatedText(pages[2]["title"]!),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            buttonGradient('Log In with Google', _login),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  activeColor: purple,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'By signing up, you agree to the',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: sora,
                            ),
                          ),
                          TextSpan(
                            text: ' Terms of Service and Privacy Policy.',
                            style: TextStyle(
                              color: purple,
                              fontFamily: sora,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(
              flex: 2,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
