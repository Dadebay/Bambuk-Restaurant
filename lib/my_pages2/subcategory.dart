import 'package:bamboo/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:bamboo/my_pages2/subcat_card.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import '../values/colors.dart';

class Subcategory extends StatefulWidget {
  const Subcategory({super.key});

  @override
  _SubcategoryState createState() => _SubcategoryState();
}

class _SubcategoryState extends State<Subcategory> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Navigator.canPop(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.appBar_back,
        appBar: PreferredSize(
          // ignore: sort_child_properties_last
          child: SafeArea(
            child: Container(
              height: 60,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: AppColors.appBar_back),
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      logoImage,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 55,
                          width: 55,
                          color: const Color.fromARGB(0, 255, 255, 255),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          preferredSize: const Size.fromHeight(100),
        ),
        body: Container(
          color: AppColors.background_color,
          child: (Constants.children != null)
              ? ListView.builder(
                  itemCount: Constants.children.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SubcatCard(
                      int.parse(Constants.children[index]['id'].toString()),
                      Constants.children[index]['name_tm'],
                      Constants.children[index]['name_ru'],
                      Constants.children[index]['image'],
                      Constants.children[index]['children'],
                    );
                  })
              : Container(),
        ),
      ),
    );
  }
}
