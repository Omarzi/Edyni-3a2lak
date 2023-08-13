import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../Model/SuccessModel.dart';
import '../Theme/config.dart';
import '../common/constants/variables-methods.dart';
import '../providers/forget_password_provider.dart';
import 'otp_verification/otp_verification.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String countryCode= '+20';
  List<SuccessModel>? loginList;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final loginuser = GetStorage();

  bool _isObscure = true;

  bool isChecked = true;

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
    ForgetPasswordProvider provider = Provider.of<ForgetPasswordProvider>(context,listen: false);
    return Scaffold(
      body: Container(
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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "نسيت كلمة المرور",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          height: 2,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "ادخل رقم الهاتف الخاص بك لإستعادة كلمة المرور خاصتك",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: Container(
                    color: Colors.white,
                    // decoration: const BoxDecoration(
                    //     image: DecorationImage(
                    //         image: AssetImage("assets/images/login_bg_white.png"),
                    //         fit: BoxFit.cover)),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: size.height * 0.02,
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

                          MaterialButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (provider.canBack) {
                                  provider
                                      .verifyPhone(countryCode+phoneController.text)
                                      .then(
                                        (_) => Get.to(
                                      OtpVerification(
                                        fromRegister: false,
                                        phone: countryCode+phoneController.text,
                                      ),
                                    ),
                                  );
                                } else {
                                  showErrorToast(
                                      'برجاء الانتظار 120 ثانية من طلبك السابق');
                                }
                              } else {
                                showErrorToast(
                                    'برجاء ادخال رقم الهاتف اولا');
                              }
                            },
                            height: 45,
                            minWidth: MediaQuery.of(context).size.width / 1.4,
                            shape: const StadiumBorder(),
                            color: Config().appColor,
                            child: const Text(
                              "ارسال",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
