import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/providers/avatar_provider.dart';
import 'package:quizapp/widget/show_loading.dart';
import '../Theme/color.dart';
import '../common/helper_methods.dart';
import '../model/userModel.dart';
import '../providers/profile_provider.dart';
import '../providers/user_provider.dart';
import '../utils/constant.dart';

class AvatarImages extends StatefulWidget {
  const AvatarImages({Key? key}) : super(key: key);

  @override
  State<AvatarImages> createState() => _AvatarImagesState();
}

class _AvatarImagesState extends State<AvatarImages> {
  bool uploadingAvatar = false;
  UserModel? currentUser;

  @override
  Widget build(BuildContext context) {

    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context , listen: false);
    currentUser = Provider.of<UserProvider>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'اختار افاتار',
          style: GoogleFonts.poppins(
              color: white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: primary,
      ),
      backgroundColor: appBgColor,
      body: Consumer<AvatarProvider>(
        builder: (context, avatarProvider, child) => Container(
          width: Get.width,
          height: Get.height,
          color: appBgColor,
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: List.generate(
              avatarProvider.imageLink.length,
                  (index) => InkWell(
                    onTap: () async {

                      //debugMessage(currentUser!.sId.toString());

                        if(currentUser!=null&&currentUser!.sId!=null)
                        {
                          showLoading();
                          await profileProvider.updateProfileImage(userId: currentUser!.sId!, imgLink: avatarProvider.imageLink[index]);
                          await Provider.of<UserProvider>(context,listen: false).refreshUserData();
                          hideLoading();
                          Get.back();
                          Get.back();
                          uploadingAvatar=false;
                          setState(() {});
                        }else
                          {
                            updatePickedAvatar(avatarProvider.imageLink[index]);
                            Get.back();
                            Get.back();
                            setState(() {});
                            profileProvider.setStateManual();
                          }

                    },
                    child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.5),
                    image:  DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          avatarProvider.imageLink[index],
                        )),
                ),
              ),
                  ),
            ),
          ),
        ),

      ),
    );
  }
}
