import 'package:flutter/material.dart';
import 'package:swf_app/src/catalog/presentation/catalog_page.dart';
import 'package:swf_app/src/theme/app_theme.dart';

class SwfApp extends StatelessWidget {
  const SwfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StuffWithFantasy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const CatalogPage(),
    );
  }
}
