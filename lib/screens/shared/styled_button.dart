import 'package:flutter/material.dart';
import 'package:vbt_app/theme.dart';

class StyledButton extends StatelessWidget {
  const StyledButton({super.key, required this.onPressed, required this.text, this.icon, this.color});

  final Function() onPressed;
  final String text;
  final Icon? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: color ?? AppColors.primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              IconTheme(
                  data: const IconThemeData(color: AppColors.backgroundColorAccent), child: icon!),
            if (icon != null) const SizedBox(width: 4),
            Text(text, style: const TextStyle(color: AppColors.backgroundColorAccent)),
          ],
        ),
      ),
    );
  }
}
