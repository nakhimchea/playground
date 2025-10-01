import 'package:flutter/material.dart';
import 'package:wingai/core/themes/styles.dart';

class SuggestedList extends StatefulWidget {
  final List<String> items;
  final Function(String) onTextSelected;
  const SuggestedList({
    super.key,
    required this.items,
    required this.onTextSelected,
  });

  @override
  State<SuggestedList> createState() => _SuggestedListState();
}

class _SuggestedListState extends State<SuggestedList> {
  final List<bool> _visibleFlags = [];

  @override
  void initState() {
    super.initState();
    _visibleFlags.addAll(List.filled(widget.items.length, false));
    _triggerAnimations();
  }

  void _triggerAnimations() {
    for (int i = 0; i < widget.items.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        setState(() => _visibleFlags[i] = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.items.length, (index) {
          final item = widget.items[index];
          final visible = _visibleFlags[index];

          return AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: Transform.translate(
              offset: visible ? Offset.zero : const Offset(0, 20),
              child: TextButton(
                onPressed: () => widget.onTextSelected(item),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item,
                          style: Theme.of(context).textTheme.labelMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Prompt",
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(color: AppColors.lightGreyIconColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
