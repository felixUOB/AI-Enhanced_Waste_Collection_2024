import 'package:ewc/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:ewc/main.dart';
import 'package:ewc/screens/login/login.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';

/// This file manages the settings page and displays various user settings.
///
/// Functions:
/// - `build()`: Builds the UI for the settings page.
/// - `_logout()`: Logs the user out of the app.
/// - `_buildSettingsItem()`: Helper method to build each settings item.

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late Box box;
  TextEditingController mpgController = TextEditingController();

  //initialise hive box
  void _initializeBox() async {
    box = await Hive.openBox("Settings"); // Ensure it's opened once
    _updateMPGValue(); // Load initial value

    if (!mounted) return;
    // Listen for changes and update UI
    box.watch(key: 'mpg').listen((event) {
      _updateMPGValue();
    });
  }

  void _updateMPGValue() {
    double? mpg = box.get('mpg');
    if (mpg != null) {
      setState(() {
        mpgController.text = mpg.toString();
      });
    }
  }

  // initialise settings
  @override
  void initState() {
    super.initState();
    _initializeBox();
  }

  //Helper for saving mpg
  void _inputMPG() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        String? errorText; // ✅ Error state inside the builder
        TextEditingController mpgController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            void validateMPG() {
              setState(() {
                String input = mpgController.text.trim();
                if (input.isEmpty) {
                  errorText = "MPG cannot be empty!";
                } else {
                  double? mpgValue = double.tryParse(input);
                  if (mpgValue == null || mpgValue <= 0) {
                    errorText = "MPG must be a positive number!";
                  } else {
                    errorText = null; // ✅ No errors, clear message
                  }
                }
              });
            }

            return AlertDialog(
              title: Text("Enter your vehicle's Miles per Gallon"),
              content: TextField(
                controller: mpgController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Miles per Gallon",
                  errorText: errorText, // ✅ Updates dynamically
                ),
                onChanged: (value) => validateMPG(), // ✅ Live validation
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    validateMPG(); // ✅ Final validation before closing
                    if (errorText != null) return; // ❌ Prevents closing if invalid

                    double mpgValue = double.parse(mpgController.text);
                    await box.put('mpg', mpgValue); // ✅ Store the value

                    if (!dialogContext.mounted) return;
                    Navigator.pop(dialogContext); // ✅ Close dialog
                  },
                  child: Text('Save'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }


  //Helper for logout
  Future<void> _logout() async {
    await getIt<AuthService>().clearCredentials();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  //Helper for feedback form, contact us and privacy policy
  void _launchUrlFromInput(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $url";
    }
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
        body: ListView(children: [
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
        onTap: () => _launchUrlFromInput(
            "https://forms.office.com/Pages/ResponsePage.aspx?id=MH_ksn3NTkql2rGM8aQVG46lEh417JBEtdhuAjVqOHxUNlRDNjZNVk9OUFVFRUlQT0szVDFKR1VNNi4u"),
      ),

      // 3) Privacy Policy
      _buildSettingsItem(
        icon: Icons.privacy_tip_outlined,
        iconColor: Colors.yellow,
        title: "Privacy Policy",
        // TODO app link to be added when deployed in iOS store or app store...
        onTap: () => _launchUrlFromInput("https://recyclenxt.com/"),
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
          );
        },
      ),

      // 5) Contact us
      _buildSettingsItem(
        icon: Icons.help,
        iconColor: Colors.blue,
        title: "Contact us",
        subtitle: "Contact if you need help",
        onTap: () => _launchUrlFromInput(
            "https://forms.office.com/Pages/ResponsePage.aspx?id=MH_ksn3NTkql2rGM8aQVG46lEh417JBEtdhuAjVqOHxURDgzSVVSRUZZTjhaMU5YMU05RllDRFNITi4u"),
      ),

      // 6) Alter MPG
      _buildSettingsItem(
          icon: Icons.local_gas_station,
          iconColor: Colors.deepOrange,
          title: "Miles Per Gallon",
          subtitle: "Current : ${mpgController.text}, Miles Per Gallon",
          onTap: () {
            _inputMPG();
          }),

      // 7) Reset Password
      _buildSettingsItem(
        icon: Icons.lock_reset,
        iconColor: Colors.deepOrange,
        title: "Reset Password",
        onTap: () {
          getIt<AuthService>().launchPasswordReset();
        },
      ),

      // 8) Logout
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
    ]));
  }
}
