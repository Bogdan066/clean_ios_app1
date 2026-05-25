import 'package:flutter/material.dart';
import 'package:clean_ios_app/config/app_colors.dart';
import 'package:clean_ios_app/pages/profilepage/user_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  String? _currentPassError;
  String? _confirmPassError;

  void _validateAndSave() {
    setState(() {
      _currentPassError = null;
      _confirmPassError = null;
    });

    final box = Hive.box('usersBox');
    final String currentSavedPass = box.get(UserData.email) ?? "";

    bool hasError = false;

    if (_currentPassController.text != currentSavedPass) {
      _currentPassError = "Неверный текущий пароль!";
      hasError = true;
    }

    if (_newPassController.text != _confirmPassController.text) {
      _confirmPassError = "Пароли должны совпадать!";
      hasError = true;
    }

    if (_newPassController.text.isEmpty) {
      hasError = true;
    }

    if (!hasError) {
      box.put(UserData.email, _newPassController.text);
      Navigator.pop(context);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 52,
              left: 16,
              right: 16,
              bottom: 0,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: bgCardWhite,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Смена пароля',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: bgCardWhite,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: bgAppMain,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    _buildLabel('Текущий пароль'),
                    const SizedBox(height: 8),
                    _buildPasswordField(
                      _currentPassController,
                      "Введите текущий пароль",
                      _currentPassError != null,
                    ),
                    _buildManualError(_currentPassError),

                    const SizedBox(height: 25),

                    _buildLabel('Новый пароль'),
                    const SizedBox(height: 8),
                    _buildPasswordField(
                      _newPassController,
                      "Введите новый пароль",
                      false,
                    ),

                    const SizedBox(height: 25),

                    _buildLabel('Повторите пароль'),
                    const SizedBox(height: 8),
                    _buildPasswordField(
                      _confirmPassController,
                      "Повторите новый пароль",
                      _confirmPassError != null,
                    ),
                    _buildManualError(_confirmPassError),

                    const SizedBox(height: 60),

                    _buildButton(
                      text: 'Сохранить',
                      bgColor: primaryGreen,
                      textColor: bgCardWhite,
                      onPressed: _validateAndSave,
                    ),
                    const SizedBox(height: 12),
                    _buildButton(
                      text: 'Отмена',
                      bgColor: bgCardWhite,
                      textColor: labelPrimaryAndButton,
                      isOutlined: true,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
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
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildManualError(String? error) {
    if (error == null) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          error,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String hint,
    bool hasError,
  ) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(color: labelSeparator, fontSize: 17),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 17),
        filled: true,
        fillColor: bgCardWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        errorStyle: const TextStyle(height: 0, fontSize: 0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasError ? Colors.red : labelSeparator,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasError ? Colors.red : primaryGreen,
            width: 1.5,
          ),
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
