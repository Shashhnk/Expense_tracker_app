import 'package:com_cipherschools_assignment/repositories/expense_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense_model.dart';

final expenseRepositoryProvider = Provider((ref) => ExpenseRepository());

final expenseProvider =
    StateNotifierProvider<ExpenseNotifier, List<Expense>>((ref) {
  final repository = ref.read(expenseRepositoryProvider);
  return ExpenseNotifier(repository);
});

class ExpenseNotifier extends StateNotifier<List<Expense>> {
  final ExpenseRepository repository;

  ExpenseNotifier(this.repository) : super([]) {
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    state = await repository.getAllExpenses();
  }

  Future<void> addExpense(Expense expense) async {
    await repository.addExpense(expense);
    state = [...state, expense]; // Update the state
  }

  Future<void> deleteExpense(String id) async {
    await repository.deleteExpense(id);
    state = state.where((expense) => expense.id != id).toList();
  }
}
