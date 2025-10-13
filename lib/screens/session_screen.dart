import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

import '../config/constant.dart' show kHPadding, kVPadding;
import '../icons/icons.dart';

class SessionScreen extends StatefulWidget {
  final String sessionUuid;
  const SessionScreen({super.key, required this.sessionUuid});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  bool isExpanded = true;
  bool isHover = false;

  void _toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
      if (!isExpanded) {
        isHover = false;
      }
    });
  }

  void _handleHoverChanged(bool value) {
    if (isHover == value) return;
    setState(() {
      isHover = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: child,
            ),
          );
        },
        child: isExpanded
            ? _Expanded(
                key: const ValueKey('expanded-panel'),
                isExpanded: isExpanded,
                isHover: isHover,
                onHoverChanged: _handleHoverChanged,
                onToggle: _toggleExpanded,
              )
            : _Collapsed(
                key: const ValueKey('collapsed-panel'),
                isExpanded: isExpanded,
                onToggle: _toggleExpanded,
                sessionUuid: widget.sessionUuid,
              ),
      ),
    );
  }
}

class _Expanded extends StatelessWidget {
  const _Expanded({
    super.key,
    required this.isExpanded,
    required this.isHover,
    required this.onHoverChanged,
    required this.onToggle,
  });

  final bool isExpanded;
  final bool isHover;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kHPadding),
      width: 68,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MouseRegion(
            onEnter: (_) => onHoverChanged(true),
            onExit: (_) => onHoverChanged(false),
            child: isHover
                ? IconButton(
                    onPressed: () {
                      onHoverChanged(false);
                      onToggle();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(width: 36, height: 36),
                    icon: Icon(
                      isExpanded ? Icons.arrow_forward_ios_outlined : Icons.arrow_back_ios_outlined,
                      size: 18,
                    ),
                  )
                : SvgPicture.asset(
                    'assets/images/playground_logo.svg',
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 24),
            child: Icon(
              CustomOutlinedIcons.new_icon,
              color: Colors.white70,
            ),
          ),
          Expanded(child: const SizedBox.shrink()),
          const SizedBox(height: 12),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white12,
            child: Text(
              'GU',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuOption<T> {
  final T value;
  final IconData iconData;
  final String label;
  const _MenuOption({required this.value, required this.iconData, required this.label});
}

class _Collapsed extends StatelessWidget {
  const _Collapsed({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.sessionUuid,
  });

  final bool isExpanded;
  final VoidCallback onToggle;
  final String sessionUuid;

  double _measureTextHeight(BuildContext context, String text, TextStyle style) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    return painter.height;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kHPadding),
      width: MediaQuery.of(context).size.width / 5,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/playground_logo.svg',
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Text(
                'LLM Playground',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              IconButton(
                onPressed: onToggle,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 36, height: 36),
                icon: Icon(
                  isExpanded ? Icons.arrow_forward_ios_outlined : Icons.arrow_back_ios_outlined,
                  size: 18,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 24),
            child: Stack(
              children: [
                Row(
                  children: [
                    Icon(
                      CustomOutlinedIcons.new_icon,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'New chat',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
                Positioned.fill(
                  child: MaterialButton(
                    onPressed: () {
                      Future.delayed(const Duration(milliseconds: 150), onToggle);
                    },
                    minWidth: 0,
                    elevation: 0,
                    highlightElevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Chats',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return MaterialButton(
                        onPressed: () {
                          Future.delayed(const Duration(milliseconds: 150), onToggle);
                        },
                        minWidth: 0,
                        elevation: 0,
                        highlightElevation: 0,
                        padding: EdgeInsets.symmetric(vertical: kHPadding),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Colors.transparent,
                        splashColor: Colors.white.withValues(alpha: 0.1),
                        child: Text(
                          "(MODEL_NAME) Some Sample Chat Title $index",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                        ),
                      );
                    },
                    itemCount: 10,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0.2, thickness: 0.2, color: Colors.grey),
          const SizedBox(height: 12),
          Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white12,
                    child: Text(
                      'GU',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Guest User',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                      Text(
                        sessionUuid,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(CustomOutlinedIcons.setting, color: Colors.white70),
                ],
              ),
              Positioned.fill(
                child: Builder(
                  builder: (buttonContext) {
                    return MaterialButton(
                      onPressed: () async {
                        final RenderBox? button = buttonContext.findRenderObject() as RenderBox?;
                        final OverlayState overlayState = Overlay.of(buttonContext);
                        final RenderBox? overlay = overlayState.context.findRenderObject() as RenderBox?;
                        if (button == null || overlay == null) {
                          return;
                        }

                        final double menuWidth = MediaQuery.of(context).size.width / 5 - 2 * kHPadding;
                        final textTheme = Theme.of(buttonContext).textTheme;
                        final TextStyle textStyle = textTheme.bodyLarge!.copyWith(color: Colors.white);
                        final menuOptions = <_MenuOption<String>>[
                          const _MenuOption<String>(
                            value: 'settings',
                            iconData: CustomOutlinedIcons.setting,
                            label: 'Settings',
                          ),
                          const _MenuOption<String>(
                            value: 'log_out',
                            iconData: CustomOutlinedIcons.logout,
                            label: 'Log out',
                          ),
                        ];

                        final List<double> itemHeights = <double>[];
                        double totalItemHeight = 0;
                        for (final option in menuOptions) {
                          final double entryHeight = _measureTextHeight(buttonContext, option.label, textStyle) +
                              (menuOptions.length * kVPadding / 2);
                          itemHeights.add(entryHeight);
                          totalItemHeight += entryHeight;
                        }
                        final double menuHeight = totalItemHeight + kHPadding;

                        final Offset buttonTopLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
                        double left = buttonTopLeft.dx;
                        final double overlayWidth = overlay.size.width;
                        if (left + menuWidth > overlayWidth) {
                          left = overlayWidth - menuWidth;
                        }
                        if (left < 0) {
                          left = 0;
                        }
                        final double top = buttonTopLeft.dy - menuHeight;
                        final double right = overlayWidth - left - menuWidth;
                        final double bottom = overlay.size.height - buttonTopLeft.dy;

                        await showMenu<String>(
                          context: buttonContext,
                          position: RelativeRect.fromLTRB(
                            left,
                            top,
                            right < 0 ? 0 : right,
                            bottom < 0 ? 0 : bottom,
                          ),
                          color: Colors.grey.shade900,
                          constraints: BoxConstraints.tightFor(width: menuWidth),
                          items: List<PopupMenuEntry<String>>.generate(
                            menuOptions.length,
                            (index) => PopupMenuItem<String>(
                              value: menuOptions[index].value,
                              height: itemHeights[index],
                              padding: EdgeInsets.zero,
                              child: SizedBox(
                                width: menuWidth,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Icon(menuOptions[index].iconData, size: 18, color: Colors.white),
                                        const SizedBox(width: 6),
                                        Text(menuOptions[index].label, style: textStyle),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      minWidth: 0,
                      elevation: 0,
                      highlightElevation: 0,
                      padding: EdgeInsets.zero,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
