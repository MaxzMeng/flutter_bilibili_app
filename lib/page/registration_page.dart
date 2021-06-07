import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/widget/login_input.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback? onJumpToLogin;

  const RegistrationPage({Key? key, this.onJumpToLogin}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            LoginInput(
              "用户名",
              "请输入用户名",
              onChanged: (text) {
                print(text);
              },
            ),
            LoginInput(
              "密码",
              "请输入密码",
              obscureText: true,
              onChanged: (text) {},
              focusChanged: (focus) {},
            ),
            LoginInput(
              "确认密码",
              "请再次输入密码",
              lineStretch: true,
              obscureText: true,
              onChanged: (text) {},
              focusChanged: (focus) {},
            ),
            LoginInput(
              "慕课网ID",
              "请输入你的慕课网用户ID",
              keyboardType: TextInputType.number,
              onChanged: (text) {},
            ),
            LoginInput(
              "课程订单号",
              "请输入课程订单号后四位",
              keyboardType: TextInputType.number,
              lineStretch: true,
              onChanged: (text) {},
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            )
          ],
        ),
      ),
    );
  }
}
