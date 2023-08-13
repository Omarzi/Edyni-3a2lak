import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/common/constants/variables-methods.dart';
import 'package:quizapp/common/helper_methods.dart';
import 'package:quizapp/model/userModel.dart';
import 'package:quizapp/providers/user_provider.dart';
import 'package:quizapp/providers/profile_provider.dart';
import 'package:quizapp/widget/myText.dart';
import 'package:quizapp/widget/myappbar.dart';

import '../utils/constant.dart';
import 'avatar_image.dart';

bool topBar = false;

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserModel? currentUser;
  TextEditingController _username= TextEditingController();
  TextEditingController _phone= TextEditingController();
  TextEditingController _email= TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {

    super.initState();
  }

  bool first = true;

  bool uploadingImage = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if(first)
      {
        first= false;
        currentUser = Provider.of<UserProvider>(context).currentUser!;
        _username.text = currentUser!.name??'username';
        _email.text = currentUser!.email??'email@example.com';
        _phone.text = currentUser!.phone??'01156345656';
      }
    return buildProfile();
  }



  buildProfile() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: appBgColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/dash_bg.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(50.0, 50.0)),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getAppbar(),
                    buildHeader(),
                  ],
                ),
              ]),
              buildData(),
            ],
          ),
        ),
      ),
    );
  }



  getAppbar() {
    return const MyAppbar(title: "تعديل الصفحة الشخصية");
  }



  buildHeader() {

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: ()async{

              AlertDialog alert =  AlertDialog(
                backgroundColor: primary,
                content: SizedBox(
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (){
                          pickImage().then((image) async {
                            Future.delayed(const Duration(seconds: 1)).then((value) {debugMessage(image.toString());});
                            debugMessage(image.toString());
                            if(image!=null)
                            {
                              uploadingImage=true;
                              setState(() {
                              });
                              String imageUrl =  await uploadImage(image);

                              if(imageUrl!=''&& currentUser!=null&&currentUser!.sId!=null)
                              {
                                await profileProvider.updateProfileImage(userId: currentUser!.sId!, imgLink: imageUrl);
                                await Provider.of<UserProvider>(context,listen: false).refreshUserData();
                                Get.back();
                                uploadingImage=false;
                                setState(() {});
                              }

                            }
                          });
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white24
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.camera ,),

                              Text('اختيار صوره' , style: Get.textTheme.bodyText2!.copyWith(color: Colors.white),),
                            ],
                          ),
                        ),
                      ),


                      InkWell(
                        onTap: (){
                          Get.to(const AvatarImages());
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white24
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.image ,),
                              Text('اختيار افاتار' , style: Get.textTheme.bodyText2!.copyWith(color: Colors.white),),
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
              alignment: Alignment.center,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const SizedBox(height: 10),
                  currentUser!.image==null||currentUser!.image==''?const CircleAvatar(
                    radius: 60,
                    backgroundImage:AssetImage('assets/images/ic_user_default.png'),
                  ):
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:CachedNetworkImageProvider(Provider.of<UserProvider>(context).currentUser!.image!),

                  ),
                  const SizedBox(height: 10),
                ]),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      child: Image.asset(
                        'assets/images/ic_camera.png',
                        height: 70,
                      ),),
                    if(uploadingImage)
                    const SizedBox(width:50,height:50,child: CircularProgressIndicator())
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  buildData() {

    return Consumer<ProfileProvider>(
      builder:(context, profileProvider, child) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                MyText(
                    title: "اسم المستخدم",
                    size: 16,
                    fontWeight: FontWeight.w500,
                    colors: black),
                const SizedBox(height: 5),
                TextField(
                  controller: _username,
                  // style: Get.theme.textTheme.subtitle2,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/ic_profile_user.png',
                          height: 10,
                          width: 10,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      hintText: "اسم المستخدم",
                      fillColor: Colors.white70),
                ),
//  Email ID
                const SizedBox(height: 15),
                MyText(
                    title: "البريد الالكتروني",
                    size: 16,
                    fontWeight: FontWeight.w500,
                    colors: black),
                const SizedBox(height: 5),
                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/ic_profile_email.png',
                          height: 10,
                          width: 10,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      hintText: "البريد الالكتروني",
                      fillColor: Colors.white70),
                ),

                // Contact No.

                const SizedBox(height: 15),
                MyText(
                    title: "رقم الهاتف",
                    size: 16,
                    fontWeight: FontWeight.w500,
                    colors: black),
                const SizedBox(height: 5),
                TextField(
                  controller: _phone,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/ic_profile_contact.png',
                          height: 10,
                          width: 10,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      hintText: "رقم الهاتف",
                      fillColor: Colors.white70),
                ),

                // Address
                const SizedBox(height: 40),
                Center(
                  child: TextButton(
                      onPressed: () async {
                        String userID = Provider.of<UserProvider>(context,listen: false).currentUser!.sId!;

                       bool success = await  profileProvider.updateProfileData(username: _username.text.trim(), phone: _phone.text.trim(), email: _email.text.trim(), userId: userID);
                       if(success)
                         {
                           await Provider.of<UserProvider>(context,listen: false).refreshUserData();
                         }
                      },
                      style: ButtonStyle(
                          minimumSize:
                          MaterialStateProperty.all(const Size(200, 50)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28.0))),
                          backgroundColor: MaterialStateProperty.all(appColor)),
                      child: MyText(
                        title: ' حفظ ',
                        size: 18,
                        fontWeight: FontWeight.w500,
                        colors: white,
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
