import 'package:flutter/material.dart';
import 'package:flutter_bilibili_app/http/dao/login_dao.dart';
import 'package:flutter_bilibili_app/navigator/hi_navigator.dart';
import 'package:flutter_bilibili_app/util/string_util.dart';
import 'package:flutter_bilibili_app/util/toast_util.dart';
import 'package:flutter_bilibili_app/widget/appbar.dart';
import 'package:flutter_bilibili_app/widget/login_button.dart';
import 'package:flutter_bilibili_app/widget/login_effect.dart';
import 'package:flutter_bilibili_app/widget/login_input.dart';

class RegistrationPage extends StatefulWidget {

  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false;
  String? userName;
  String? password;
  String? rePassword;
  String? imoocId;
  String? orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册", "登录", (){
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      }),
      body: Container(
        child: ListView(
          //自适应键盘弹起，防止遮挡
          children: [
            LoginEffect(
              protect: protect,
            ),
            LoginInput(
              "用户名",
              "请输入用户名",
              onChanged: (text) {
                userName = text;
                checkInput();
              },
            ),
            LoginInput(
              "密码",
              "请输入密码",
              obscureText: true,
              onChanged: (text) {
                password = text;
                checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            LoginInput(
              "确认密码",
              "请再次输入密码",
              lineStretch: true,
              obscureText: true,
              onChanged: (text) {
                rePassword = text;
                checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            LoginInput(
              "慕课网ID",
              "请输入你的慕课网用户ID",
              keyboardType: TextInputType.number,
              onChanged: (text) {
                imoocId = text;
                checkInput();
              },
            ),
            LoginInput(
              "课程订单号",
              "请输入课程订单号后四位",
              keyboardType: TextInputType.number,
              lineStretch: true,
              onChanged: (text) {
                orderId = text;
                checkInput();
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton('注册',
                  enable: loginEnable, onPressed: checkParams),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(imoocId) &&
        isNotEmpty(orderId)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = '两次密码不一致';
    } else if (orderId?.length != 4) {
      tips = "请输入订单号的后四位";
    }
    if (tips != null) {
      print(tips);
      return;
    }
    send();
  }
  void send() async{
    try{
      var result = await LoginDao.registration(userName, password, imoocId, orderId);
      print(result);
      if(result['code']==0) {
        print('success');
        showToast('登录成功');
      }else {
        print(result['msg']);
        showWarnToast(result['msg']);
      }
    }catch (e){
      print(e);
    }
  }
}
