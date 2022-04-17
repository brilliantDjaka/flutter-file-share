import 'package:adwaita/adwaita.dart';
import 'package:file_share/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          theme: AdwaitaThemeData.light(),
          darkTheme: AdwaitaThemeData.dark(),
          debugShowCheckedModeBanner: false,
          home: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const Home(),
          ),
          themeMode: currentMode,
        );
      },
    );
  }
}
