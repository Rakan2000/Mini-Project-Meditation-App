import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app/models/user.dart';
import 'package:meditation_app/providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final passwordController = TextEditingController();

  final usernameController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Sign Up"),
            TextField(
              decoration: const InputDecoration(hintText: 'Username'),
              controller: usernameController,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Password'),
              controller: passwordController,
              obscureText: true,
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
                color: Colors.blue,
                child: const Text("Pick Image from Gallery",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold)),
                onPressed: () {
                  File? image;
                  Future pickImage() async {
                    try {
                      final image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (image == null) return;
                      final imageTemp = File(image.path);
                      setState(() => this.image = imageTemp);
                    } on PlatformException catch (e) {
                      print('Failed to pick image: $e');
                    }
                  }
                }),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                final User user = User(
                    username: usernameController.text,
                    password: passwordController.text,
                    image: "");
                context.read<AuthProvider>().signup(user: user).then((token) {
                  if (token.isNotEmpty) {
                    context.pushNamed("signin");
                  }
                });
              },
              child: const Text("Sign Up"),
            )
          ],
        ),
      ),
    );
  }
}
