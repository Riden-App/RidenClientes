import 'package:flutter/material.dart';

void minimizeSheet(DraggableScrollableController scrollController) {
  scrollController.animateTo(
    0.1,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}

void maximizeSheet(DraggableScrollableController scrollController) {
  scrollController.animateTo(
    0.9,
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}
