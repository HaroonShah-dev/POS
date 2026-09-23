import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/auth/login/login_screen.dart';
import 'package:store_management_system/views/dashboard/dashboard_screen.dart';

class AuthViewModel extends ChangeNotifier {
  bool isloading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController storeName = TextEditingController();
  TextEditingController phone = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? userEmail;
  String? userFullName;
  String? userStoreName;
  String? userPhone;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userSubscription;

  // LOGIN
  Future<void> login(BuildContext context) async {
    try {
      isloading = true;
      notifyListeners();

      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      //  await listenToUser();

      isloading = false;
      notifyListeners();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Logged in successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (error) {
      isloading = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void listenToUser() {
    final user = auth.currentUser;

    if (user == null) {
      return;
    }

    userSubscription = firestore
        .collection('Users')
        .doc(user.uid)
        .snapshots()
        .listen((document) {
          if (document.exists) {
            final data = document.data();

            userEmail = data?['email'];
            userFullName = data?['fullName'];
            userStoreName = data?['storeName'];
            userPhone = data?['phone'];

            notifyListeners();
          }
        });
  }

  // REGISTER
  Future register(BuildContext context) async {
    try {
      isloading = true;
      notifyListeners();

      final user = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await firestore.collection('Users').doc(user.user!.uid).set({
        'email': emailController.text.trim(),
        'fullName': fullName.text.trim(),
        'storeName': storeName.text.trim(),
        'phone': phone.text.trim(),
      });

      isloading = false;
      notifyListeners();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Congratulations! Your store has been created.'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (error) {
      isloading = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    userSubscription?.cancel();
    emailController.dispose();
    fullName.dispose();
    passwordController.dispose();
    confirmPassword.dispose();
    storeName.dispose();
    phone.dispose();

    super.dispose();
  }
}
