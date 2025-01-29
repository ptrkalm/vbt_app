import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vbt_app/screens/signing/sign_in_form.dart';
import 'package:vbt_app/screens/signing/sign_up_form.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';

class SigningScreen extends ConsumerStatefulWidget {
  const SigningScreen({super.key});

  @override
  ConsumerState<SigningScreen> createState() => _SigningScreenState();
}

class _SigningScreenState extends ConsumerState<SigningScreen> {
  bool isSignInForm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const MediumTitle('Welcome to VBT System'),
        ),
        body: SingleChildScrollView(
          child: Container(
              child: switch (isSignInForm) {
                true => Column(
                  children: [
                    const SignInForm(),
                    const MediumText("Need an account?"),
                    TextButton(onPressed: () {
                      setState(() {
                        isSignInForm = false;
                      });
                    }, child: const MediumText("Sign up here.", isUnderlined: true))
                  ],
                ),
                false => Column(
                  children: [
                    const SignUpForm(),
                    const MediumText("Already have an account?"),
                    TextButton(onPressed: () {
                      setState(() {
                        isSignInForm = true;
                      });
                    }, child: const MediumText("Sign in here.", isUnderlined: true))
                  ],
                )
              }
          ),
        ));
  }
}
