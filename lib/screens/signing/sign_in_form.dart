import 'package:flutter/material.dart';
import 'package:vbt_app/services/user/user_service.dart';
import 'package:vbt_app/screens/shared/styled_button.dart';
import 'package:vbt_app/screens/shared/styled_text.dart';
import 'package:vbt_app/theme.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // intro text
              const Center(child: MediumText("Sign in to your account.")),
              const SizedBox(height: 16),

              // email address
              TextFormField(
                  style: const TextStyle(color: AppColors.textColor),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: AppColors.textColor,
                  decoration: const InputDecoration(labelText: "Email")),
              const SizedBox(height: 16),

              // password
              TextFormField(
                  style: const TextStyle(color: AppColors.textColor),
                  controller: _passwordController,
                  obscureText: true,
                  cursorColor: AppColors.textColor,
                  decoration: const InputDecoration(labelText: "Password")),
              const SizedBox(height: 16),

              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),

              // submit button
              StyledButton(
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    try {
                      await UserService.signIn(email, password);

                      setState(() {
                        _errorMessage = null;
                      });
                    } on SignUpOrSignInException catch (exception) {
                      setState(() {
                        _errorMessage = exception.message;
                      });
                    }
                  },
                  text: "Sign in")
            ],
          )),
    );
  }
}
