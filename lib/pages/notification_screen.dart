import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../providers/notification_provider.dart';
import '../widget/MyAppbar.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    return ChangeNotifierProvider(
      create: (context) => NotificationProvider()..getAllNotifications(),
      child: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
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
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [getAppbar(), buildBody(notificationProvider)],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  getAppbar() {
    return const MyAppbar(
      title: "الاشعارات",
    );
  }

  buildBody(NotificationProvider notificationProvider) {
    return notificationProvider.notifications.isNotEmpty
        ? Expanded(
            child: ListView(
              children: List.generate(
                  notificationProvider.notifications.length,
                  (index) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        height: 85,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notificationProvider.notifications[index].title!,
                              style: Get.theme.textTheme.headline1!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              notificationProvider.notifications[index].body!,
                              style: Get.theme.textTheme.subtitle1!
                                  .copyWith(color: Colors.white , height: 1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [



                                Text(
                                  timeago.format(DateTime.parse(notificationProvider
                                      .notifications[index].createdAt!,) ,locale: 'ar'),
                                  style: Get.theme.textTheme.caption,
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
            ),
          )
        : const Expanded(
            child: Center(
            child: Text(
              'ليس لديك اشعارات الان',
              style: TextStyle(color: Colors.white),
            ),
          ));
  }


}
