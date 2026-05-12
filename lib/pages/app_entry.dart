import 'package:flutter/material.dart';

import '../provider/auth_provider.dart';
import 'welcome_page.dart';
import 'shell_page.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);

    return AnimatedBuilder(
      animation: auth,
      builder: (_, __) {
        if (auth.currentUser == null) {
          return const WelcomePage();
        }
        return const ShellPage();
      },
    );
  }
}
