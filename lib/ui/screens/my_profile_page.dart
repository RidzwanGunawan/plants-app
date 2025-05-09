import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  late User? _user;

  String decodedBio = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _nameController.text = _user?.displayName ?? '';
      final rawBio = _user?.photoURL;
      if (rawBio != null && rawBio.isNotEmpty) {
        try {
          decodedBio = Uri.decodeComponent(rawBio);
          _bioController.text = decodedBio;
        } catch (_) {
          decodedBio = rawBio;
          _bioController.text = rawBio;
        }
      }
      setState(() {}); // Refresh UI setelah load user
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _user?.updateDisplayName(_nameController.text);
        await _user?.updatePhotoURL(Uri.encodeComponent(_bioController.text));
        await _user?.reload();
        _user = FirebaseAuth.instance.currentUser;

        // Update decodedBio untuk tampilan langsung berubah
        decodedBio = _bioController.text;

        Flushbar(
          message: 'Profil berhasil diperbarui!',
          backgroundColor: Colors.green.shade400,
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(10),
          margin: const EdgeInsets.all(12),
          icon: const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 30,
          ),
        ).show(context);

        setState(() {});
      } catch (e) {
        Flushbar(
          message: 'Gagal memperbarui: $e',
          backgroundColor: Colors.red.shade400,
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(10),
          margin: const EdgeInsets.all(12),
          icon: const Icon(
            Icons.error,
            color: Colors.white,
            size: 30,
          ),
        ).show(context);

        print('Error: $e');
      }
    }
  }

  void _deleteBio() {
    setState(() {
      _bioController.clear();
      decodedBio = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: const Center(child: Text('User tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/images/profile.jpg'),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 12),
              Text(
                _user!.displayName ?? 'Nama tidak tersedia',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              decodedBio.isNotEmpty
                  ? Center(
                      child: Text(
                        decodedBio,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Nama Lengkap',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nama',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _user?.email,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Bio',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _bioController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan bio',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.info),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: _deleteBio,
                          child: Text(
                            'Hapus Bio',
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.save,
                        color: Colors.black,
                      ),
                      label: const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _updateProfile,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
