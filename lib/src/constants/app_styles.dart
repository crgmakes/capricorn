import 'package:flutter/material.dart';

class AppStyles {
  static final styleBoarderCard = RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.grey.shade500,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(5),
  );

  static final styleBoarderCardDark = RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.grey.shade300,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(5),
  );
}
