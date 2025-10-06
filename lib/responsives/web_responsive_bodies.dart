import 'package:flutter/material.dart';

import '../pages/landscape/page_decider.dart' as landscape;
import '../pages/medium/page_decider.dart' as medium;
import '../pages/portrait/page_decider.dart' as portrait;

class WebMediumBody extends StatefulWidget {
  const WebMediumBody({super.key});

  @override
  State<WebMediumBody> createState() => _WebMediumBodyState();
}

class _WebMediumBodyState extends State<WebMediumBody> {
  @override
  Widget build(BuildContext context) {
    return const medium.PageDecider();
  }
}

class WebLandscapeBody extends StatefulWidget {
  const WebLandscapeBody({super.key});

  @override
  State<WebLandscapeBody> createState() => _WebLandscapeBodyState();
}

class _WebLandscapeBodyState extends State<WebLandscapeBody> {
  @override
  Widget build(BuildContext context) {
    return const landscape.PageDecider();
  }
}

class WebPortraitBody extends StatefulWidget {
  const WebPortraitBody({super.key});

  @override
  State<WebPortraitBody> createState() => _WebPortraitBodyState();
}

class _WebPortraitBodyState extends State<WebPortraitBody> {
  @override
  Widget build(BuildContext context) {
    return const portrait.PageDecider();
  }
}
