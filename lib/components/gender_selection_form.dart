import 'package:flutter/material.dart';

class GenderSelectionForm extends StatefulWidget {
  final ValueChanged<String?> onGenderChanged;
  GenderSelectionForm({required this.onGenderChanged});

  @override
  _GenderSelectionFormState createState() => _GenderSelectionFormState();
}

class _GenderSelectionFormState extends State<GenderSelectionForm> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GenderSelection(
        selectedGender: _selectedGender,
        onGenderChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
          widget.onGenderChanged(value);
        },
      ),
    );
  }
}

class GenderSelection extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;

  const GenderSelection({
    Key? key,
    required this.selectedGender,
    required this.onGenderChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final genderOptions = [
      {'label': '남성', 'value': '남성'},
      {'label': '여성', 'value': '여성'},
      {'label': '선택안함', 'value': '선택안함'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: genderOptions.map((option) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.0),
            child: SizedBox(
              height: 40,
              child: ChoiceChip(
                label: Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    option['label']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selectedGender == option['value']
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                selected: selectedGender == option['value'],
                selectedColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.background,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onSelected: (selected) {
                  if (selected) onGenderChanged(option['value']);
                },
                showCheckmark: false,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
