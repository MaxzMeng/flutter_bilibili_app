import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/widget/appbar.dart';
import 'package:flutter_bilibili_app/widget/login_effect.dart';
import 'package:flutter_bilibili_app/widget/login_input.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback? onJumpToLogin;

  const RegistrationPage({Key? key, this.onJumpToLogin}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册", "登录", () {
        print('right button click');
      }),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              "用户名",
              "请输入用户名",
              onChanged: (text) {
                print(text);
              },
              focusChanged: (focus) {
                setState(() {
                  protect = false;
                });
              },
            ),
            LoginInput(
              "密码",
              "请输入密码",
              obscureText: true,
              onChanged: (text) {},
              focusChanged: (focus) {
                setState(() {
                  protect = true;
                });
              },
            ),
            LoginInput(
              "确认密码",
              "请再次输入密码",
              lineStretch: true,
              obscureText: true,
              onChanged: (text) {},
              focusChanged: (focus) {
                setState(() {
                  protect = true;
                });
              },
            ),
            LoginInput(
              "慕课网ID",
              "请输入你的慕课网用户ID",
              keyboardType: TextInputType.number,
              onChanged: (text) {},
              focusChanged: (focus) {
                setState(() {
                  protect = false;
                });
              },
            ),
            LoginInput(
              "课程订单号",
              "请输入课程订单号后四位",
              keyboardType: TextInputType.number,
              lineStretch: true,
              onChanged: (text) {},
              focusChanged: (focus) {
                setState(() {
                  protect = false;
                });
              },
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
