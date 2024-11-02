import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mapsee/auth/login_or_register.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign up with email and password
  Future<bool> signUpWithEmailPassword(
      BuildContext context, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env["API_BASE_URL"]}/user/register/native'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('회원가입 성공! 로그인 페이지로 이동합니다.')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginOrRegister()),
          );
        }
        return true;
      } else if (response.statusCode == 409) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ID가 중복입니다. 다른 ID를 사용해주세요.')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('회원가입 실패: ${response.body.toString()}')),
          );
        }
      }
      return false; // 모든 실패 상황에서 false 반환
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('에러: ${e.toString()}')),
        );
      }
      return false; // 예외 상황에서도 false 반환
    }
  }

  // sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Sign in aborted by user');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // log(googleUser.toString());
      log(googleAuth.toString());

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final String? uid = userCredential.user?.uid;
      const String provider = 'google';
      log('userCredential: ${userCredential.user.toString()}');

      if (uid != null) {
        final response = await http.post(
          Uri.parse('${dotenv.env["API_BASE_URL"]}/user/register/social'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'uid': uid,
            'provider': provider,
          }),
        );

        log("!!!!!!!!!!");
        log(response.body);
        if (response.statusCode != 200) {
          throw Exception('Failed to send token to server: ${response.body}');
        }
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
  }
}
