import 'package:flutter/material.dart';


CircularProgressIndicator indicator(Color c) {
  return CircularProgressIndicator(
    color: c, 
    padding: const EdgeInsets.all(0),
    strokeWidth: 4,    
  );
}