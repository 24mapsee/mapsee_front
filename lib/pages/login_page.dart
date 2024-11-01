import 'package:flutter/material.dart';

import 'package:mapsee/auth/auth_service.dart';
import 'package:mapsee/components/my_button.dart';
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.15),
              Image.asset(
                'assets/images/mapsee_logo.png',
                width: 126,
                height: 100,
              ),
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
              // 아이디 비번 잊으셨나요
              const SizedBox(height: 16),
              const SizedBox(
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
                          height: 0,
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
                          height: 0,
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
                          height: 0,
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
                          height: 0,
                          letterSpacing: 1.69,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // 로그인 버튼
              MyButton(
                text: "로그인",
                onTap: () {
                  if (_emailController.text.isNotEmpty &&
                      _pwController.text.isNotEmpty) {
                    login(context, "email");
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ID와 비밀번호를 모두 입력해주세요.')),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 7),
              // 더욱 간편한 로그인
              Center(
                child: Container(
                  width: 265,
                  height: 14.35,
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 80.60,
                        top: 0,
                        child: SizedBox(
                          width: 104.90,
                          height: 14.35,
                          child: Text(
                            '더욱 간편한 로그인',
                            style: TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 11,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w300,
                              height: 0,
                              letterSpacing: 1.43,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 6.62,
                        child: Container(
                          width: 68.46,
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.50,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 196.54,
                        top: 6.62,
                        child: Container(
                          width: 68.46,
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.50,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 7),
              // 구글, 카카오, 네이버
              MyButton(
                text: "구글",
                onTap: () => {login(context, "google")},
              ),
              const SizedBox(height: 7),
              MyButton(
                text: "카카오",
                onTap: () => {login(context, "kakao")},
              ),
              const SizedBox(height: 7),
              MyButton(
                text: "네이버",
                onTap: () => {login(context, "naver")},
              ),
              const SizedBox(height: 7),
              // 회원가입 이동
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "아직 계정이 없으신가요?",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.outline),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text("회원가입",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).colorScheme.outline)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
