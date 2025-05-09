import 'package:flutter/material.dart';
import 'package:plants_app/constants/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        // backgroundColor: Constants.primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          const _SectionTitle(title: "General"),
          _SettingsTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Switch between light and dark themes',
            onTap: () {
              // TODO: Handle theme switch
            },
          ),
          _SettingsTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'Choose your preferred language',
            onTap: () {
              // TODO: Navigate to language settings
            },
          ),
          const Divider(),
          const _SectionTitle(title: "Support"),
          _SettingsTile(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy terms',
            onTap: () {
              // TODO: Show privacy policy
            },
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'About App',
            subtitle: 'Version 1.0.0',
            onTap: () {
              // TODO: Show about info
            },
          ),
          _SettingsTile(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            subtitle: 'Let us know what you think',
            onTap: () {
              // TODO: Open feedback form
            },
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Constants.blackColor.withOpacity(0.6),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Constants.primaryColor.withOpacity(0.1),
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
