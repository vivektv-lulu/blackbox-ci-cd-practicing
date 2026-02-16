import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

/// Reusable login form widget containing email and password fields.
class LoginForm extends StatefulWidget {
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final VoidCallback onLoginPressed;
  final bool isLoading;
  final String? errorMessage;

  const LoginForm({
    super.key,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onLoginPressed,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: AppStrings.email,
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            onChanged: widget.onEmailChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.pleaseEnterEmail;
              }
              if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                  .hasMatch(value)) {
                return AppStrings.pleaseEnterValidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: AppStrings.password,
              prefixIcon: const Icon(Icons.lock_outlined),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            onChanged: widget.onPasswordChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.pleaseEnterPassword;
              }
              if (value.length < 6) {
                return AppStrings.passwordMinLength;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Error message
          if (widget.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                widget.errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Login button
          ElevatedButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      widget.onLoginPressed();
                    }
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(AppStrings.loginButton),
          ),
        ],
      ),
    );
  }
}
