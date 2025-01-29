import 'package:flutter/material.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/theme.dart';

class _FloatingActionButtonBase extends StatelessWidget {
  const _FloatingActionButtonBase(
      {super.key,
      required this.label,
      this.icon,
      required this.onPressed,
      required this.foregroundColor,
      required this.backgroundColor,
      this.isOutlined = false,
      required this.heroTag});

  final String label;
  final Icon? icon;
  final Function() onPressed;
  final Color foregroundColor;
  final Color backgroundColor;
  final bool isOutlined;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: isOutlined
                ? BorderSide(style: BorderStyle.solid, color: foregroundColor)
                : BorderSide.none),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        label: MediumText(
          label,
          color: foregroundColor,
        ),
        icon: icon,
        onPressed: onPressed,
        heroTag: heroTag);
  }
}

class PrimaryFloatingActionButton extends _FloatingActionButtonBase {
  const PrimaryFloatingActionButton({
    super.key,
    required super.label,
    super.icon,
    required super.onPressed,
    required super.heroTag,
  }) : super(
          foregroundColor: AppColors.backgroundColorAccent,
          backgroundColor: AppColors.primaryColor,
        );
}

class SecondaryFloatingActionButton extends _FloatingActionButtonBase {
  const SecondaryFloatingActionButton({
    super.key,
    required super.label,
    super.icon,
    required super.onPressed,
    required super.heroTag,
  }) : super(
          foregroundColor: AppColors.backgroundColorAccent,
          backgroundColor: AppColors.secondaryColor,
        );
}

class PrimaryOutlinedFloatingActionButton extends _FloatingActionButtonBase {
  const PrimaryOutlinedFloatingActionButton({
    super.key,
    required super.label,
    super.icon,
    required super.onPressed,
    required super.heroTag,
  }) : super(
            foregroundColor: AppColors.primaryColor,
            backgroundColor: AppColors.backgroundColorAccent,
            isOutlined: true);
}
