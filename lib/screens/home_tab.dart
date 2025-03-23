import 'package:com_cipherschools_assignment/providers/expense_provider.dart';
import 'package:com_cipherschools_assignment/providers/income_provider.dart';
import 'package:com_cipherschools_assignment/screens/add_expense_screen.dart';
import 'package:com_cipherschools_assignment/screens/change_income.dart';
import 'package:com_cipherschools_assignment/screens/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  String selectedCategory = "All";
  final List<String> categories = [
    "All",
    "Food",
    "Travel",
    "Subscriptions",
    "Shopping",
    "Others"
  ];

  void _onpress() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddExpenseScreen(),
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

  void _onpresschangeIncome() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ChangeIncome(false),
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

  @override
  Widget build(BuildContext context) {
    final income = ref.watch(incomeProvider);
    final expenses = ref.watch(expenseProvider);
    final totalExpenses =
        expenses.fold(0, (sum, item) => sum + item.amount.toInt());
    final balance = income - totalExpenses;
    final filteredExpenses = selectedCategory == "All"
        ? expenses
        : expenses
            .where((expense) => expense.category == selectedCategory)
            .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "CipherX",
          style: cTextStyle.copyWith(fontSize: 40, color: purple),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: purple,
        onPressed: _onpress,
        child: const Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text("Account Balance",
                      style: kTextStyle.copyWith(color: Colors.grey)),
                  Text("₹$balance",
                      style: kTextStyle.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: purple)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                incomeExpenseCard(
                    "Income", "₹$income", Colors.green, _onpresschangeIncome),
                incomeExpenseCard(
                    "Expenses", "₹$totalExpenses", Colors.red, () {}),
              ],
            ),
            const SizedBox(height: 20),
            categoryFilters(),
            const SizedBox(height: 10),
            Expanded(
              child: (filteredExpenses.isEmpty)
                  ? Center(
                      child: Text(
                        "No Recorded Expenditure",
                        style: kTextStyle.copyWith(fontSize: 24, color: purple),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredExpenses.length,
                      itemBuilder: (context, index) {
                        final expense = filteredExpenses[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: transactionTile(
                              expense.category,
                              expense.title,
                              "-₹${expense.amount}",
                              expense.date,
                              categoryIcons[expense.category] ?? Icons.receipt,
                              categoryColors[expense.category] ?? Colors.black,
                              expense.id),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget incomeExpenseCard(
      String title, String amount, Color color, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: color.withOpacity(.4)),
              child: Icon(Icons.account_balance_wallet, color: color, size: 30),
            ),
            const SizedBox(width: 5),
            Column(
              children: [
                Text(title, style: kTextStyle.copyWith(color: Colors.grey)),
                Text(amount,
                    style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget categoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) => filterChip(category)).toList(),
      ),
    );
  }

  Widget filterChip(String label) {
    final isSelected = selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: isSelected
            ? Text(label, style: kTextStyle.copyWith(fontSize: 16))
            : Text(label,
                style: kTextStyle.copyWith(color: Colors.black, fontSize: 16)),
        selected: isSelected,
        backgroundColor: Colors.white,
        selectedColor: purple,
        onSelected: (selected) {
          setState(() {
            selectedCategory = label;
          });
        },
      ),
    );
  }

  Widget transactionTile(String title, String subtitle, String amount,
      DateTime time, IconData icon, Color iconColor, String id) {
    var date = formatDateTime(time);
    return Dismissible(
      key: Key(id), // Use a unique key (expense ID)
      direction: DismissDirection.endToStart, // Swipe from right to left
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        ref.read(expenseProvider.notifier).deleteExpense(id);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.2),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: kTextStyle.copyWith(color: Colors.black)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: kTextStyle.copyWith(color: Colors.grey),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(amount, style: kTextStyle.copyWith(color: Colors.red)),
                const SizedBox(height: 4),
                Text(date, style: kTextStyle.copyWith(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
