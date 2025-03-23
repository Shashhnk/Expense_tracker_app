
import 'package:hive/hive.dart';
import '../models/expense_model.dart';

class ExpenseRepository {
  static const String _boxName = "expenses";

  Future<void> addExpense(Expense expense) async {
    final box = await Hive.openBox<Expense>(_boxName);
    await box.put(expense.id, expense);
  }

  Future<void> deleteExpense(String id) async {
    final box = await Hive.openBox<Expense>(_boxName);
    await box.delete(id);
  }

  Future<List<Expense>> getAllExpenses() async {
    final box = await Hive.openBox<Expense>(_boxName);
    return box.values.toList();
  }
}
