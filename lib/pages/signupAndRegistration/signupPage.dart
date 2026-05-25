import 'package:flutter/material.dart';
import 'package:clean_ios_app/config/app_colors.dart';
import 'package:clean_ios_app/pages/signupAndRegistration/registrationPage.dart';
import 'package:clean_ios_app/pages/mainpage/mainpage1.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _hasError = false;

  void _onLoginPressed() {
    final box = Hive.box('usersBox');
    final email = _loginController.text.trim();
    final password = _passwordController.text;

    final String? savedPassword = box.get(email);

    setState(() {
      if (savedPassword != null && savedPassword == password) {
        _hasError = false;
        box.put('isLoggedIn', true);

        final String savedName = box.get('${email}_name') ?? "Пользователь";

        print("Вход выполнен успешно для: $savedName");

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MainPage(userName: savedName, userEmail: email),
          ),
          (route) => false,
        );
      } else {
        _hasError = true;
      }
    });
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
                    const SizedBox(height: 100),
                    const Text(
                      'Вход',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: labelPrimaryAndButton,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildInputField(
                      'Почта',
                      controller: _loginController,
                      isError: _hasError,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      'Пароль',
                      controller: _passwordController,
                      isPassword: true,
                      isError: _hasError,
                    ),
                    if (_hasError)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          'Неверная почта или пароль!',
                          style: TextStyle(
                            color: error,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    const Spacer(),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 197,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _onLoginPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreen,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Войти',
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
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationPage(),
                                ),
                              );
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Inter',
                                  color: searchText,
                                ),
                                children: [
                                  const TextSpan(text: 'Нет аккаунта?\n'),
                                  TextSpan(
                                    text: 'Зарегистрироваться',
                                    style: TextStyle(
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
                    ),
                    const SizedBox(height: 124),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String hint, {
    required TextEditingController controller,
    bool isPassword = false,
    bool isError = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(
        color: labelPrimaryAndButton,
        fontSize: 17,
        fontFamily: 'Inter',
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: bgAppMain,
        hintText: hint,
        hintStyle: const TextStyle(color: searchText, fontSize: 17),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isError ? error : Colors.transparent,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isError ? error : primaryGreen,
            width: 1,
          ),
        ),
      ),
    );
  }
}
