import 'package:flutter/material.dart';
import 'package:mapsee/auth/auth_service.dart';
import 'package:mapsee/components/date_input_form.dart';
import 'package:mapsee/components/gender_selection_form.dart';
import 'package:mapsee/components/my_button.dart';
import 'package:mapsee/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // TextEditingControllers for form inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final TextEditingController _telNumController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();

  String? _selectedGender;
  bool _allTermsChecked = false;
  bool _privacyPolicyChecked = false;

  void register(BuildContext context) {
    final _auth = AuthService();

    if (_emailController.text.isEmpty) {
      _showSnackBar(context, "이메일를 입력하세요");
      return;
    }

    if (_pwController.text.isEmpty || _confirmPwController.text.isEmpty) {
      _showSnackBar(context, "비밀번호를 입력하세요");
      return;
    }

    if (_pwController.text != _confirmPwController.text) {
      _showSnackBar(context, "비밀번호가 일치하지 않습니다.");
      return;
    }

    if (_telNumController.text.isEmpty) {
      _showSnackBar(context, "휴대전화 번호를 입력하세요");
      return;
    }

    if (_selectedGender == null) {
      _showSnackBar(context, "성별을 선택하세요");
      return;
    }

    if (_yearController.text.isEmpty ||
        _monthController.text.isEmpty ||
        _dayController.text.isEmpty) {
      _showSnackBar(context, "생년월일을 모두 입력하세요");
      return;
    }

    if (!_allTermsChecked || !_privacyPolicyChecked) {
      _showSnackBar(context, "약관에 동의해야 합니다");
      return;
    }

    _auth
        .signUpWithEmailPassword(
            context, _emailController.text, _pwController.text)
        .then((value) {
      if (context.mounted && value) {
        _showSnackBar(context, "회원가입 성공!");
      }
    }).catchError((error) {
      if (context.mounted) {
        _showSnackBar(context, "회원가입 실패: $error");
      }
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            Image.asset(
              'assets/images/mapsee_logo.png',
              width: 126,
              height: 100,
            ),
            const SizedBox(height: 10),
            _buildInputField("이메일", "이메일를 입력하세요", _emailController, false),
            _buildInputField("비밀번호", "비밀번호를 입력하세요", _pwController, true),
            _buildInputField(
                "비밀번호 확인", "비밀번호를 다시 입력하세요", _confirmPwController, true),
            _buildInputField("휴대전화", "전화번호를 입력하세요", _telNumController, false),
            const SizedBox(height: 7),
            _buildDateOfBirthInput(),
            const SizedBox(height: 8),
            _buildGenderSelection(),
            const SizedBox(height: 8),
            _buildAgreementSection(),
            const SizedBox(height: 7),
            MyButton(
              text: "회원가입",
              onTap: () => register(context),
            ),
            const SizedBox(height: 8),
            _buildLoginNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint,
      TextEditingController controller, bool obscureText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        MyTextfield(
          hintText: hint,
          obscureText: obscureText,
          controller: controller,
        ),
        const SizedBox(height: 7),
      ],
    );
  }

  Widget _buildDateOfBirthInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("생년월일"),
        Container(
          child: DateInputForm(
            yearController: _yearController,
            monthController: _monthController,
            dayController: _dayController,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("성별"),
        GenderSelectionForm(
          onGenderChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAgreementSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _allTermsChecked,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
              onChanged: (bool? value) {
                setState(() {
                  _allTermsChecked = value ?? false;
                });
              },
            ),
            const SizedBox(width: 4),
            const Text("약관 모두 동의"),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Checkbox(
              value: _privacyPolicyChecked,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
              onChanged: (bool? value) {
                setState(() {
                  _privacyPolicyChecked = value ?? false;
                });
              },
            ),
            const SizedBox(width: 4),
            const Text("개인 정보 및 정보 수집 동의"),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "이미 계정이 있으신가요?",
          style: TextStyle(color: Theme.of(context).colorScheme.outline),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: widget.onTap,
          child: Text(
            "로그인",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }
}
