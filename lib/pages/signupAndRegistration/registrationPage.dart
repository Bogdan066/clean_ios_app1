import 'package:flutter/material.dart';
import 'package:clean_ios_app/config/app_colors.dart';
import 'package:clean_ios_app/pages/signupAndRegistration/signUpPage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _isAgreed = false;
  bool _showCheckboxError = false;

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _emailError;
  String? _passwordError;

  void _onRegisterPressed() {
    final box = Hive.box('usersBox');
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _loginController.text.trim();

    setState(() {
      _showCheckboxError = !_isAgreed;

      if (name.isEmpty) {
        _emailError = 'Введите логин!';
        return;
      }

      if (password != _confirmPasswordController.text) {
        _passwordError = 'Пароли должны совпадать!';
      } else if (password.length < 6) {
        _passwordError = 'Пароль слишком короткий!';
      } else {
        _passwordError = null;
      }

      if (email.isEmpty || !email.contains('@')) {
        _emailError = 'Введите корректную почту!';
      } else if (box.containsKey(email)) {
        _emailError = 'Пользователь с такой почтой уже существует!';
      } else {
        _emailError = null;
      }
    });

    if (_passwordError == null &&
        _emailError == null &&
        _isAgreed &&
        name.isNotEmpty) {
      box.put(email, password);

      box.put('${email}_name', name);

      print("Регистрация успешна: Имя: $name, Почта: $email");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Аккаунт для $name создан!'),
          backgroundColor: primaryGreen,
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCardWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    const Text(
                      'Регистрация',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: labelPrimaryAndButton,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildInputField('Логин', controller: _loginController),
                    const SizedBox(height: 28),
                    _buildInputField(
                      'Почта',
                      controller: _emailController,
                      errorText: _emailError,
                    ),
                    const SizedBox(height: 28),
                    _buildInputField(
                      'Пароль',
                      isPassword: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 28),
                    _buildInputField(
                      'Повторите пароль',
                      isPassword: true,
                      controller: _confirmPasswordController,
                      errorText: _passwordError,
                    ),
                    const SizedBox(height: 28),
                    _buildAgreementCheckbox(),
                    const Spacer(),
                    _buildButtons(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgreementCheckbox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isAgreed = !_isAgreed;
            if (_isAgreed) _showCheckboxError = false;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _isAgreed ? primaryGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _isAgreed
                      ? primaryGreen
                      : (_showCheckboxError ? error : searchText),
                  width: 1,
                ),
              ),
              child: _isAgreed
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Я согласен с условиями использования',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _showCheckboxError ? error : searchText,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 197,
            height: 56,
            child: ElevatedButton(
              onPressed: _onRegisterPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Создать аккаунт',
                style: TextStyle(
                  color: bgCardWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Inter',
                  color: searchText,
                ),
                children: [
                  const TextSpan(text: 'Уже есть аккаунт? '),
                  TextSpan(
                    text: 'Войти',
                    style: const TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String hint, {
    bool isPassword = false,
    required TextEditingController controller,
    String? errorText,
  }) {
    bool hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(
            color: labelPrimaryAndButton,
            fontSize: 17,
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: bgAppMain,
            hintText: hint,
            hintStyle: const TextStyle(
              color: searchText,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError ? error : Colors.transparent,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError ? error : primaryGreen,
                width: 1,
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              errorText,
              style: const TextStyle(
                color: error,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
          ),
      ],
    );
  }
}
