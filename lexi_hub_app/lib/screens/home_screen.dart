import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a Consumer to react to changes in AuthProvider
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return authProvider.isLoggedIn
            ? _buildLoggedInView(context, authProvider)
            : const LoginScreen();
      },
    );
  }

  Widget _buildLoggedInView(BuildContext context, AuthProvider authProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('환영합니다! 당신의 단어장과 장문 목록입니다.', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Call the logout method from the provider
              authProvider.logout();
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
}