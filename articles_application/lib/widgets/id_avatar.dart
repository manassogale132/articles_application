import 'package:flutter/material.dart';
import '../utils/color_generator.dart';

class IdAvatar extends StatelessWidget {
  final int id;
  final double size;

  const IdAvatar({super.key, required this.id, this.size = 50});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = ColorGenerator.fromId(id);
    final Color textColor = ColorGenerator.getTextColor(backgroundColor);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          id.toString(),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4,
          ),
        ),
      ),
    );
  }
}
