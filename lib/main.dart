import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vbt_app/services/bluetooth_store/bluetooth_store.dart';
import 'package:vbt_app/theme.dart';

import 'screens/home/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BluetoothStore(),
      child: const App(),
    )
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: primaryTheme,
      home: const HomeScreen()
    );
  }
}
