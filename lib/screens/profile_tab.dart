import 'package:com_cipherschools_assignment/providers/auth_provider.dart';
import 'package:com_cipherschools_assignment/screens/change_income.dart';
import 'package:com_cipherschools_assignment/screens/common.dart';
import 'package:com_cipherschools_assignment/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  Widget _buildMenuItem(
      IconData icon, String title, Color iconColor, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: iconColor.withOpacity(.4)),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: kTextStyle.copyWith(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  void _onpresschangeIncome(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => ChangeIncome(false),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1), // Start from bottom
              end: const Offset(0, 0), // End at normal position
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
            child: child,
          );
        },
      ),
    );
  }

  void logout(WidgetRef ref, BuildContext context) async {
    await ref.read(authRepositoryProvider).signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully!')),
    );
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.read(authRepositoryProvider).getUser();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Username",
                  style: kTextStyle.copyWith(fontSize: 20, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                user!.displayName ?? "Not Available",
                style: kTextStyle.copyWith(fontSize: 40, color: Colors.black),
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem(Icons.account_balance_wallet,
                        "Change Income", Colors.green, () {
                      _onpresschangeIncome(context);
                    }),
                    _buildMenuItem(Icons.logout, "Logout", Colors.red, () {
                      logout(ref, context);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
