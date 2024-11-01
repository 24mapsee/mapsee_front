import 'package:flutter/material.dart';

import 'package:mapsee/auth/auth_service.dart';
import 'package:mapsee/components/my_button.dart';
import 'package:mapsee/components/my_login_social_button.dart';
import 'package:mapsee/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // id, pw text controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  // login method
  void login(BuildContext context, String type) async {
    // auth service
    final authService = AuthService();

    // try login
    try {
      switch (type) {
        case 'email':
          await authService.signInWithEmailAndPassword(
              _emailController.text, _pwController.text);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('로그인 성공!')),
            );
          }
          break;
        case 'google':
          await authService.signInWithGoogle();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('로그인 성공!')),
            );
          }
          break;
        case 'kakao':
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('서비스 점검중입니다.')),
            );
          }
          // await _loginWithKakao(authService);
          break;
        case 'naver':
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('서비스 점검중입니다.')),
            );
          }
          // await _loginWithNaver(authService);
          break;
        default:
          break;
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.15),
                  Center(
                    child: Image.asset(
                      'assets/images/mapsee_logo.png',
                      width: 126,
                      height: 100,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  // Id field
                  MyTextfield(
                    hintText: "ID를 입력하세요",
                    obscureText: false,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 7),
                  // PW field
                  MyTextfield(
                    hintText: "비밀번호를 입력하세요",
                    obscureText: true,
                    controller: _pwController,
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'ID',
                            style: TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 13,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              letterSpacing: 1.69,
                            ),
                          ),
                          TextSpan(
                            text: ' 또는 ',
                            style: TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 13,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w200,
                              letterSpacing: 1.69,
                            ),
                          ),
                          TextSpan(
                            text: '비밀번호',
                            style: TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 13,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              letterSpacing: 1.69,
                            ),
                          ),
                          TextSpan(
                            text: '를 잊으셨나요?',
                            style: TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 13,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w200,
                              letterSpacing: 1.69,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  MyButton(
                    text: "로그인",
                    onTap: () {
                      if (_emailController.text.isNotEmpty &&
                          _pwController.text.isNotEmpty) {
                        login(context, "email");
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('ID와 비밀번호를 모두 입력해주세요.')),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 7),
                  Center(
                    child: Container(
                      width: constraints.maxWidth * 0.8,
                      child: const Column(
                        children: [
                          Text(
                            '더욱 간편한 로그인',
                            style: TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 11,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.43,
                            ),
                          ),
                          Divider(color: Color(0xFFD9D9D9)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 10,
                    runSpacing: 7,
                    alignment: WrapAlignment.center,
                    children: [
                      MyLoginSocialButton(
                        onPressed: () => login(context, "google"),
                        imagePath: 'assets/images/svg/ic_login_google.svg',
                        buttonText: 'Google 계정 로그인',
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                      ),
                      MyLoginSocialButton(
                        onPressed: () => login(context, "kakao"),
                        imagePath: 'assets/images/svg/ic_login_kakao.svg',
                        buttonText: '카카오 로그인',
                        backgroundColor: const Color(0xFFFEE500),
                        textColor: Colors.black,
                      ),
                      MyLoginSocialButton(
                        onPressed: () => login(context, "naver"),
                        imagePath: 'assets/images/svg/ic_login_naver.svg',
                        buttonText: '네이버 로그인',
                        backgroundColor: const Color(0xFF03C75A),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "아직 계정이 없으신가요?",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            "회원가입",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).colorScheme.outline),
                          ),
                        ),
                      ],
                    ),
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
