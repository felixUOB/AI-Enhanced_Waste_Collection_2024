import 'package:flutter/material.dart';

import 'package:ewc/main.dart';
import 'package:ewc/screens/login/forgot_password.dart';
import 'package:ewc/screens/login/login.dart';
import 'package:ewc/services/auth_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
      MaterialPageRoute(builder: (context) => LoginPage(authService: authService,)),
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
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(milliseconds: 500), () async {
                            final Uri url =
                            Uri.parse("https://forms.office.com/Pages/ResponsePage.aspx?id=MH_ksn3NTkql2rGM8aQVG46lEh417JBEtdhuAjVqOHxUNlRDNjZNVk9OUFVFRUlQT0szVDFKR1VNNi4u");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                              Navigator.pop(context); // Close dialog after redirect
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                    Text("Feedback form currently not working")),
                              );
                            }
                          });
                          return AlertDialog(
                            title: Text("Redirecting..."),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(), // Loading indicator
                                SizedBox(height: 10),
                                Text("Redirecting to feedback form..."),
                              ],
                            ),
                          );
                        });
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
                    Share.share(
                      "Check out this awesome app: https://play.google.com/store/apps/details?id=com.example.app",
                      subject: "Try this amazing app!",
                      // TODO app link to be added when deployed in iOS store or app store...
                    );
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