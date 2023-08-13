import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/common/constants/end_points.dart';
import 'package:quizapp/common/constants/variables-methods.dart';
import 'package:quizapp/providers/user_provider.dart';
import 'package:quizapp/widget/customTextField.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../common/helpers/dio_helper.dart';
import '../utils/constant.dart';
import '../widget/myappbar.dart';
import '../widget/show_loading.dart';

class Instrucation extends StatefulWidget {
  const Instrucation({Key? key}) : super(key: key);

  @override
  _InstrucationState createState() => _InstrucationState();
}

class _InstrucationState extends State<Instrucation> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [getAppbar(), buildBody()],
            ),
          ),
        ),
      ),
    );
  }

  getAppbar() {
    return const MyAppbar(
      title: "رايك يهمنا",
    );
  }

  TextEditingController controller = TextEditingController();

  buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextField(
            hint: 'رايك',
            controller: controller,
            maxLines: 20,
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () async {
              UserProvider userProvider =
                  Provider.of<UserProvider>(context, listen: false);

              try {
                showLoading();
                Map<String, dynamic> res = await DioHelper().postData(
                  feedbacks,
                  data: {
                    "poster_id": userProvider.currentUser!.sId!,
                    "post": controller.text.trim()
                  },
                );
                hideLoading();
                log(res.toString());
                if (res['success'] == true) {
                  controller.clear();
                  showSuccessToast('تم ارسال رايك بنجاح');
                  setState(() {});
                }
              } catch (error) {
                hideLoading();
                debugMessage(error.toString());
                showErrorToast(error.toString());
              }
            },
            child: Text(
              'مشاركة رايك معنا',
              style: getx.Get.theme.textTheme.subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
          )
        ],
      ),
    );
  }
}
