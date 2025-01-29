import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vbt_app/firebase_options.dart';
import 'package:vbt_app/screens/main/main_screen.dart';
import 'package:vbt_app/screens/signing/singing_screen.dart';
import 'package:vbt_app/services/user/user_providers.dart';
import 'package:vbt_app/theme.dart';

void main() async {
  FlutterBluePlus.setLogLevel(LogLevel.error);
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    const ProviderScope(
      child: App(),
    )
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  bool maybe(AsyncValue<bool> value) {
    return value.maybeWhen(data: (v) => v, orElse: () => false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<bool> isSignedIn = ref.watch(isSignedInProvider);

    return MaterialApp(
      theme: primaryTheme,
      home: isSignedIn.when(
        data: (isSignedIn) {
          return isSignedIn ? const MainScreen() : const SigningScreen();
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stack) => const Scaffold(body: Center(child: Text("Error occurred")))
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
