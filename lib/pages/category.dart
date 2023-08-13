import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/Pages/level.dart';
import 'package:quizapp/common/constants/end_points.dart';
import 'package:quizapp/providers/categories_provider.dart';
import 'package:quizapp/widget/myappbar.dart';
import 'package:quizapp/widget/myimage.dart';
import 'package:quizapp/widget/mytext.dart';

import '../Theme/color.dart';
import '../model/categorymodel.dart';

class Category extends StatefulWidget {
  final bool normalCat;
  const Category({Key? key, required this.normalCat}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}



class _CategoryState extends State<Category> {

  @override
  void initState() {
    CategoriesProvider categoriesProvider = Provider.of<CategoriesProvider>(context,listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await categoriesProvider.getAllCategories(competitionCat: widget.normalCat?null:competitionCategories,normalCat: widget.normalCat?allCategories:null);
    });
  }
  @override
  Widget build(BuildContext context) {
    CategoriesProvider categoriesProvider = Provider.of<CategoriesProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: MyAppbar(
              title: "الاقسام",

            ),
          ),
          body: SafeArea(
            child: buildBody(categoriesProvider.currentCategories),
          ),
        ),
      ),
    );
  }

  getAppbar() {
    return const MyAppbar(
      title: "Category",
    );
  }

  buildBody( List<CategoryModel>? categories) {
    return Consumer<CategoriesProvider>(
      builder: (context, categoriesProvider, child) {
        if(categories==null)
          {
            return  const Center(child: CircularProgressIndicator());
          }
        else if(categories.isEmpty) {
          return  Center(child: Text('لا يوجد اقسام' , style: Get.theme.textTheme.subtitle2!
              .copyWith(color: Colors.white),));
        } else {
          return Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: GridView.builder(
                padding: EdgeInsets.zero, // set padding to zero
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: categories.length,
                itemBuilder: (BuildContext ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>  Level(categoryId: categories[index].sId!,categoryName: categories[index].category!,normalLevels:widget.normalCat)));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyImage(
                              width: 80,
                              height: 80,
                              imageUrl: categories[index].image!,),
                          const SizedBox(
                            height: 10,
                          ),
                          MyText(
                              title: categories[index].category,
                              size: 16,
                              fontWeight: FontWeight.bold,
                              colors: textColor),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                            ),
                          ]),
                    ),
                  );
                }),
          );
        }
      },
    );
  }
}
