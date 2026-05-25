import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:clean_ios_app/config/app_colors.dart';
import 'package:clean_ios_app/config/images.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:clean_ios_app/pages/profilepage/user_data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:clean_ios_app/pages/profilepage/editpassword.dart';

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final Uint8List? initialImage;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentEmail,
    this.initialImage,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: UserData.name.isNotEmpty ? UserData.name : widget.currentName,
    );
    _emailController = TextEditingController(
      text: UserData.email.isNotEmpty ? UserData.email : widget.currentEmail,
    );
    _imageBytes = UserData.profileImage ?? widget.initialImage;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final Uint8List bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      debugPrint("Ошибка при выборе фото: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 60,
                  left: 16,
                  right: 16,
                  bottom: 20,
                ),
                child: const Text(
                  'Редактирование\nпрофиля',
                  style: TextStyle(
                    fontSize: 34,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                    color: bgCardWhite,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: bgAppMain,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: primaryGreen,
                                    width: 2,
                                  ),
                                  color: Colors.grey[200],
                                ),
                                child: ClipOval(
                                  child: _imageBytes != null
                                      ? Image.memory(
                                          _imageBytes!,
                                          key: ValueKey(_imageBytes.hashCode),
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        )
                                      : Image.asset(
                                          'assets/images/cat_avatar.png',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return const Icon(
                                                  Icons.person,
                                                  size: 50,
                                                );
                                              },
                                        ),
                                ),
                              ),
                              _buildCameraIcon(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildLabel('Логин'),
                        const SizedBox(height: 8),
                        _buildTextField(_nameController, "Введите логин"),
                        const SizedBox(height: 25),
                        _buildLabel('Почта'),
                        const SizedBox(height: 8),
                        _buildTextField(_emailController, "Введите почту"),
                        const SizedBox(height: 60),
                        GestureDetector(
                          onTap: () {
                            // --- ИЗМЕНЕННАЯ ЛОГИКА ПЕРЕХОДА ---
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Сменить пароль',
                            style: TextStyle(
                              color: primaryGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildButton(
                          text: 'Сохранить',
                          bgColor: primaryGreen,
                          textColor: bgCardWhite,
                          onPressed: () {
                            final box = Hive.box('usersBox');
                            String oldEmail = UserData.email;
                            String newEmail = _emailController.text.trim();
                            String newName = _nameController.text.trim();

                            if (newEmail != oldEmail && newEmail.isNotEmpty) {
                              final password = box.get(oldEmail);
                              box.put(newEmail, password);
                              box.put('${newEmail}_name', newName);

                              box.delete(oldEmail);
                              box.delete('${oldEmail}_name');
                            } else {
                              box.put('${oldEmail}_name', newName);
                            }

                            UserData.profileImage = _imageBytes;
                            UserData.name = newName;
                            UserData.email = newEmail;

                            Navigator.pop(context, {
                              'webBytes': _imageBytes,
                              'name': newName,
                              'email': newEmail,
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildButton(
                          text: 'Отмена',
                          bgColor: bgCardWhite,
                          textColor: labelPrimaryAndButton,
                          isOutlined: true,
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: labelSecondary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: labelSeparator, fontSize: 17),
      onTap: () {
        if (controller.text.isNotEmpty) {
          controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.text.length,
          );
        }
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 17),
        filled: true,
        fillColor: bgCardWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: labelSeparator),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCameraIcon() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: bgAppMain,
            shape: BoxShape.circle,
          ),
          child: editProfilePic,
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onPressed,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: 167,
      height: 49,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          elevation: 0,
          side: isOutlined ? const BorderSide(color: labelSeparator) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
