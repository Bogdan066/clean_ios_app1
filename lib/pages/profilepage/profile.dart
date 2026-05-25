import 'package:flutter/material.dart';
import 'package:clean_ios_app/config/images.dart';
import 'package:clean_ios_app/config/app_colors.dart';
import 'package:clean_ios_app/pages/profilepage/profileedit.dart';
import 'package:clean_ios_app/pages/profilepage/user_data.dart';
import 'package:clean_ios_app/pages/signupAndRegistration/onboardpage.dart';
import 'package:clean_ios_app/pages/profilepage/izbrannoepage.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    if (UserData.name.isEmpty) {
      UserData.name = widget.userName;
      UserData.email = widget.userEmail;
    }
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgCardWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Выход',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: labelPrimaryAndButton,
            ),
          ),
          content: const Text(
            'Вы точно хотите выйти?\nДанные текущего сеанса будут стерты.',
            style: TextStyle(color: labelSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Отмена',
                style: TextStyle(
                  color: labelSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                UserData.name = "";
                UserData.email = "";
                UserData.profileImage = null;

                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                  (route) => false,
                );
              },
              child: const Text(
                'Да, выйти',
                style: TextStyle(color: error, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 52, left: 16, right: 16),
          child: Text(
            'Профиль',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: bgCardWhite,
              fontFamily: 'Inter',
            ),
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
              padding: const EdgeInsets.only(
                top: 30,
                left: 16,
                right: 16,
                bottom: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(),
                  const SizedBox(height: 40),
                  const Divider(height: 1, color: labelSeparator, thickness: 1),
                  const SizedBox(height: 40),
                  _buildFavoritesButton(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: primaryGreen, width: 2),
              ),
              child: ClipOval(child: _buildAvatarImage()),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _showExitDialog(context),
                    child: exit,
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            currentName: UserData.name,
                            currentEmail: UserData.email,
                            initialImage: UserData.profileImage,
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {});
                      }
                    },
                    child: edit,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          UserData.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: labelPrimaryAndButton,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 3),
        Text(
          UserData.email,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: labelSecondary,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarImage() {
    if (UserData.profileImage != null) {
      return Image.memory(
        UserData.profileImage!,
        fit: BoxFit.cover,
        key: ValueKey(UserData.profileImage.hashCode),
      );
    } else {
      return Image.asset(
        'assets/images/cat_avatar.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          );
        },
      );
    }
  }

  Widget _buildFavoritesButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoritesPage()),
        );
      },
      child: Container(
        height: 53,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: bgCardWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            izbrannoe,
            const SizedBox(width: 15),
            const Text(
              'Избранное',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: labelPrimaryAndButton,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: labelSecondary),
          ],
        ),
      ),
    );
  }
}
