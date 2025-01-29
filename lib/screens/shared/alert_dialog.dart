import 'package:flutter/material.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/theme.dart';

class VBTAlertDialog extends StatelessWidget {
  VBTAlertDialog(this.headline, this.text, {super.key, List<TextButton>? buttons})
      : buttons = buttons ?? [];

  final String headline;
  final String text;
  final List<TextButton> buttons;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: MediumTitle(
          headline,
          color: AppColors.backgroundColorAccent,
        ),
        content: MediumText(text, color: AppColors.backgroundColorAccent),
        actionsAlignment: MainAxisAlignment.end,
        actions: buttons.isEmpty
            ? [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const MediumHeadline(
                      'OK',
                      color: AppColors.backgroundColorAccent,
                    ))
              ]
            : buttons);
  }
}
