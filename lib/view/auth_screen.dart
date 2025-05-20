import 'package:employe_task/const.dart';
import 'package:employe_task/utlis/spacer/spacer.dart';
import 'package:employe_task/view/login_screen.dart';
import 'package:employe_task/view/signup_screen.dart';
import 'package:employe_task/widget/appbar.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final String role;
  const AuthScreen({super.key, required this.role});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLogin = true;

  void toggleAuth() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get image based on role
    String roleImage = widget.role == "ADMIN" ? admiImage : userIMage;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                vSpace36,

                // Profile Image & Role Text
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 53,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(roleImage),
                  ),
                ),
                vSpace18,
                Text(
                  "Welcome,${widget.role}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                vSpace36,

                // Login / Signup Form
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child:
                      showLogin
                          ? Login(
                            onToggle: toggleAuth,
                            key: ValueKey('login'),
                            role: widget.role,
                          )
                          : Signupscreen(
                            onToggle: toggleAuth,
                            key: ValueKey('signup'),
                            role: widget.role,
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
