import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:bamboo/values/constants.dart' as Constants;

class PhotView extends StatelessWidget {
  const PhotView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            child: PhotoView(imageProvider: NetworkImage(Constants.op_image))),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 55,
            width: 55,
            margin: EdgeInsets.only(top: 40, left: 20),
            color: Color.fromARGB(0, 255, 255, 255),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
