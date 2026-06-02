import 'package:flutter/material.dart';

class CheckerboardRow extends StatelessWidget {
  final double blockWidth;
  final double blockHeight;

  const CheckerboardRow({
    super.key,
    this.blockWidth = 20,
    this.blockHeight = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        41,
        (index) => Container(
          width: blockWidth,
          height: blockHeight,
          color: index % 2 == 0 ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}