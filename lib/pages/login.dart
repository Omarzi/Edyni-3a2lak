import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/home.dart';
import 'package:quizapp/Pages/forgotpass.dart';
import 'package:quizapp/Pages/signup.dart';
import 'package:quizapp/common/constants/variables-methods.dart';
import 'package:quizapp/providers/user_provider.dart';
import 'package:quizapp/widget/customTextField.dart';
import 'package:quizapp/widget/show_loading.dart';
import '../Model/SuccessModel.dart';
import '../Theme/config.dart';
import '../utils/constant.dart';
import '../utils/validators.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String countryCode = '+20';

  List<SuccessModel>? loginList;

  final loginuser = GetStorage();

  bool _isObscure = true;
  bool isChecked = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(getToken()!=null)
        {

          showLoading();
          UserProvider loginProvider = Provider.of<UserProvider>(context,listen: false);
          bool success = await loginProvider.refreshUserData();
          hideLoading();
          if(success) {
            Get.offAll(const Home());
          }
        }

    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    phoneController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                  )),
              Expanded(
                flex: 10,
                child: ClipRRect(
                    borderRadius:const BorderRadius.only(topLeft: Radius.circular(8) , topRight: Radius.circular(8)),
                  child: Container(
                     margin: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage("assets/images/login_bg_white.png"),
                            fit: BoxFit.cover),
                    ),
                    child: Consumer<UserProvider>(
                      builder: (context, loginProvider, child) {
                        return Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Container(
                               margin: const EdgeInsets.only(top: 40),
                                width:150,
                                height : 150 ,

                                decoration: const BoxDecoration(
                                  //color: Colors.yellow,
                                  shape: BoxShape.circle,
                                    image: DecorationImage(

                                        image: AssetImage("assets/images/logo.png" ),
                                        fit: BoxFit.cover)),
                              ),
                              SizedBox(height: 40,),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                width: double.infinity,

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IntlPhoneField(
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(20)),
                                        contentPadding: const EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(20)),
                                        hintStyle:
                                        const TextStyle(color: Colors.grey),
                                        hintText: 'رقم الهاتف',
                                      ),
                                      initialCountryCode: 'EG',
                                      textAlign: TextAlign.start,
                                      controller: phoneController,
                                      pickerDialogStyle: PickerDialogStyle(
                                        backgroundColor: Colors.white,
                                        searchFieldInputDecoration:
                                        InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                          contentPadding: const EdgeInsets.all(10),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                          hintStyle: const TextStyle(color: Colors.grey),
                                          hintText: 'بحث',
                                        ),
                                      ),
                                      onChanged: (phone) {
                                        countryCode = phone.countryCode;
                                        print(countryCode+phoneController.text);
                                      },
                                    ),
                                    Divider(
                                      thickness: 0.5,
                                      height: size.height * 0.01,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    CustomTextField(
                                      controller: passController,
                                      password: _isObscure,
                                      suffixIcon: Icons.visibility,
                                      hint: 'كلمة السر',
                                      correctionHint: (val){
                                        return Validators.validatePw(val);
                                      },
                                      maxLines: 1,
                                    ),
                                    Divider(
                                      thickness: 0.5,
                                      height: size.height * 0.01,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.03,
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: (() {
                                          debugPrint('Test');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                  const ForgotPass()));
                                        }),
                                        child: const Text(
                                          "نسيت كلمة السر ؟",
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              // #signup_button
                              MaterialButton(
                                onPressed: () async {
                                  if(formKey.currentState!.validate()){
                                        await loginProvider.login(phone:countryCode+phoneController.text.trim(), pass: passController.text);
                                        // log((loginProvider.currentUser!=null).toString());
                                        // log((loginProvider.currentUser!.active!).toString());

                                        if(loginProvider.currentUser!=null&&loginProvider.currentUser!.active!){
                                          debugMessage(getToken().toString());
                                         Get.offAll(const Home());
                                        }else
                                          {
                                            showErrorToast('حدث خطأ ما , برجاء المحاوله مره اخري');
                                          }

                                  }
                                },
                                height: 45,
                                minWidth: MediaQuery.of(context).size.width / 1.4,
                                shape: const StadiumBorder(),
                                color: Config().appColor,
                                child: const Text(
                                  "دخول",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),

                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 5),
                                child: GestureDetector(
                                  onTap: (() {
                                    debugPrint('Test');
                                  }),
                                  child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "ليس لديك حساب ؟ ",
                                            style:
                                            TextStyle(color: Config().appaccentColor),
                                          ),
                                          TextSpan(
                                              text: "حساب جديد",
                                              style: TextStyle(
                                                  color: Config().appColor,
                                                  fontWeight: FontWeight.bold),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  debugPrint("Click");
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                        const SignUp()),
                                                  );
                                                })
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
