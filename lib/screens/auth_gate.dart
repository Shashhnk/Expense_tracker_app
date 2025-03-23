import 'package:com_cipherschools_assignment/providers/auth_provider.dart';
import 'package:com_cipherschools_assignment/screens/common.dart';
import 'package:com_cipherschools_assignment/screens/expense_screen.dart';
import 'package:com_cipherschools_assignment/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_screen.dart';

// ignore: must_be_immutable
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    bool seen = (firstSeen == null || firstSeen == true) ? true : false;

    return authState.when(
      data: (user) => user == null
          ? (seen)
              ? const Onboarding()
              : const LoginScreen()
          : const ExpenseScreen(),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text("Error: $error"))),
    );
  }
}
