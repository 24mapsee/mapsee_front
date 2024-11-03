import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart'; // Add this for date formatting
import 'package:mapsee/utils/common.dart';

class EditProfilePage extends StatefulWidget {
  final VoidCallback onRefresh;
  const EditProfilePage({super.key, required this.onRefresh});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isLoading = true;
  Map<String, dynamic> userData = {};
  DateTime? selectedBirthDate;
  String? selectedGender;

  TextEditingController birthDateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String? userIDToken = await getFirebaseIDToken();
    log("idToken: $userIDToken");

    try {
      final url = '${dotenv.env["API_BASE_URL"]}/profile/userInfo';
      final response = await http.post(Uri.parse(url), body: {
        'idToken': userIDToken,
      });
      log(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          userData = jsonResponse['userData'];

          nameController.text = userData['name'] ?? '';
          phoneNumberController.text = userData['phone_number'] ?? '';
          emailController.text = userData['email'] ?? '';

          if (userData['birth_date'] != null) {
            selectedBirthDate = DateTime.parse(userData['birth_date']);
            birthDateController.text =
                DateFormat('yyyy-MM-dd').format(selectedBirthDate!);
          } else {
            birthDateController.text = '생년월일 없음';
          }
          selectedGender = userData['gender'];
          isLoading = false;
        });
      } else {
        log('Failed to load user info');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching user info: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserInfo() async {
    String? userIDToken = await getFirebaseIDToken();
    final url = '${dotenv.env["API_BASE_URL"]}/modify/userInfo';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'idToken': userIDToken,
          'userData': {
            'name': nameController.text,
            'phone_number': phoneNumberController.text,
            'birth_date': selectedBirthDate != null
                ? DateFormat('yyyy-MM-dd').format(selectedBirthDate!)
                : null,
            'gender': selectedGender,
          },
        }),
      );

      log(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('정보가 성공적으로 업데이트 되었습니다.'),
              duration: Duration(seconds: 2),
            ),
          );

          widget.onRefresh();
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('정보 업데이트에 실패했습니다.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      log('Error updating user info: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('서버와의 연결에 실패했습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedBirthDate = pickedDate;
        birthDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _showServiceUnavailableSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('현재 연동 추가 기능은 점검 중입니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보 수정', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userData['profile_picture'] != null
                        ? NetworkImage(userData['profile_picture'])
                        : const AssetImage(
                                'assets/images/dummy/default_user.png')
                            as ImageProvider,
                  ),
                  const SizedBox(height: 20),
                  _buildEditableField(
                      '이름', nameController), // Updated to use controller
                  _buildEditableField('이메일', emailController,
                      isEditable: false),
                  _buildEditableField('휴대전화',
                      phoneNumberController), // Updated to use controller
                  _buildBirthDateField(),
                  _buildGenderDropdown(),
                  _buildLinkAccountField(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _updateUserInfo();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 32),
                    ),
                    child: const Text('저장'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      {bool isEditable = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          TextFormField(
            controller: controller, // Use controller here
            enabled: isEditable,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('생년월일', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          GestureDetector(
            onTap: () => _selectDate(context), // Open the date picker
            child: AbsorbPointer(
              child: TextFormField(
                controller: birthDateController,
                // enabled: false, // Make it non-editable
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('성별', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          DropdownButtonFormField<String>(
            value: selectedGender,
            hint: const Text('정보 없음'),
            items: const [
              DropdownMenuItem(value: '남성', child: Text('남성')),
              DropdownMenuItem(value: '여성', child: Text('여성')),
              DropdownMenuItem(value: '선택하지 않음', child: Text('선택하지 않음')),
            ],
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkAccountField() {
    return GestureDetector(
      onTap: _showServiceUnavailableSnackbar,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('연동 계정',
                style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            const SizedBox(height: 12),
            const Text(
              '연동 추가',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Divider(color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}
