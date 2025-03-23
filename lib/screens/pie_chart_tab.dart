import 'package:com_cipherschools_assignment/models/expense_model.dart';
import 'package:com_cipherschools_assignment/providers/expense_provider.dart';
import 'package:com_cipherschools_assignment/screens/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PieChartScreen extends ConsumerStatefulWidget {
  const PieChartScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PieChartScreenState createState() => _PieChartScreenState();
}

class _PieChartScreenState extends ConsumerState<PieChartScreen> {
  final categoryColors = {
    "Food": Colors.orange,
    "Travel": Colors.blue,
    "Subscriptions": Colors.purple,
    "Shopping": Colors.green,
    "Others": Colors.grey,
  };
  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expenseProvider);
    final categoryExpenses = _calculateCategoryExpenses(expenses);
    final totalExpenses = categoryExpenses.values.fold(0.0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CipherX",
          style: cTextStyle.copyWith(fontSize: 40, color: purple),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Spacer(),
          expenses.isEmpty
              ? Center(
                  child: Text(
                    "Add Expenses to \n Show Pie Chart",
                    style: kTextStyle.copyWith(color: Colors.black,fontSize: 30),
                  ),
                )
              : AspectRatio(
                  aspectRatio: 1.3,
                  child: PieChart(
                    PieChartData(
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                      sections:
                          _buildChartSections(categoryExpenses, totalExpenses),
                    ),
                  ),
                ),
          const SizedBox(height: 40),
          _buildCategoryDetails(categoryExpenses),
          const Spacer(),
        ],
      ),
    );
  }

  Map<String, double> _calculateCategoryExpenses(List<Expense> expenses) {
    Map<String, double> categoryTotals = {
      "Food": 0.0,
      "Travel": 0.0,
      "Subscriptions": 0.0,
      "Shopping": 0.0,
      "Others": 0.0,
    };

    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    return categoryTotals;
  }

  List<PieChartSectionData> _buildChartSections(
      Map<String, double> categoryExpenses, double totalExpenses) {
    List<PieChartSectionData> sections = [];

    categoryExpenses.forEach((category, amount) {
      const radius = 100.0;
      final percentage =
          totalExpenses == 0 ? 0 : (amount / totalExpenses) * 100;

      sections.add(
        PieChartSectionData(
          color: categoryColors[category]!,
          value: amount,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: radius,
          titleStyle: kTextStyle,
          badgeWidget: CircleAvatar(
            backgroundColor: categoryColors[category]!.shade100,
            child:
                Icon(categoryIcons[category], color: categoryColors[category]),
          ),
          badgePositionPercentageOffset: .98,
        ),
      );
    });

    return sections;
  }

  Widget _buildCategoryDetails(Map<String, double> categoryExpenses) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categoryExpenses.entries.map((entry) {
          String category = entry.key;
          double amount = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: categoryColors[category]!.shade100,
                  child: Icon(categoryIcons[category],
                      color: categoryColors[category]),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    category,
                    style:
                        kTextStyle.copyWith(color: Colors.black, fontSize: 18),
                  ),
                ),
                Text(
                  "₹${amount.toStringAsFixed(2)}",
                  style: kTextStyle.copyWith(color: Colors.red),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
