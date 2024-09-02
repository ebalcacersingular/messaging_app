import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messaging_app/providers/auth_provider.dart';
import 'package:messaging_app/utils/biometric_auth.dart';
import 'package:messaging_app/utils/secure_storage.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final BiometricAuth _biometricAuth = BiometricAuth();
  final SecureStorage _secureStorage = SecureStorage();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return; // If the form is invalid, return early.
    }

    setState(() {
      _isLoading = true;
    });

    final authNotifier = ref.read(authProvider.notifier);

    try {
      await authNotifier.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      final authState = ref.watch(authProvider);
      if (authState.isAuthenticated) {
        if (authState.isAuthenticated) {
          await _secureStorage.storeUserCredentials(
            _emailController.text,
            _passwordController.text,
          );
        }

        Navigator.of(context).pushReplacementNamed('/chats');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
      }
    } catch (e) {
      // Handle login error
      if (kDebugMode) {
        print('Login error: $e');
      } // Log the error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loginBiometric() async {
    final authNotifier = ref.read(authProvider.notifier);
    final authState = ref.watch(authProvider);

    bool canCheckBiometrics = await _biometricAuth.checkBiometrics();
    if (canCheckBiometrics) {
      bool authenticated = await _biometricAuth.authenticateWithBiometrics();
      if (authenticated) {
        final credentials = await _secureStorage.getUserCredentials();
        if (credentials['email'] != null && credentials['password'] != null) {
          await authNotifier.login(
            credentials['email']!,
            credentials['password']!,
          );
          if (authState.isAuthenticated) {
            Navigator.pushReplacementNamed(context, '/chats');
          } else {
            if (kDebugMode) {
              print("Failed to authenticate with stored credentials");
            }
          }
        } else {
          if (kDebugMode) {
            print("No stored credentials found");
          }
        }
      } else {
        if (kDebugMode) {
          print("Failed to authenticate with biometrics");
        }
      }
    } else {
      if (kDebugMode) {
        print("Biometric authentication is not available");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      '/register'); // Navigate to the register screen
                },
                child: const Text('Don\'t have an account? Register here'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.fingerprint),
                label: const Text('Login with Biometrics'),
                onPressed: _loginBiometric,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
