import 'package:flutter/material.dart';
import 'package:plants_app/constants/constants.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  final List<Map<String, String>> notifications = const [
    {
      'title': 'Promo Spesial!',
      'message': 'Dapatkan diskon 20% untuk semua tanaman hari ini.'
    },
    {
      'title': 'Perawatan Tanaman',
      'message': 'Ingat untuk menyiram tanaman Monstera Anda hari ini.'
    },
    {
      'title': 'Profil Diperbarui',
      'message': 'Nama profil Anda berhasil diperbarui.'
    },
    {
      'title': 'Fitur Baru!',
      'message': 'Cek fitur baru kami di halaman Settings sekarang.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        // backgroundColor: Constants.primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.notifications, color: Constants.blackColor),
              title: Text(
                notif['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(notif['message']!),
            ),
          );
        },
      ),
    );
  }
}
