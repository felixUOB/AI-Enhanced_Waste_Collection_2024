import 'package:flutter/material.dart';

import '../../widgets/theme_switch.dart';
import '../login/login.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top App Bar
      appBar: AppBar(
        title: Text(
          'Settings Page',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ThemeSwitch(),
            ),
          ),
        ],
      ),
      // Body content
      body: ListView(
        children: [
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


                )
            ),
          ),
        ],

      ),
    );

  }
}