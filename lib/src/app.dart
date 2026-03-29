import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/catalog/presentation/catalog_page.dart';
import 'package:swf_app/src/theme/app_theme.dart';

class SwfApp extends StatelessWidget {
  const SwfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ServiceLocator.localeProvider,
      builder: (context, _) {
        return MaterialApp(
          title: 'StuffWithFantasy',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          themeMode: ThemeMode.light,
          locale: ServiceLocator.localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CatalogPage(),
        );
      },
    );
  }
}
