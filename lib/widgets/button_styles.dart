import 'package:flutter/material.dart';

// making the design of the elevatedButton Of Currency
ButtonStyle currencyStyle(double w, double h, Color c) {
  return ElevatedButton.styleFrom(
    elevation: 3,
    padding: const EdgeInsets.all(0),
    shape: RoundedRectangleBorder(borderRadius: .circular(20)),
    fixedSize: Size(w * 0.37, h * 0.065),
    backgroundColor: c,
  );
}

// making the buttonStyle for outer buttons like currency and view exchange rate buttons

ButtonStyle outerButtonsStyle(double w, double h, Color c, Color borderC) {
  return ElevatedButton.styleFrom(
    elevation: 3,
    padding: const EdgeInsets.all(0),
    shape: RoundedRectangleBorder(borderRadius: .circular(20)),
    fixedSize: Size(w * 1.0, h * 0.07),
    side: BorderSide(color: borderC, width: 1.5),
    backgroundColor: c,
  );
}

// making the buttonStyle for the filter By
ButtonStyle filterButtonStyle(double w, double h, Color c) {
  return ElevatedButton.styleFrom(
    elevation: 3,
    padding: const EdgeInsets.symmetric(),
    backgroundColor: c,
    visualDensity: VisualDensity(vertical: -4),
    fixedSize: Size(w * 0.3, h * 0.05),
    shape: RoundedRectangleBorder(borderRadius: .circular(20)),
  );
}
