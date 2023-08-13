import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/pages/login.dart';
import '../Model/SuccessModel.dart';
import '../Theme/config.dart';
import '../common/constants/variables-methods.dart';
import '../providers/forget_password_provider.dart';
import '../utils/validators.dart';
import '../widget/customTextField.dart';
import 'otp_verification/otp_verification.dart';

class SetNewPassword extends StatefulWidget {
  final String phone;

  const SetNewPassword({Key? key, required this.phone}) : super(key: key);

  @override
  _SetNewPasswordState createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  TextEditingController conPassController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String countryCode = '+20';
  List<SuccessModel>? loginList;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final loginuser = GetStorage();

  bool _isObscure = true;
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ForgetPasswordProvider provider =
        Provider.of<ForgetPasswordProvider>(context, listen: false);
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
                      "كلمة المرور الجديدة",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          height: 2,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "برجاء ادخال كلمة المرور الجديدة لاستعادة حسابك ",
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
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: conPassController,
                            password: _isObscure,
                            suffixIcon: Icons.visibility,
                            hint: 'تاكيد كلمة السر',
                            correctionHint: (val) {
                              return Validators.validatePw(val);
                            },
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                if (passController.text ==
                                    conPassController.text) {
                                  await provider.forgetPassword(
                                      phone: widget.phone,
                                      pass: passController.text);
                                } else {
                                  showErrorToast('كلمة المرور غير متطابقة');
                                }
                              } else {
                                showErrorToast('برجاء ادخال كلمة المرور اولا');
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
