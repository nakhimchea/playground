import 'package:flutter/material.dart';

class CustomExpandable extends StatefulWidget {
  final Widget Function(bool expanded, VoidCallback toggle) headerBuilder;
  final Widget body;

  const CustomExpandable({
    super.key,
    required this.headerBuilder,
    required this.body,
  });

  @override
  State<CustomExpandable> createState() => _CustomExpandableState();
}

class _CustomExpandableState extends State<CustomExpandable> {
  bool _expanded = true;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.headerBuilder(_expanded, _toggle),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: widget.body,
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
