import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  final bool _isLoading = false;

  void _handleSocialLogin(String provider) {
    // Handle social login
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Sign In - Debug Version
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : () => _handleSocialLogin('Google'),
            icon: Container(
              width: 20,
              height: 20,
              child: Image.asset(
                'assets/icons/google_icon.png',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  print('❌ Google icon failed to load: $error');
                  print('📁 Looking for: assets/icons/google_icon.png');
                  return Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.shade100,
                      border: Border.all(color: Colors.red),
                    ),
                    child: Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            label: Text(
              'Continue with Google',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
