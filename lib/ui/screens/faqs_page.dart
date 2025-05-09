import 'package:flutter/material.dart';
import 'package:plants_app/constants/constants.dart';

class FAQsPage extends StatelessWidget {
  const FAQsPage({super.key});

  final List<Map<String, String>> faqs = const [
    {
      'question': 'Bagaimana cara mengubah nama profil saya?',
      'answer': 'Masuk ke halaman My Profile dan ubah nama di form yang tersedia lalu tekan Simpan Perubahan.',
    },
    {
      'question': 'Bagaimana cara mengganti bahasa aplikasi?',
      'answer': 'Masuk ke halaman Settings, lalu pilih Language dan pilih bahasa yang Anda inginkan.',
    },
    {
      'question': 'Apakah data saya aman di aplikasi ini?',
      'answer': 'Ya, semua data pengguna dilindungi dan hanya digunakan untuk keperluan aplikasi.',
    },
    {
      'question': 'Bagaimana cara menghubungi tim dukungan?',
      'answer': 'Anda dapat menghubungi kami melalui fitur Feedback di halaman Settings.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
        // backgroundColor: Constants.primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                title: Text(
                  faq['question']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Constants.blackColor,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Text(
                      faq['answer']!,
                      style: TextStyle(color: Constants.blackColor.withOpacity(0.7)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
