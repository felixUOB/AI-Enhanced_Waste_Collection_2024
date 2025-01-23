import 'package:flutter/material.dart';

import '../../main.dart';
import '../login/login.dart';
import '../../services/auth_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final AuthService authService =AuthService();
  Future<void> _logout() async {
    // Call clearCredentials to clear stored credentials
    await authService.clearCredentials();

    if (!mounted) return; // needed to allow BuildContext inn Async
    // Navigate to LoginPage, removing all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
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
        // actions: [
        //   SafeArea(
        //     child: Padding(
        //       padding: const EdgeInsets.only(right: 8.0),
        //       child: ThemeSwitch(),
        //     ),
        //   ),
        // ],
      ),
      // Body content
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)
              ),
              child: ListTile(
                leading: Icon(Icons.dark_mode_outlined, color: Colors.green),
                title: const Text("Change Theme"),
                subtitle: const Text("Switch to Dark/Light Mode"),
                trailing: Switch(
                  value: themeManager.themeMode == ThemeMode.dark,
                  onChanged: (onChanged) {
                    themeManager.toggleTheme(onChanged);
                  },
                ),
                // onTap: _openFeedbackPage,
              ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(Icons.feedback, color: Colors.blue),
                title: const Text("Feedback"),
                subtitle: const Text("Share your feedback with us"),
                trailing: Icon(Icons.arrow_forward_ios),
                // onTap: _openFeedbackPage,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(Icons.privacy_tip_outlined, color: Colors.yellow),
                title: const Text("Privacy Policy"),
                trailing: Icon(Icons.arrow_forward_ios),
                // onTap: _openFeedbackPage,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(Icons.share, color: Colors.green),
                title: const Text("Share app"),
                subtitle: const Text("Share this app with your friends"),
                trailing: Icon(Icons.arrow_forward_ios),
                // onTap: _openFeedbackPage,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(Icons.help, color: Colors.blue),
                title: const Text("Contact us"),
                subtitle: const Text("Contact if you need help"),
                trailing: Icon(Icons.arrow_forward_ios),
                // onTap: _openFeedbackPage,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)
                ),
                child : ListTile(
                  leading: Icon(Icons.logout, color: Colors.red, ),
                  title: const Text("Logout"),
                  subtitle: const Text("Sign out of your account"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap : () async {
                    bool confirmLogout = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Are sure you want to logout?"),
                          actions: [
                            TextButton(
                                onPressed: () =>Navigator.pop(context,false),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor : Colors.red,
                                  textStyle: const TextStyle(fontSize: 16),
                                ),
                                child: Text("No")
                            ),
                            TextButton(
                                onPressed: () =>Navigator.pop(context,true),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green, // Button text color
                                  textStyle: const TextStyle(fontSize: 16),// ,
                                ),

                                child: Text("Yes"))
                          ],
                        )
                    );
                    if (confirmLogout == true){
                      await _logout();
                    }

                  },


                )
            ),
          ),
        ],

      ),
    );


  }
}