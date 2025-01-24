import 'package:flutter/material.dart';

import '../../main.dart';
import '../login/forgot_password.dart';
import '../login/login.dart';
import '../../services/auth_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final AuthService authService = AuthService();

  Future<void> _logout() async {
    await authService.clearCredentials();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
    );
  }

    /// Helper method to build each settings item to avoid repeating 
    /// Padding → Card → ListTile. (pass the icon, color, title, etc.)

    Widget _buildSettingsItem({
      required IconData icon,
      required Color iconColor,
      required String title,
      String? subtitle,
      Widget? trailing,
      VoidCallback? onTap,
    }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: trailing ?? const Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
      ),
    );
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              'Settings Page',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: ListView(
              children: [
                // 1) Change Theme item
                _buildSettingsItem(
                  icon: Icons.dark_mode_outlined,
                  iconColor: Colors.green,
                  title: "Change Theme",
                  subtitle: "Switch to Dark/Light Mode",
                  trailing: Switch(
                    value: themeManager.themeMode == ThemeMode.dark,
                    onChanged: (onChanged) {
                      themeManager.toggleTheme(onChanged);
                    },
                  ),
                ),

                // 2) Feedback
                _buildSettingsItem(
                  icon: Icons.feedback,
                  iconColor: Colors.blue,
                  title: "Feedback",
                  subtitle: "Share your feedback with us",
                  onTap: () {
                    // TODO: Implement feedback page navigation
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Feedback"),
                        content: Text("This feature is under construction."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"),
                          )
                        ],
                      ),
                    );
                  },
                ),

                // 3) Privacy Policy
                _buildSettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  iconColor: Colors.yellow,
                  title: "Privacy Policy",
                  onTap: () {
                    // TODO: Implement privacy policy page
                  },
                ),

                // 4) Share app
                _buildSettingsItem(
                  icon: Icons.share,
                  iconColor: Colors.green,
                  title: "Share app",
                  subtitle: "Share this app with your friends",
                  onTap: () {
                    // TODO: Implement share logic
                  },
                ),

                // 5) Contact us
                _buildSettingsItem(
                  icon: Icons.help,
                  iconColor: Colors.blue,
                  title: "Contact us",
                  subtitle: "Contact if you need help",
                  onTap: () {
                    // TODO: Implement contact
                  },
                ),

                // 6) Reset Password
                _buildSettingsItem(
                  icon: Icons.lock_reset,
                  iconColor: Colors.deepOrange,
                  title: "Reset Password",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPassword()),
                    );
                  },
                ),

                // 7) Logout
                _buildSettingsItem(
                  icon: Icons.logout,
                  iconColor: Colors.red,
                  title: "Logout",
                  subtitle: "Sign out of your account",
                  onTap: () async {
                    bool confirmLogout = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: Text("No"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: Text("Yes"),
                          ),
                        ],
                      ),
                    );
                    if (confirmLogout == true) {
                      await _logout();
                    }
                  },
                ),
              ],
            ),
      );
}
}