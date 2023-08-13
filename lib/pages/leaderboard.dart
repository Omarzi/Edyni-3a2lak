import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Theme/color.dart';
import 'package:quizapp/common/constants/variables-methods.dart';
import 'package:quizapp/providers/user_provider.dart';

import '../providers/leaderboard_provider.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LeaderboardProvider()..getLeaderBoard(),
      child: Consumer<LeaderboardProvider>(
        builder: (context, leaderboardProvider, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: appBgColor,
              body: SingleChildScrollView(
                  child: leaderboardProvider.leaderBoardUsers.isNotEmpty
                      ? Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                children: [
                                  Container(
                                    height: 400,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/dash_bg.png"),
                                      fit: BoxFit.cover,
                                    )),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 15),
                                        if(leaderboardProvider.leaderBoardUsers.length>1)
                                        Expanded(
                                          child: SizedBox(
                                            height: 400,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 80),
                                                Text(
                                                  "#2",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),

                                                CircleAvatar(
                                                  radius: 40,
                                                  backgroundImage: CachedNetworkImageProvider(leaderboardProvider.leaderBoardUsers[1].image!),
                                                ),
                                                Center(
                                                  child: Text(
                                                    leaderboardProvider.leaderBoardUsers[1].name!,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      child: Image.asset(
                                                          "assets/images/ic_icons.png"),
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    Text(
                                                      leaderboardProvider.leaderBoardUsers[1].points.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 400,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 10),
                                                Image.asset(
                                                  "assets/images/ic_user_top.png",
                                                  width: 60,
                                                ),
                                                CircleAvatar(
                                                  radius: 60,
                                                  backgroundImage: CachedNetworkImageProvider(leaderboardProvider.leaderBoardUsers[0].image!),
                                                ),
                                                Center(
                                                  child: Text(
                                                    leaderboardProvider.leaderBoardUsers[0].name??"Sahil Patelasdasdssdsd",
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      child: Image.asset(
                                                          "assets/images/ic_icons.png"),
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    Text(
                                                      leaderboardProvider.leaderBoardUsers[0].points.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        if(leaderboardProvider.leaderBoardUsers.length>2)
                                        Expanded(
                                          child: SizedBox(
                                            height: 400,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 80),
                                                Text(
                                                  "#3",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: CachedNetworkImageProvider(leaderboardProvider.leaderBoardUsers[2].image!),
                                                ),
                                                Center(
                                                  child: Text(
                                                    leaderboardProvider.leaderBoardUsers[2].name??"Arjun Sharma",
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      child: Image.asset(
                                                          "assets/images/ic_icons.png"),
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    Text(
                                                      leaderboardProvider.leaderBoardUsers[2].points.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            getAppbar(),
                            if(leaderboardProvider.leaderBoardUsers.length>3)
                            buildBody(leaderboardProvider),
                            getBottom(context)
                          ],
                        )
                      : Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/dash_bg.png"),
                                    fit: BoxFit.cover,
                                  )),

                            ),

                          ],
                        ),
                      ),
                      getAppbar(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                             Center(child: Text('عفوا لا يوجد متصدرين'),)
                          ],
                        ),
                      ),

                    ],
                  )
              ),
            ),
          );
        },
      ),
    );
  }

  getAppbar() {
    return AppBar(
      title: const Text(
        "المتصدرين",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  buildBody(LeaderboardProvider leaderboardProvider) {
    return Positioned.fill(
      top: 350,
      bottom: 80,
      left: 0,
      right: 0,
      child: Stack(children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          height: MediaQuery.of(context).size.height,
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 10),
            itemCount: min(leaderboardProvider.leaderBoardUsers.length-3,17),
            itemBuilder: (context, index) {
              int currentIndex= index+3;
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Text((currentIndex+1).toString(),
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 16)),
                    const SizedBox(width: 15),
                     CircleAvatar(
                        minRadius: 25,
                        backgroundColor: Colors.transparent,
                        backgroundImage:CachedNetworkImageProvider(leaderboardProvider.leaderBoardUsers[currentIndex].image!)),
                    const SizedBox(width: 10),
                     Text(
                      leaderboardProvider.leaderBoardUsers[currentIndex].name??"Arjun Patel",
                      style: TextStyle(color: black),
                    ),
                    const Spacer(),
                    SizedBox(
                      child: Image.asset("assets/images/ic_icons.png"),
                      height: 30,
                      width: 30,
                    ),
                    Text(
                      leaderboardProvider.leaderBoardUsers[currentIndex].points.toString(),
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(height: 1, thickness: 1),
              );
            },
          ),
        ),
      ]),
    );
  }

  getBottom(context) {
    UserProvider  userProvider = Provider.of(context,listen: false);
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: leaderSelect,
              border: Border.all(color: appColor),
              borderRadius: const BorderRadius.all(Radius.circular(40))),
          height: 60,
          child: Row(
            children: [
              const SizedBox(width: 15),

               CircleAvatar(
                  minRadius: 25,
                  backgroundColor: Colors.transparent,
                    backgroundImage:CachedNetworkImageProvider(userProvider.currentUser!.image!)),
              const SizedBox(width: 10),
               Text(userProvider.currentUser!.name??"Arjun Patel"),
              const Spacer(),
              SizedBox(
                child: Image.asset("assets/images/ic_icons.png"),
                height: 30,
                width: 30,
              ),
              Text(
                userProvider.currentUser!.points.toString(),
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
      ),
    );
  }
}
