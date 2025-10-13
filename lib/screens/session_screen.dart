import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_svg/svg.dart';
import 'package:playground/config/constant.dart' show kVPadding;

class SessionScreen extends StatefulWidget {
  final String sessionUuid;
  const SessionScreen({super.key, required this.sessionUuid});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.7,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Theme.of(context).brightness != Brightness.dark ? Brightness.dark : Brightness.light,
        ),
        toolbarHeight: kToolbarHeight + kVPadding,
        backgroundColor: Theme.of(context).cardColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).cardColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          highlightColor: Theme.of(context).highlightColor,
          hoverColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
          splashColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).primaryIconTheme.color,
            size: 20,
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/images/playground_logo.svg',
              width: 28,
              height: 28,
              semanticsLabel: 'LLM Playground logo',
            ),
            const SizedBox(width: 12),
            Text(
              'LLM Playground',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
