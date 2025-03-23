import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

final kTextStyle = TextStyle(
    fontWeight: FontWeight.w600, fontFamily: sora, color: Colors.white);
final cTextStyle = TextStyle(
    fontWeight: FontWeight.w600, fontFamily: bruno, color: Colors.white);
final aTextStyle =
    TextStyle(fontSize: 35, fontFamily: bruno, color: Colors.black);

final sora = GoogleFonts.sora().fontFamily;
final bruno = GoogleFonts.brunoAceSc().fontFamily;

const purple = Color(0xFF7B61FF);

const icon = 'assets/images/Vector.png';
const google = 'assets/images/google.png';

String formatDateTime(DateTime dateTime) {
  String formattedDate = DateFormat("d MMM").format(dateTime); // "28 Feb"
  String formattedTime = DateFormat("h:mm a").format(dateTime); // "9:00 PM"
  return "$formattedDate | $formattedTime";
}

final Map<String, Color> categoryColors = {
  "Food": Colors.orange,
  "Travel": Colors.blue,
  "Subscriptions": Colors.purple,
  "Shopping": Colors.green,
  "Others": Colors.grey,
};
final Map<String, IconData> categoryIcons = {
  "Food": Icons.fastfood,
  "Travel": Icons.directions_car,
  "Subscriptions": Icons.subscriptions,
  "Shopping": Icons.shopping_bag,
  "Others": Icons.category,
};
final List<Map<String, String>> pages = [
  {
    "title": "Track Your Expenses.",
    "subtitle": "Monitor your spending effortlessly."
  },
  {
    "title": "Stay on Budget.",
    "subtitle": "Categorize expenses and control your finances."
  },
  {
    "title": "Achieve Financial Goals.",
    "subtitle": "Save more and spend wisely."
  },
];

Container buildDot(int index, int currentIndex) {
  return Container(
    height: currentIndex == index ? 10 : 7,
    width: currentIndex == index ? 10 : 7,
    margin: const EdgeInsets.only(right: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(currentIndex == index ? 10 : 7),
      color: Colors.white.withOpacity(currentIndex == index ? 1 : 0.2),
    ),
  );
}

bool emailValidate(String email) {
  RegExp emailexp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  return emailexp.hasMatch(email);
}

late bool? firstSeen;
