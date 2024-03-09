import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/base_app_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();


  void loginUser(String username,String password) async {
    const String apiUrl = 'https://fakestoreapi.com/auth/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({

          'username': username,
          'password': password,
        }),
      );



      if (response.statusCode == 200) {
        showSnackBar("Login Successful");
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print("---------------------------------${response.body}============");

        print("========================$jsonResponse========================");
      } else {
        showSnackBar("Login Failed");
        print('Failed to login. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 5.0).r,
          child: Text(
            "E-commerce",
            style: TextStyle(fontSize: 18.sp, color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).r,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                60.verticalSpace,
                Text(
                  "Welcome back!",
                  style: TextStyle(fontSize: 35.sp),
                ),
                20.verticalSpace,
                InkWell(
                  onTap: () {

                  },
                  child: Text.rich(
                    TextSpan(
                        text: "New here? ",
                        style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                        children: const [
                          TextSpan(
                              text: "Create Account",
                              style: TextStyle(color: Color(0xFFD5715B)))
                        ]),
                  ),
                ),
                70.verticalSpace,
                AppTextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Email Address',
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                ),
                20.verticalSpace,
                AppTextField(
                  controller: _passController,
                  textInputAction: TextInputAction.done,
                  hintText: 'Password',
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0, top: 15).r,
                      child: Text(
                        'Forget?',
                        style: TextStyle(
                            fontSize: 15.sp, color: const Color(0xFFD5715B)),
                      ),
                    ),
                  ),
                  // suffixIcon: Text('Forget Password?'),
                ),
                30.verticalSpace,
                AppButton(
                  onPressed: () {
                    if (_emailController.text.isEmpty) {
                      showSnackBar("Enter your email address");
                    } else if (_passController.text.isEmpty) {
                      showSnackBar("Enter your password");
                    } else {
                      loginUser(_emailController.text, _passController.text);
                    }
                  },
                  title: 'Login',
                ),
                35.verticalSpace,
                Center(
                  child: Text(
                    "or login with",
                    style: TextStyle(
                        fontSize: 12.sp, color: Colors.grey.withOpacity(0.8)),
                  ),
                ),
                35.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    loginMethod("assets/images/img_2.png", "google"),
                    loginMethod("assets/images/img.png", "apple"),
                    loginMethod("assets/images/img_1.png", "facebook"),
                  ],
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginMethod(String image, String type) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30).r,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40).r,
            border: Border.all(color: Colors.grey.withOpacity(0.4))),
        child: Image.asset(
          image,
          width: 30.r,
          height: 30.r,
        ),
      ),
    );
  }

  showSnackBar(String text) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }
}
