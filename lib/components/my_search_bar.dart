import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class MySearchBar extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const MySearchBar({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  _MySearchBarState createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  final SpeechToText _speech = SpeechToText();
  bool _speechEnabled = false;
  String _ttsText = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    if (await Permission.microphone.request().isGranted) {
      _speechEnabled = await _speech.initialize(
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) => print('Speech error: $error'),
      );
      print('Speech enabled: $_speechEnabled');
      setState(() {});
    } else {
      print('Microphone permission not granted');
    }
  }

  void _startListening() async {
    if (_speechEnabled) {
      await _speech.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        localeId: 'ko_KR',
      );
      print('Listening...');
      setState(() {});
    }
  }

  void _stopListening() async {
    await _speech.stop();
    print('Stopped listening');
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _ttsText = result.recognizedWords;
      widget.controller.text = _ttsText;
      widget.onChanged(_ttsText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: widget.controller,
        enabled: true,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.background,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.outline),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          suffixIcon: IconButton(
            icon: Image.asset(
              'assets/images/png/mic.png',
              width: 20,
              color: Theme.of(context).colorScheme.outline,
            ),
            onPressed: () {
              if (_speech.isListening) {
                _stopListening();
              } else {
                _startListening();
              }
            },
          ),
        ),
      ),
    );
  }
}
