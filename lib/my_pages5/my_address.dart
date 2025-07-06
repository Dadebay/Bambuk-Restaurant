import 'package:bamboo/providers/favourite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;

import 'add_adress.dart';

class MyAddress extends StatefulWidget {
  const MyAddress({Key? key}) : super(key: key);

  @override
  _MyAddressState createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: SafeArea(
          child: Container(
            height: 60,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(color: AppColors.appBar_back),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    Constants.ru_address[Provider.of<Which_page>(context).dil],
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(left: 5, right: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.light_silver,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/back.svg',
                            color: Colors.black,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(100),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: ListView(
          children: [
            (Provider.of<Favourite>(context).address.length != 0)
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: Provider.of<Favourite>(context).address.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: SvgPicture.asset(
                                    'assets/images/location.svg',
                                    color: AppColors.primary,
                                    height: 20,
                                    width: 20,
                                    allowDrawingOutsideViewBox: true,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 20,
                                            top: 10,
                                            bottom: 10,
                                            right: 10),
                                        child: Text(
                                          Provider.of<Favourite>(context)
                                              .address[index]
                                              .name,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Semi'),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 20, bottom: 10, right: 10),
                                        child: Text(
                                          Provider.of<Favourite>(context)
                                              .address[index]
                                              .address_txt,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 0.5,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAddress()),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.only(top: 30),
                    // ignore: prefer_const_constructors
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                        border: Border.all(
                          width: 2,
                          color: Color.fromRGBO(243, 245, 247, 1),
                        )),
                    child: Image.asset(
                      "assets/images/plus.png",
                      color: Colors.black,
                      fit: BoxFit.none,
                      width: 12,
                      height: 12,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(Constants
                        .ru_addNew[Provider.of<Which_page>(context).dil]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
