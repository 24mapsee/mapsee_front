import 'package:flutter/material.dart';
import 'package:mapsee/components/my_button.dart';
import 'package:mapsee/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
// id, pw text controller
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  RegisterPage({super.key});

  void register() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
              controller: _idController,
            ),
            const SizedBox(height: 7),
            // PW field
            MyTextfield(
              hintText: "비밀번호를 입력하세요",
              obscureText: true,
              controller: _pwController,
            ),
            const SizedBox(height: 7),
            // 비번 확인
            MyTextfield(
              hintText: "비밀번호를 다시 입력하세요",
              obscureText: true,
              controller: _confirmPwController,
            ),

            const SizedBox(height: 7),
            // 로그인 버튼
            MyButton(
              text: "회원가입",
              onTap: register,
            ),
            const SizedBox(height: 7),
            // 회원가입 이동
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "이미 계정이 있으신가요?",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                ),
                const SizedBox(width: 20),
                Text("로그인",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.outline)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
