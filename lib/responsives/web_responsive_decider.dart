import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../config/variable.dart';
import '../pages/pages/home_page.dart';
import 'web_responsive_bodies.dart';

class WebResponsiveDecider extends StatefulWidget {
  const WebResponsiveDecider({super.key});

  @override
  State<WebResponsiveDecider> createState() => _WebResponsiveDeciderState();
}

class _WebResponsiveDeciderState extends State<WebResponsiveDecider> {
  @override
  void initState() {
    super.initState();
    _onRefresh(context);
  }

  void _onRefresh(BuildContext context) {
    displayScaleFactor = 1.1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) _onRefresh(context);
  }

  @override
  Widget build(BuildContext context) {
    displayScaleFactor = 1.1;
    if (MediaQuery.of(context).size.width < 256) {
      return Scaffold(
        body: Stack(
          children: [
            const SizedBox(width: double.infinity, height: double.infinity),
            Positioned(
              left: MediaQuery.of(context).size.width / 4,
              top: MediaQuery.of(context).size.height / 4,
              child: Container(
                width: MediaQuery.of(context).size.height / 5,
                height: MediaQuery.of(context).size.height / 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor,
                      blurRadius: 200,
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Text(
                AppLocalizations.of(context)!.wrongScreenSizeLabel,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }
    try {
      return const _ResponsiveLayout(
        mediumBody: WebMediumBody(),
        landscapeBody: WebLandscapeBody(),
        portraitBody: WebPortraitBody(),
      );
    } catch (e) {
      return FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 250)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold();
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.priority_high_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.navigationErrorLabel,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.navigationErrorDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      );
    }
  }
}

class _ResponsiveLayout extends StatelessWidget {
  final Widget portraitBody;
  final Widget landscapeBody;
  final Widget mediumBody;

  const _ResponsiveLayout({
    required this.portraitBody,
    required this.landscapeBody,
    required this.mediumBody,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    if (screenWidth >= 1200) {
      return mediumBody;
    } else if (isLandscape) {
      return landscapeBody;
    } else {
      return portraitBody;
    }
  }
}

// Page builder helper
Page<void> _p(GoRouterState s) {
  return MaterialPage<void>(
    key: s.pageKey,
    child: HomePage(key: s.pageKey),
  );
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => Container(
        color: Colors.black, // Theme background
        child: child,
      ),
      routes: [
        GoRoute(path: '/', pageBuilder: (_, s) => _p(s)),
        GoRoute(path: '/features', pageBuilder: (_, s) => _p(s)),
        GoRoute(path: '/enterprise', pageBuilder: (_, s) => _p(s)),
        GoRoute(path: '/pricing', pageBuilder: (_, s) => _p(s)),
        GoRoute(path: '/about_us', pageBuilder: (_, s) => _p(s)),
        GoRoute(path: '/products', pageBuilder: (_, s) => _p(s)),
        GoRoute(path: '/services', pageBuilder: (_, s) => _p(s)),
        GoRoute(path: '/team', pageBuilder: (_, s) => _p(s)),
        GoRoute(path: '/investor', pageBuilder: (_, s) => _p(s)),
        GoRoute(path: '/downloads', pageBuilder: (_, s) => _p(s)),
        GoRoute(path: '/playground', pageBuilder: (_, s) => _p(s)),
        GoRoute(path: '/platform', pageBuilder: (_, s) => _p(s)),
        GoRoute(path: '/privacy_policy', pageBuilder: (_, s) => _p(s)),
        GoRoute(path: '/terms_and_conditions', pageBuilder: (_, s) => _p(s)),
        GoRoute(path: '/contact_us', pageBuilder: (_, s) => _p(s)),
      ],
    ),

    // Playground routes
    ShellRoute(
      builder: (context, state, child) => Container(
        color: Colors.black, // Theme background
        child: child,
      ),
      routes: [
        GoRoute(path: '/playground', builder: (_, __) => Container()), // ServiceListPage()),
        GoRoute(path: '/playground/myna', builder: (_, __) => Container()), // MynaPlayground()),
        GoRoute(path: '/playground/tts', builder: (_, __) => Container()), // TTSPlayground()),
        GoRoute(path: '/playground/stt', builder: (_, __) => Container()), // STTPlayground()),
      ],
    ),

    GoRoute(path: '/:rest(.*)', pageBuilder: (_, s) => _p(s)),
  ],
);
