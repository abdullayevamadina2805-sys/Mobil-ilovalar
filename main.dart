import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shaxsiy Profil',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 41, 151, 248),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
      ),
      home: const MainScreen(),
    );
  }
}

// ==========================================
// 1. ASOSIY EKRAN (PASTKI MENYU BILAN)
// ==========================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // Dastur ochilganda darhol Profil sahifasi ochiladi

  final List<Widget> _pages = [
    const Center(
      child: Text('Asosiy sahifa', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    ),
    const Center(
      child: Text('Bildirishnomalar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    ),
    const ProfileViewPage(), // Shaxsiy profil sahifasi
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 12,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Asosiy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            activeIcon: Icon(Icons.notifications),
            label: 'Xabarlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. PROFILNI KO'RISH SAHIFASI
// ==========================================
class ProfileViewPage extends StatefulWidget {
  const ProfileViewPage({super.key});

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  // Foydalanuvchi ma'lumotlari
  String fullName = 'Abdullayeva Madina';
  String profession = 'Flutter Dasturchi';
  String phone = '+998 88 052 28 05 ';
  String email = 'abdullayeva.madina2805@gmail.com';
  String birthDate = '28.05.2005';
  String address = 'Surxondaryo vil., Denov tumani';

  // Galereya yoki kompyuterdan rasm tanlash funksiyasi
  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  // Tanlangan rasmni Web (Chrome) va Telefon uchun moslab ko'rsatish
  ImageProvider? _getProfileImage() {
    if (_pickedImage == null) return null;
    if (kIsWeb) {
      return NetworkImage(_pickedImage!.path);
    } else {
      return FileImage(File(_pickedImage!.path));
    }
  }

  // Tahrirlash sahifasiga o'tish funksiyasi
  Future<void> _openEditPage() async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          name: fullName,
          profession: profession,
          phone: phone,
          email: email,
          birthDate: birthDate,
          address: address,
        ),
      ),
    );

    if (updatedData != null && updatedData is Map<String, String>) {
      setState(() {
        fullName = updatedData['name']!;
        profession = updatedData['profession']!;
        phone = updatedData['phone']!;
        email = updatedData['email']!;
        birthDate = updatedData['birthDate']!;
        address = updatedData['address']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Shaxsiy Profil',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, color: Colors.blueAccent, size: 28),
            tooltip: 'Tahrirlash',
            onPressed: _openEditPage,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Yuqori oq karta (Rasm, Ism va Tahrirlash tugmasi)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: _selectImage,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.blue.shade50,
                          backgroundImage: _getProfileImage(),
                          child: _pickedImage == null
                              ? const Icon(Icons.person, size: 65, color: Colors.blueAccent)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: GestureDetector(
                          onTap: _selectImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    fullName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profession,
                    style: const TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _openEditPage,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Profilni tahrirlash', style: TextStyle(fontSize: 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Shaxsiy ma'lumotlar bo'limi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 6, bottom: 10),
                    child: Text(
                      'Shaxsiy ma’lumotlar',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ),
                  _buildInfoItem(Icons.phone_rounded, 'Telefon raqam', phone),
                  _buildInfoItem(Icons.email_rounded, 'Elektron pochta', email),
                  _buildInfoItem(Icons.cake_rounded, 'Tug‘ilgan sana', birthDate),
                  _buildInfoItem(Icons.location_on_rounded, 'Yashash manzili', address),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.blueAccent),
        ),
        title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ),
    );
  }
}

// ==========================================
// 3. PROFILNI TAHRIRLASH SAHIFASI
// ==========================================
class EditProfilePage extends StatefulWidget {
  final String name;
  final String profession;
  final String phone;
  final String email;
  final String birthDate;
  final String address;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.profession,
    required this.phone,
    required this.email,
    required this.birthDate,
    required this.address,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _profController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _birthController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _profController = TextEditingController(text: widget.profession);
    _phoneController = TextEditingController(text: widget.phone);
    _emailController = TextEditingController(text: widget.email);
    _birthController = TextEditingController(text: widget.birthDate);
    _addressController = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _profController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilni tahrirlash', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInput('Ism va Familiya', _nameController, Icons.person_outline),
            _buildInput('Kasbingiz / Bio', _profController, Icons.work_outline),
            _buildInput('Telefon raqamingiz', _phoneController, Icons.phone_outlined),
            _buildInput('Elektron pochta', _emailController, Icons.email_outlined),
            _buildInput('Tug‘ilgan sanangiz', _birthController, Icons.cake_outlined),
            _buildInput('Manzilingiz', _addressController, Icons.location_on_outlined),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  Navigator.pop(context, {
                    'name': _nameController.text,
                    'profession': _profController.text,
                    'phone': _phoneController.text,
                    'email': _emailController.text,
                    'birthDate': _birthController.text,
                    'address': _addressController.text,
                  });
                },
                child: const Text('Saqlash', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}