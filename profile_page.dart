import 'dart:io';
import 'package:flutter/material.dart';
import 'user.dart';
import 'user_preferences.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = UserPreferences.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mening Profilim'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
              setState(() {
                user = UserPreferences.getUser();
              });
            },
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 24),
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
              setState(() {
                user = UserPreferences.getUser();
              });
            },
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 24),
          buildAbout(user),
          const SizedBox(height: 24),
          buildInfo(user),
        ],
      ),
    );
  }

  Widget buildName(User user) {
    return Column(
      children: [
        Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget buildAbout(User user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Haqida',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            user.about,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget buildInfo(User user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ma\'lumotlar',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          InfoRow(icon: Icons.phone, text: user.phone),
          InfoRow(icon: Icons.cake, text: user.birthday),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 22),
          const SizedBox(width: 16),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    super.key,
    required this.imagePath,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final ImageProvider image = imagePath.isEmpty
        ? const AssetImage('assets/default_avatar.png')
        : FileImage(File(imagePath));

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 140,
          height: 140,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) {
    return buildCircle(
      color: Colors.white,
      all: 3,
      child: buildCircle(
        color: color,
        all: 8,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }
}