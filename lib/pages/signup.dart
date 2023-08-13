import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/pages/home.dart';
import 'package:quizapp/pages/otp_verification/otp_verification.dart';
import 'package:quizapp/providers/register_provider.dart';
import 'package:quizapp/utils/validators.dart';
import 'package:simnumber/sim_number.dart';
import 'package:simnumber/siminfo.dart';

import '../Model/SuccessModel.dart';
import '../Theme/color.dart';
import '../Theme/config.dart';
import '../common/constants/variables-methods.dart';
import '../common/helper_methods.dart';
import '../model/userModel.dart';
import '../providers/profile_provider.dart';
import '../providers/user_provider.dart';
import '../utils/constant.dart';
import '../widget/customTextField.dart';
import 'avatar_image.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController referalCodeController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<SuccessModel>? loginList;
  String countryCode = '+20';

  final loginuser = GetStorage();

  bool _isObscure = true;

  bool isChecked = true;

  UserModel? currentUser;
  bool uploadingImage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      currentUser =
          Provider.of<UserProvider>(context, listen: false).currentUser;
    });
    pickedFilePath = null;
    pickedAvatar = '';
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    phoneController.dispose();
    passController.dispose();
    userNameController.dispose();
    referalCodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "تسجيل حساب جديد",
                          style: TextStyle(
                              color: Colors.white, fontSize: 20, height: 2),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Get.height * .85,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/login_bg_white.png",
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Consumer<RegisterProvider>(
                      builder: (context, value, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  buildHeader(),
                                  SizedBox(
                                    height: size.height * 0.03,
                                  ),
                                  CustomTextField(
                                    hint: "اسم المستخدم",
                                    controller: userNameController,
                                    correctionHint: (val) {
                                      return Validators.validateName(val,
                                          text: "اسم المستخدم");
                                    },
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  CustomTextField(
                                    hint: "البريد الاكتروني",
                                    controller: emailController,
                                    // correctionHint: (val) {
                                    //   return Validators.validateEmail(val);
                                    // },
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  CustomTextField(
                                    controller: passController,
                                    password: _isObscure,
                                    suffixIcon: Icons.visibility,
                                    hint: 'كلمة السر',
                                    correctionHint: (val) {
                                      return Validators.validatePw(val);
                                    },
                                    maxLines: 1,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      alignment:
                                      AlignmentDirectional.centerStart,
                                      child: Text(
                                        'كلمة السر يجب ان تحتوي على حروف و ارقام انجليزي',
                                        style: Get.theme.textTheme.caption!
                                            .copyWith(color: Colors.grey),
                                      )),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
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
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  CustomTextField(
                                    controller: referalCodeController,
                                    hint: "كود الترشيح",
                                  ),
                                  SizedBox(
                                    height: size.height * 0.03,
                                  ),
                                  // #signup_button
                                  MaterialButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        if (value.canBack) {
                                          value
                                              .verifyPhone(countryCode+phoneController.text)
                                              .then(
                                                (value) => Get.to(
                                              OtpVerification(
                                                fromRegister: true,
                                                email: emailController.text,
                                                name: userNameController.text,
                                                pass: passController.text,
                                                phone: countryCode+phoneController.text,
                                                referral:
                                                referalCodeController
                                                    .text
                                                    .trim(),
                                              ),
                                            ),
                                          );
                                        } else {
                                          showErrorToast(
                                              'برجاء الانتظار 120 ثانية من طلبك السابق');
                                        }
                                      } else {
                                        showErrorToast(
                                            'برجاء مراجعه جميع البيانات');
                                      }
                                    },
                                    height: 45,
                                    minWidth:
                                    MediaQuery.of(context).size.width / 1.4,
                                    shape: const StadiumBorder(),
                                    color: Config().appColor,
                                    child: const Text(
                                      "تسجيل",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
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
                                                text: "لديك حساب بالفعل ",
                                                style: TextStyle(
                                                    color: Config().appaccentColor),
                                              ),
                                              TextSpan(
                                                  text: "تسجيل دخول",
                                                  style: TextStyle(
                                                      color: Config().appColor,
                                                      fontWeight: FontWeight.bold),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      Navigator.of(context).pop();
                                                    })
                                            ],
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.03,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildHeader() {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () async {
              AlertDialog alert = AlertDialog(
                backgroundColor: primary,
                content: SizedBox(
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          pickImage().then((image) async {
                            if (image != null) {
                              setState(() {});
                              Get.back();
                            }
                          });
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.camera,
                              ),
                              Text(
                                'اختيار صوره',
                                style: Get.textTheme.bodyText2!
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(const AvatarImages());
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(
                                Icons.image,
                              ),
                              Text(
                                'اختيار افاتار',
                                style: Get.textTheme.bodyText2!
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      pickedFilePath == null
                          ? pickedAvatar == ''
                          ? const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(
                            'assets/images/ic_user_default.png'),
                      )
                          : CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(pickedAvatar),
                      )
                          : CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(File(pickedFilePath!)),
                      ),
                    ]),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      child: Image.asset(
                        'assets/images/ic_camera.png',
                        height: 50,
                      ),
                    ),
                    if (uploadingImage)
                      const SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator())
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
