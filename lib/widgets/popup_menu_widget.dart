import 'package:flutter/material.dart';
import 'package:playground/core/themes/styles.dart';

class PopupMenuWidget extends StatelessWidget {
  final Widget child;
  final Offset offset;
  final double? width;
  final int? initValue;
  final EdgeInsetsGeometry? margin;
  final PopupMenuItemSelected? onSelected;
  final List<Widget> items;
  const PopupMenuWidget({
    super.key,
    required this.child,
    required this.offset,
    this.onSelected,
    required this.items,
    this.width = 250,
    this.initValue,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      constraints: const BoxConstraints(
        maxWidth: 450,
        minWidth: 250,
      ),
      itemBuilder: (context) {
        return List.generate(
          items.length,
          (index) {
            final isSelected = index == initValue;
            return PopupMenuItem(
              height: 35,
              padding: EdgeInsets.zero,
              value: index,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                margin: margin,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withOpacity(0.1) : null,
                  borderRadius: isSelected ? BorderRadius.circular(12) : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: items[index],
                    ),
                    (isSelected)
                        ? const Icon(
                            Icons.check,
                            size: 12,
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            );
          },
        );
      },
      offset: offset,
      color: AppColors.surface,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      elevation: 1,
      onSelected: onSelected,
      // initialValue: initValue,
      tooltip: '',
      clipBehavior: Clip.none,
      child: child,
    );
  }
}
