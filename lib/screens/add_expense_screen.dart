import 'package:com_cipherschools_assignment/models/expense_model.dart';
import 'package:com_cipherschools_assignment/providers/expense_provider.dart';
import 'package:com_cipherschools_assignment/screens/common.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final TextEditingController _amountController =
      TextEditingController(text: "0");
  final TextEditingController _titleController = TextEditingController();
  String? _selectedCategory;

  final List<String> categories = [
    "Food",
    "Travel",
    "Subscriptions",
    "Shopping",
    "Others"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Expense",
          style: kTextStyle,
        ),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Column(
              children: [
                const Spacer(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("How much?",
                      style: kTextStyle.copyWith(
                          color: Colors.white, fontSize: 20)),
                ),
                Row(
                  children: [
                    Text("₹",
                        style: kTextStyle.copyWith(
                            color: Colors.white, fontSize: 60)),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _amountController,
                        textAlign: TextAlign.left,
                        style: kTextStyle.copyWith(
                            color: Colors.white, fontSize: 50),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  dropdownField("Category", categories,
                      (value) => setState(() => _selectedCategory = value)),
                  textField("Description", _titleController),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _addExpense,
                    child: Text("Continue",
                        style: kTextStyle.copyWith(fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropdownField(
      String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget textField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _addExpense() {
    if (_amountController.text.isEmpty || _selectedCategory == null) return;
    final amount = int.tryParse(_amountController.text) ?? 0;
    final expense = Expense(
      id: const Uuid().v4(),
      title: _titleController.text,
      amount: amount.toDouble(),
      category: _selectedCategory!,
      date: DateTime.now(),
    );
    ref.read(expenseProvider.notifier).addExpense(expense);
    Navigator.pop(context);
  }
}
