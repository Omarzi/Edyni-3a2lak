import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/login.dart';
import 'package:quizapp/Pages/signup.dart';
import 'package:quizapp/common/constants/variables-methods.dart';
import 'package:quizapp/common/helper_methods.dart';
import 'package:quizapp/providers/forget_password_provider.dart';
import 'package:quizapp/providers/profile_provider.dart';
import 'package:quizapp/providers/register_provider.dart';
import 'package:quizapp/widget/show_loading.dart';
import '../../Theme/config.dart';
import 'dart:io';

import '../set_new_password.dart';

class OtpVerification extends StatefulWidget {
  final String? pass,name,email,phone;
  final String? referral;
  final bool fromRegister;
  const OtpVerification({Key? key, this.name,required this.fromRegister, this.pass, this.email,required this.phone, this.referral}) : super(key: key);

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  TextEditingController pinController = TextEditingController();
  GlobalKey<FormState> formKey =  GlobalKey<FormState>();

  final loginuser = GetStorage();

  bool _isObscure = true;

  bool isChecked = true;

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  final focusedPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(

      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  final submittedPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: const Color.fromRGBO(234, 239, 243, 1),
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    ),
  );




  @override
  void initState() {
    if(widget.fromRegister)
    {

      RegisterProvider registerProvider = Provider.of<RegisterProvider>(context,listen: false);
      registerProvider.startTimer();
    }else
    {

      ForgetPasswordProvider forgetPasswordProvider = Provider.of<ForgetPasswordProvider>(context,listen: false);
      forgetPasswordProvider.startTimer();
    }
    super.initState();

  }

  @override
  void dispose() {
    if(widget.fromRegister)
    {

      RegisterProvider registerProvider = Provider.of<RegisterProvider>(context,listen: false);
      registerProvider.timer.cancel();
    }else
    {
      ForgetPasswordProvider forgetPasswordProvider = Provider.of<ForgetPasswordProvider>(context,listen: false);
      forgetPasswordProvider.timer.cancel();
    }
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    RegisterProvider registerProvider = Provider.of<RegisterProvider>(context);
    ForgetPasswordProvider forgetPasswordProvider = Provider.of<ForgetPasswordProvider>(context);

    return Scaffold(
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
                      onPressed: () {

                        if(widget.fromRegister)
                        {
                          if(registerProvider.canBack) {
                            Navigator.of(context).pop();
                          }
                        }else
                        {
                          if(forgetPasswordProvider.canBack) {
                            Navigator.of(context).pop();
                          }
                        }

                      },
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "تاكيد رقم الهاتف",
                        style:
                        TextStyle(color: Colors.white, fontSize: 20, height: 2),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/login_bg_white.png"),
                            fit: BoxFit.fill)),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 30),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("تاكيد رقم الهاتف",style: Get.theme.textTheme.headline6!.copyWith(color: Colors.black),),
                              const SizedBox(height: 30,),

                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Pinput(
                                  defaultPinTheme: defaultPinTheme,
                                  focusedPinTheme: focusedPinTheme,
                                  submittedPinTheme: submittedPinTheme,
                                  length: 6,
                                  keyboardType: TextInputType.number,
                                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                                  showCursor: true,
                                  onCompleted: (pin) {
                                    if(widget.fromRegister)
                                      registerProvider.verifyOTP(pin);
                                    else
                                      forgetPasswordProvider.verifyOTP(pin);
                                  },
                                ),
                              ),

                              const SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if(widget.fromRegister)
                                    Text(registerProvider.percent.toString()+' ثوانى'),
                                  if(!widget.fromRegister)
                                    Text(forgetPasswordProvider.percent.toString()+' ثوانى'),

                                  const SizedBox(width: 10,),
                                  MaterialButton(
                                    onPressed: (){
                                      if(widget.fromRegister)
                                      {
                                        if(registerProvider.canBack)
                                        {
                                          registerProvider.verifyPhone(widget.phone!);
                                          registerProvider.timer.cancel();
                                          registerProvider.startTimer();
                                        }else
                                        {
                                          showErrorToast('برجاء الانتظار حتي انتهاء المده');
                                        }
                                      }else
                                      {
                                        if(forgetPasswordProvider.canBack)
                                        {
                                          forgetPasswordProvider.verifyPhone(widget.phone!);
                                          forgetPasswordProvider.timer.cancel();
                                          forgetPasswordProvider.startTimer();
                                        }else
                                        {
                                          showErrorToast('برجاء الانتظار حتي انتهاء المده');
                                        }
                                      }
                                    },
                                    height: 45,
                                    minWidth:70,
                                    shape: const StadiumBorder(),
                                    color: Config().appColor,
                                    child: const Text(
                                      "اعد ارسال الكود",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15,),
                              // #OtpVerification_button
                              MaterialButton(
                                onPressed: () {
                                  if(formKey.currentState!.validate())
                                  {

                                    if(widget.fromRegister)
                                    {
                                      if(registerProvider.verified) {
                                        registerProvider.createUser(
                                            name: widget.name!,
                                            phone: widget.phone!,
                                            password:widget.pass !,
                                            referral: widget.referral,
                                            email: widget.email).then((value) async {
                                          if(registerProvider.accountCreated)
                                          {
                                            ProfileProvider profile = Provider.of<ProfileProvider>(context,listen: false);

                                            if(pickedFilePath!=null)
                                            {
                                              showLoading();
                                              String imageUrl = await uploadImage(await File(pickedFilePath!).readAsBytes());
                                              await profile.updateProfileImage(userId: registerProvider.userId, imgLink: imageUrl);
                                              hideLoading();
                                            }

                                            if(pickedAvatar != '')
                                            {
                                              showLoading();
                                              await profile.updateProfileImage(userId: registerProvider.userId, imgLink: pickedAvatar);
                                              hideLoading();
                                            }

                                            Get.off(const Login());
                                          }else{
                                            Get.off(const SignUp());
                                          }
                                        });
                                      } else {
                                        Fluttertoast.showToast(msg: 'برجاء ادخال الكود الصحيح',backgroundColor: Colors.red) ;
                                      }
                                    }else
                                    {
                                      if(forgetPasswordProvider.verified) {
                                        Get.off(SetNewPassword(phone: widget.phone!));
                                      } else {
                                        Fluttertoast.showToast(msg: 'برجاء ادخال الكود الصحيح',backgroundColor: Colors.red) ;
                                      }
                                    }
                                  }
                                },
                                height: 45,
                                minWidth: MediaQuery.of(context).size.width / 1.4,
                                shape: const StadiumBorder(),
                                color: Config().appColor,
                                child: const Text(
                                  "تاكيد",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
