import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/login.dart';
import 'package:quizapp/common/helpers/dio_helper.dart';
import 'package:quizapp/providers/avatar_provider.dart';
import 'package:quizapp/providers/categories_provider.dart';
import 'package:quizapp/providers/forget_password_provider.dart';
import 'package:quizapp/providers/levels_provider.dart';
import 'package:quizapp/providers/rate_app_provider.dart';
import 'package:quizapp/providers/user_provider.dart';
import 'package:quizapp/providers/profile_provider.dart';
import 'package:quizapp/providers/questions_provider.dart';
import 'package:quizapp/providers/register_provider.dart';
import 'package:quizapp/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/onboaring.dart';
import 'Theme/theme_model.dart';
import 'common/push_notification.dart';
import 'firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


bool? isviewed;
final GlobalKey<NavigatorState> navigatorKey =  GlobalKey<NavigatorState>();

Future<void> backgroundHandler(RemoteMessage message) async {
  NotificationService.display(message);
  print(message.data.toString());
  print(message.notification!.title);

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MobileAds.instance.initialize();
  await GetStorage.init();
  await FirebaseMessaging.instance.getInitialMessage();
  await NotificationService.initialize();
  FirebaseMessaging.instance.subscribeToTopic("allDevices");
  FirebaseMessaging.onMessage.listen((message) {
    print('i am message');
    if (message.notification != null) {
      print(message.notification!.body);
      print(message.notification!.title);
    } else {
      print(message);
    }
    NotificationService.display(message);
  });
// on app breckgroud
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    NotificationService.display(message);

  });
// App Backgroud
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);


  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = (prefs.getBool('seen') ?? false);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegisterProvider(),),
        ChangeNotifierProvider(create: (context) => ForgetPasswordProvider(),),
        ChangeNotifierProvider(create: (context) => UserProvider(),),
        ChangeNotifierProvider(create: (context) => ProfileProvider(),),
        ChangeNotifierProvider(create: (context) => CategoriesProvider(),),
        ChangeNotifierProvider(create: (context) => LevelsProvider(),),
        ChangeNotifierProvider(create: (context) => QuestionsProvider(),),
        ChangeNotifierProvider(create: (context) => RateAppProvider(),),
        ChangeNotifierProvider(create: (context) => AvatarProvider()..getAvatarLinks()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'home',
        locale: const Locale('ar'),
        home: isviewed != true ? const OnBoardingPage() : const Login(),
        theme: ThemeModel().darkMode, // Provide light theme.
        darkTheme: ThemeModel().darkMode,
      ),
    );
  }
}
