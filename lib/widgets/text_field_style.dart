import 'package:flutter/material.dart';

OutlineInputBorder focusedBorder(Color c) {
  return OutlineInputBorder(
    borderRadius: .circular(20),
    borderSide: BorderSide(
      width: 1.5,
      color: c,
    ),
  );
}

OutlineInputBorder enabledBorder(Color c) {
  return OutlineInputBorder(
     borderRadius: .circular(15),
    borderSide: BorderSide(
      width: 1.5,
      color: c,
    ),
  );
}

