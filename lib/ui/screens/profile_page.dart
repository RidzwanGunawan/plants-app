import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plants_app/constants/constants.dart';
import 'package:plants_app/ui/screens/faqs_page.dart';
import 'package:plants_app/ui/screens/my_profile_page.dart';
import 'package:plants_app/ui/screens/notification_page.dart';
import 'package:plants_app/ui/screens/setting_page.dart';
import 'package:plants_app/ui/screens/signin_page.dart';
import 'package:plants_app/ui/screens/widgets/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<User?> _loadUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
 
    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: FutureBuilder<User?>(
        future: _loadUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;
          String displayName = user?.displayName ?? 'Nama Pengguna Belum Diatur';
          // String email = user?.email ?? 'Email tidak tersedia';

          String rawBio = user?.photoURL ?? 'Belum ada bio';
          String bio = Uri.decodeComponent(rawBio); 

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar Profile
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Constants.primaryColor.withOpacity(.5),
                        width: 5.0,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundImage: ExactAssetImage('assets/images/profile.jpg'),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Display Name & Verified Icon
                  SizedBox(
                    width: size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          displayName,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          height: 24,
                          child: Image.asset("assets/images/verified.png"),
                        ),
                      ],
                    ),
                  ),

                  // Email
                  // Text(
                  //   email,
                  //   style: TextStyle(color: Constants.blackColor.withOpacity(.3)),
                  // ),

                  // BIO
                  const SizedBox(height: 8),
                  Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Constants.blackColor.withOpacity(.5),
                      // fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Profile Settings
                  Column(
                    children: [
                      ProfileWidget(
                        icon: Icons.person,
                        title: 'My Profile',
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyProfilePage(),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                      ProfileWidget(
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                      ProfileWidget(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationPage(),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                      ProfileWidget(
                        icon: Icons.chat,
                        title: 'FAQs',
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FAQsPage(),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                      ProfileWidget(
                        icon: Icons.logout,
                        title: 'Log Out',
                        onTap: _logout,
                      ),
                    ],
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
