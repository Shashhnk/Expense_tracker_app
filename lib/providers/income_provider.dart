import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeNotifier extends StateNotifier<int> {
  IncomeNotifier() : super(0) {
    _loadIncome();
  }

  // Load income from SharedPreferences when the app starts
  Future<void> _loadIncome() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt('income') ?? 0;
  }

  // Update income and save it to SharedPreferences
  Future<void> updateIncome(int newIncome) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('income', newIncome);
    state = newIncome;
  }
}

// Riverpod provider for income state
final incomeProvider = StateNotifierProvider<IncomeNotifier, int>(
  (ref) => IncomeNotifier(),
);