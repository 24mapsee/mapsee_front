import 'package:flutter/material.dart';
import 'package:mapsee/components/date_input_form.dart';
import 'package:mapsee/components/gender_selection_form.dart';
import 'package:mapsee/components/my_button.dart';
import 'package:mapsee/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // ID, PW, 전화번호 등의 TextEditingController
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final TextEditingController _telNumController = TextEditingController();
  final TextEditingController _confirmTelNumController =
  TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();

  String? _selectedGender;

  void register() {

  }

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("아이디"),
                MyTextfield(
                  hintText: "ID를 입력하세요",
                  obscureText: false,
                  controller: _idController,
                ),
              ],
            ),
            const SizedBox(height: 7),
            // PW field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("비밀번호"),
                MyTextfield(
                  hintText: "비밀번호를 입력하세요",
                  obscureText: true,
                  controller: _pwController,
                ),
                const SizedBox(height: 5),
                // 비번 확인
                MyTextfield(
                  hintText: "비밀번호를 다시 입력하세요",
                  obscureText: true,
                  controller: _confirmPwController,
                ),
              ],
            ),
            const SizedBox(height: 7),

            // 휴대전화
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("휴대전화"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MyTextfield(
                        hintText: "전화번호를 입력하세요",
                        obscureText: false,
                        controller: _telNumController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    MyButton(
                      text: "인증번호 발송",
                      onTap: () {
                        // 인증번호 발송 로직
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // 인증번호 입력
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MyTextfield(
                        hintText: "인증번호를 입력하세요",
                        obscureText: false,
                        controller: _confirmTelNumController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    MyButton(
                      text: "인증번호 확인",
                      onTap: () {
                        // 인증번호 확인 로직
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            // 생년월일
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("생년월일"),
                DateInputForm(
                  yearController: _yearController,
                  monthController: _monthController,
                  dayController: _dayController,
                ),
              ],
            ),
            // 성별 선택
            const SizedBox(height: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("성별"),
                GenderSelectionForm(
                  onGenderChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 7),
            // 회원가입 버튼
            MyButton(
              text: "회원가입",
              onTap: register,
            ),
            const SizedBox(height: 7),
            // 로그인 이동
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "이미 계정이 있으신가요?",
                  style: TextStyle(color: Theme.of(context).colorScheme.outline),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text("로그인",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.outline)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
