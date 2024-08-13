import 'package:coco_ai_assistant/COMPONENTS/alert_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/image_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/loading_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/textfield_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/firebase.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:coco_ai_assistant/VIEWS/home.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  DataMaster dm;
  SignUp({super.key, required this.dm});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  void onSignIn() async {
    final _email = _emailController.text;
    final _password = _passwordController.text;
    if (_email.isEmpty || _password.isEmpty) {
      setState(() {
        widget.dm.setToggleAlert(true);
        widget.dm.setAlertTitle("Missing Info");
        widget.dm.setAlertText('Please provide a valid email and password.');
      });
      return;
    }

    setState(() {
      widget.dm.setToggleLoading(true);
    });

    final user = await auth_SignIn(_email, _password);
    if (user != null) {
      setState(() {
        widget.dm.setUserId(user.uid);
        widget.dm.setToggleLoading(false);
      });
      nav_Push(context, Home(dm: widget.dm));
    } else {
      setState(() {
        widget.dm.setToggleAlert(true);
        widget.dm.setAlertTitle("Not Found");
        widget.dm.setAlertText(
            'We could not find your account. Re-enter your credentials or create a new account using these credentials.');
        widget.dm.setToggleLoading(false);
        widget.dm.setAlertButtons([
          ButtonView(
              paddingLeft: 18,
              paddingRight: 18,
              paddingTop: 10,
              paddingBottom: 10,
              radius: 100,
              backgroundColor: hexToColor("#3490F3"),
              child: const TextView(
                text: 'create account',
                size: 18,
                color: Colors.white,
                font: 'inconsolata',
              ),
              onPress: () {
                onCreateAccount();
              })
        ]);
      });
    }
  }

  void onCreateAccount() async {
    setState(() {
      widget.dm.setToggleLoading(true);
      widget.dm.setToggleAlert(false);
    });

    final user =
        await auth_CreateUser(_emailController.text, _passwordController.text);
    setState(() {
      widget.dm.setUserId(user!.uid);
      widget.dm.setToggleLoading(false);
    });
    nav_PushAndRemove(context, Home(dm: widget.dm));
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PaddingView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const TextView(
                  text: 'hello, my name is coco!',
                  size: 24,
                  color: Colors.white,
                  font: 'inconsolata',
                  weight: FontWeight.w700,
                  isTypewriter: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Center(
                    child: ImageView(
                  imagePath: 'assets/coco-smile.gif',
                  width: 300,
                  height: 300,
                )),
                const SizedBox(
                  height: 12,
                ),
                const TextView(
                  text:
                      'It looks like you are not signed in. Enter your login details to get started!',
                  size: 20,
                  color: Colors.white,
                  font: 'inconsolata',
                  isTypewriter: true,
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PaddingView(
                        paddingLeft: 0,
                        paddingRight: 0,
                        child: TextView(
                          text: 'log in',
                          size: 40,
                          color: Colors.white,
                          font: 'inconsolata',
                          weight: FontWeight.w700,
                        ),
                      ),
                      Column(
                        children: [
                          BorderView(
                            bottom: true,
                            bottomColor: Colors.white,
                            child: TextfieldView(
                              controller: _emailController,
                              placeholder: 'email',
                              size: 20,
                              color: Colors.white,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          BorderView(
                            bottom: true,
                            bottomColor: Colors.white,
                            child: TextfieldView(
                              controller: _passwordController,
                              isPassword: true,
                              placeholder: 'password',
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ButtonView(
                                  child: const Row(
                                    children: [
                                      TextView(
                                        text: 'log in',
                                        size: 24,
                                        color: Colors.white,
                                        font: 'inconsolata',
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 26,
                                      )
                                    ],
                                  ),
                                  onPress: () {
                                    onSignIn();
                                  })
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          // ABSOLUTE
          if (widget.dm.toggleAlert)
            AlertView(
                title: widget.dm.alertTitle,
                message: widget.dm.alertText,
                actions: [
                  ButtonView(
                    child: const TextView(
                      text: 'Close',
                      wrap: false,
                    ),
                    onPress: () {
                      setState(() {
                        widget.dm.setToggleAlert(false);
                      });
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ...widget.dm.alertButtons
                ]),
          if (widget.dm.toggleLoading) const LoadingView()
        ],
      ),
    );
  }
}
