import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/exceptions/auth_exception.dart';
import 'package:pocket_vault/providers/auth_provider.dart';
import 'package:pocket_vault/services/auth_service.dart';
import 'package:pocket_vault/utils/app_alerts.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final AuthService authService = AuthService();

  Future<void> _canAuthenticate() async {
    try {
      await authService.authenticate();

      _autheticated();
    } on AuthException catch (e) {
      if (!mounted) return;
      switch (e) {
        case AuthCancelledException():
          return;
        case AuthFailedException():
        case AuthUnavailableException():
          AppAlerts.error(context, e.message);
      }
    }
  }

  Future<void> _checkAutoAuthenticate() async {
    final isAuthenticated = ref.read(authStateProvider);

    if (isAuthenticated) {
      _autheticated();
      return;
    }

    final canAuthenticate = await authService.checkBiometrics();

    if (!canAuthenticate) {
      _autheticated();
    } else {
      if (!mounted) return;
      _canAuthenticate();
    }
  }

  void _autheticated() {
    if (!mounted) return;
    ref.read(authStateProvider.notifier).setAuthenticated(true);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAutoAuthenticate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.shieldCheck, size: 80),
                      const SizedBox(height: 16),
                      Text(
                        'PocketVault',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Text('Soberania Financeira'),
                    ],
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: _canAuthenticate,
                  icon: const Icon(LucideIcons.fingerprintPattern),
                  label: const Text('Desbloquear aplicativo'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
