import 'package:flutter/material.dart';
import 'package:wingai/core/themes/styles.dart';

enum ButtonType { fill, outline, labelButton, disable }

class ButtonWidget extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final ButtonType buttonType;
  final Color? textcolor;

  final VoidCallback? onPressed;
  final bool primary;

  const ButtonWidget({
    super.key,
    this.label,
    this.icon,
    this.buttonType = ButtonType.fill,
    this.onPressed,
    this.textcolor,
    this.primary = true,
  }) : assert(label != null || icon != null, 'Label or icon must be provided.');

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    Color textColor = textcolor!;

    if (buttonType == ButtonType.fill) {
      backgroundColor = AppColors
          .primary; //= primary ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary;
      // textColor = AppColors
      //     .lightGreyIconColor; //primary ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSecondary;
    } else {
      backgroundColor = AppColors
          .lightGreyIconColor; //primary ? AppColors.lightGreyIconColor : Theme.of(context).colorScheme.secondary;
      // textColor = AppColors
      //     .lightGreyIconColor; //primary ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary;
    }

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null)
          Icon(
            icon,
            size: 18.0,
            color: textColor,
          ),
        if (icon != null && label != null) const SizedBox(width: 8),
        if (label != null)
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: textColor,
                ),
          ),
      ],
    );

    switch (buttonType) {
      case ButtonType.fill:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: child,
          ),
        );
      case ButtonType.outline:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: backgroundColor, width: 1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          ),
          onPressed: onPressed,
          child: child,
        );
      case ButtonType.disable:
        return IgnorePointer(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
            ),
            onPressed: onPressed,
            child: child,
          ),
        );

      default:
        return TextButton(
          style: TextButton.styleFrom(
            foregroundColor: textColor,
          ),
          onPressed: onPressed,
          child: child,
        );
    }
  }
}
