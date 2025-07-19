
  import 'package:flutter/material.dart';

Color getColorForCategory(String category) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
    ];
    
    switch (category.toLowerCase()) {
      case 'crochet': return colors[0];
      case 'mugs': return colors[1];
      case 'scented candles': return colors[2];
      case 'resin': return colors[3];
      case 'mirros': return colors[4];
      default: return colors[7];
    } 
  }
