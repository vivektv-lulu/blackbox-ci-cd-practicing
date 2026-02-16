import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../controllers/login_controller.dart';
import '../widgets/login_form.dart';

/// Login screen view - the main UI for the login page.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.login),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo or icon
                  Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),

                  // Welcome text
                  Text(
                    AppStrings.welcomeBack,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.pleaseLogin,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 40),

                  // Login form
                  Consumer<LoginController>(
                    builder: (context, controller, child) {
                      return LoginForm(
                        onEmailChanged: controller.setEmail,
                        onPasswordChanged: controller.setPassword,
                        onLoginPressed: () async {
                          final success = await controller.login();
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(AppStrings.loginSuccessful),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Navigate to home or dashboard here
                          }
                        },
                        isLoading: controller.isLoading,
                        errorMessage: controller.errorMessage,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
