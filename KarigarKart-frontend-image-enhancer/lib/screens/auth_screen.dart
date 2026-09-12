import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool signUp = false;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  Container(
                    height: 76,
                    width: 76,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.clay,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(Icons.handyman_outlined,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 22),
                  const Text('KarigarKart',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 31,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink)),
                  const SizedBox(height: 8),
                  Text(
                      signUp
                          ? 'Start selling your craft with confidence.'
                          : 'A marketplace made for India’s makers.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColors.muted, fontSize: 16)),
                  const SizedBox(height: 36),
                  if (signUp)
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Your name',
                          prefixIcon: Icon(Icons.person_outline)),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Enter your name'
                          : null,
                    ),
                  if (signUp) const SizedBox(height: 14),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Phone or email',
                        prefixIcon: Icon(Icons.alternate_email)),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter your phone or email'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline)),
                    validator: (v) => (v == null || v.length < 4)
                        ? 'Use at least 4 characters'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        AppScope.of(context).login();
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    child: Text(signUp
                        ? 'Create seller account'
                        : 'Login to your shop'),
                  ),
                  TextButton(
                    onPressed: () => setState(() => signUp = !signUp),
                    child: Text(signUp
                        ? 'Already have an account? Login'
                        : 'New artisan? Create an account'),
                  ),
                  const SizedBox(height: 12),
                  const Text('Demo mode: any valid details will sign you in.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
