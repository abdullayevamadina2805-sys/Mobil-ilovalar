import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'user.dart';
import 'user_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late User user;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController aboutController;
  late TextEditingController birthdayController;

  @override
  void initState() {
    super.initState();
    user = UserPreferences.getUser();

    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    phoneController = TextEditingController(text: user.phone);
    aboutController = TextEditingController(text: user.about);
    birthdayController = TextEditingController(text: user.birthday);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    aboutController.dispose();
    birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilni tahrirlash'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              UserPreferences.setUser(user);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 24),
          ProfileImage(
            imagePath: user.imagePath,
            onClicked: () async {
              final source = await showImageSource(context);
              if (source == null) return;

              final image = await ImagePicker().pickImage(source: source);
              if (image == null) return;

              setState(() {
                user = user.copy(imagePath: image.path);
              });
            },
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Ism Familiya',
            text: user.name,
            controller: nameController,
            onChanged: (name) {
              user = user.copy(name: name);
            },
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Email',
            text: user.email,
            controller: emailController,
            onChanged: (email) {
              user = user.copy(email: email);
            },
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Telefon',
            text: user.phone,
            controller: phoneController,
            onChanged: (phone) {
              user = user.copy(phone: phone);
            },
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Tug‘ilgan kun',
            text: user.birthday,
            controller: birthdayController,
            onChanged: (birthday) {
              user = user.copy(birthday: birthday);
            },
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Haqida',
            text: user.about,
            maxLines: 5,
            controller: aboutController,
            onChanged: (about) {
              user = user.copy(about: about);
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<ImageSource?> showImageSource(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Kamera'),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Galereya'),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileImage({
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
          Icons.camera_alt,
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

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String text;
  final int maxLines;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const TextFieldWidget({
    super.key,
    required this.label,
    required this.text,
    this.maxLines = 1,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}