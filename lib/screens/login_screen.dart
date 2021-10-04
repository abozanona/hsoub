import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsoub/api/response_enums.dart';
import 'package:hsoub/classes/utils.dart';
import 'package:hsoub/classes/validation_mixin.dart';
import 'package:hsoub/screens/home_screen.dart';
import 'package:hsoub/themes/app_theme.dart';
import 'bloc/home_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc(),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (BuildContext context, HomeState state) {
          if (state is UserLoginErrorState) {
            setState(() {
              isLoading = false;
            });
            if (state.loginResult == LoginResult.loginException) {
              Utils.showToast("حدث خطأ غير متوقع أثناء محاولة تسجيل الدخول");
            } else if (state.loginResult == LoginResult.passwordError) {
              Utils.showToast("البريد الإلكتروني أو كلمة المرور غير صحيحة");
            } else {
              Utils.showToast("حدث خطأ غير متوقع أثناء محاولة تسجيل الدخول");
            }
          } else if (state is UserLoginState) {
            setState(() {
              isLoading = false;
            });
            Utils.showToast("تم تسجيل الدخول بنجاح");
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
          }
        },
        builder: (BuildContext context, HomeState state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                "تسجيل الدخول",
                style: AppTheme.textStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: formGlobalKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          height: 150,
                          child: Image.asset('assets/images/logo.png'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        enabled: !isLoading,
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'البريد الإلكتروني',
                          hintText: 'example@gmail.com',
                        ),
                        style: AppTheme.textStyle(),
                        validator: (email) {
                          if (isEmailValid(email ?? '')) {
                            return null;
                          } else {
                            return 'أدخل بريداً إلكترونياً صحيحاً';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: 0,
                      ),
                      child: TextFormField(
                        enabled: !isLoading,
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'كلمة المرور',
                        ),
                        style: AppTheme.textStyle(),
                        validator: (password) {
                          if (isPasswordValid(password ?? '')) {
                            return null;
                          } else {
                            return 'أدخل كلمة مرور صحيحة';
                          }
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              launch("https://accounts.hsoub.com/reset_password");
                            },
                      child: Text(
                        'نسيت كلمة المرور؟',
                        style: AppTheme.textStyle(
                          color: const Color(AppTheme.primary),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        color: const Color(AppTheme.primary),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (!formGlobalKey.currentState!.validate()) {
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          HomeBloc.get(context).add(UserLoginEvent(emailController.text, passwordController.text));
                        },
                        child: Text(
                          'تسجيل الدخول',
                          style: AppTheme.textStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 90,
                    ),
                    GestureDetector(
                      onTap: () {
                        launch("https://accounts.hsoub.com/register");
                      },
                      child: Text(
                        'مستخدم جديد? أنشئ حساباً',
                        style: AppTheme.textStyle(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
