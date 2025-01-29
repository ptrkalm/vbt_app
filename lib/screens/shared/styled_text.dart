import 'package:flutter/material.dart';
import 'package:vbt_app/theme.dart';

abstract class BaseTextWidget extends StatelessWidget {
  const BaseTextWidget({
    required this.text,
    this.color = AppColors.textColor,
    this.isUppercased = false,
    this.isUnderlined = false,
    this.textAlign = TextAlign.left,
    super.key,
  });

  final String text;
  final Color color;
  final bool isUppercased;
  final bool isUnderlined;
  final TextAlign textAlign;

  TextStyle getTextStyle(BuildContext context);

  @override
  Widget build(BuildContext context) {
    TextStyle style = getTextStyle(context);

    return Text(
      textAlign: textAlign,
      isUppercased ? text.toUpperCase() : text,
      style: style.copyWith(
              color: color,
              decorationColor: color,
              decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none),
    );
  }
}

class SmallText extends BaseTextWidget {
  const SmallText(String text,
      {super.key, super.isUppercased, super.color, super.isUnderlined, super.textAlign})
      : super(text: text);

  @override
  TextStyle getTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!;
  }
}

class MediumText extends BaseTextWidget {
  const MediumText(String text,
      {super.key, super.isUppercased, super.color, super.isUnderlined, super.textAlign})
      : super(text: text);

  @override
  TextStyle getTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!;
  }
}

class LargeText extends BaseTextWidget {
  const LargeText(String text,
      {super.key, super.isUppercased, super.color, super.isUnderlined, super.textAlign})
      : super(text: text);

  @override
  TextStyle getTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!;
  }
}

class SmallHeadline extends BaseTextWidget {
  const SmallHeadline(String text,
      {super.key, super.isUppercased, super.color, super.isUnderlined, super.textAlign})
      : super(text: text);

  @override
  TextStyle getTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!;
  }
}

class MediumHeadline extends BaseTextWidget {
  const MediumHeadline(String text,
      {super.key, super.isUppercased, super.color, super.isUnderlined, super.textAlign})
      : super(text: text);

  @override
  TextStyle getTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!;
  }
}

class LargeHeadline extends BaseTextWidget {
  const LargeHeadline(String text,
      {super.key, super.isUppercased, super.color, super.isUnderlined, super.textAlign})
      : super(text: text);

  @override
  TextStyle getTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!;
  }
}

class SmallTitle extends BaseTextWidget {
  const SmallTitle(String text,
      {super.key, super.isUppercased, super.color, super.isUnderlined, super.textAlign})
      : super(text: text);

  @override
  TextStyle getTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall!;
  }
}

class MediumTitle extends BaseTextWidget {
  const MediumTitle(String text,
      {super.key, super.isUppercased, super.color, super.isUnderlined, super.textAlign})
      : super(text: text);

  @override
  TextStyle getTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!;
  }
}

class LargeTitle extends BaseTextWidget {
  const LargeTitle(String text,
      {super.key, super.isUppercased, super.color, super.isUnderlined, super.textAlign})
      : super(text: text);

  @override
  TextStyle getTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!;
  }
}
