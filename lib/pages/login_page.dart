import 'package:flutter/material.dart';
import 'package:mapsee/auth/auth_service.dart';
import 'package:mapsee/components/my_button.dart';
import 'package:mapsee/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  // id, pw text controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  // tap to go register page
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  // login method
  void login(BuildContext context) async {
    // auth service
    final authService = AuthService();

    // try login
    try {
      await authService.signInWithEmailAndPassword(
          _emailController.text, _pwController.text);
    } catch (e) {
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // logo
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
            const SizedBox(height: 7),
            Center(
              child: SizedBox(
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
            ),

            const SizedBox(height: 7),
            // 로그인 버튼
            MyButton(
              text: "로그인",
              onTap: () => login(context),
            ),
            const SizedBox(height: 7),
            // 더욱 간편한 로그인
            Center(
              child: Container(
                width: 265,
                height: 14.35,
                child: Stack(
                  children: [
                    Positioned(
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
                        decoration: ShapeDecoration(
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
                        decoration: ShapeDecoration(
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
              onTap: ()=>{},
            ),
            const SizedBox(height: 7),
            MyButton(
              text: "카카오",
              onTap: ()=>{},
            ),
            const SizedBox(height: 7),
            MyButton(
              text: "네이버",
              onTap: ()=>{},
            ),
            const SizedBox(height: 7),
            // 회원가입 이동
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "아직 계정이 없으신가요?",
                  style:
                  TextStyle(color: Theme
                      .of(context)
                      .colorScheme
                      .outline),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: onTap,
                  child: Text("회원가입",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .outline)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
