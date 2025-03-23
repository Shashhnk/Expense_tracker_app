import 'package:com_cipherschools_assignment/providers/income_provider.dart';
import 'package:com_cipherschools_assignment/screens/common.dart';
import 'package:com_cipherschools_assignment/screens/expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeIncome extends ConsumerWidget {
  final bool isFirstSeen;
  ChangeIncome(this.isFirstSeen, {super.key});
  final TextEditingController _incomeController =
      TextEditingController(text: "0");

  void _changeIncome(WidgetRef ref, BuildContext context) {
    final newIncome = int.tryParse(_incomeController.text) ?? 0;

    ref.read(incomeProvider.notifier).updateIncome(newIncome);
    if (isFirstSeen) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const ExpenseScreen();
          },
        ),
      );
      setFirstSeen();
      return;
    }
    Navigator.pop(context);
  }

  void setFirstSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstSeen', false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text(
          "Income",
          style: kTextStyle,
        ),
        backgroundColor: Colors.green,
        leading: isFirstSeen
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Column(
          children: [
            const Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Enter Your Income",
                  style:
                      kTextStyle.copyWith(color: Colors.white, fontSize: 28)),
            ),
            Row(
              children: [
                Text("₹",
                    style:
                        kTextStyle.copyWith(color: Colors.white, fontSize: 60)),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _incomeController,
                    textAlign: TextAlign.left,
                    style:
                        kTextStyle.copyWith(color: Colors.white, fontSize: 50),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                _changeIncome(ref, context);
              },
              child: Text("Continue",
                  style:
                      kTextStyle.copyWith(fontSize: 20, color: Colors.green)),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
