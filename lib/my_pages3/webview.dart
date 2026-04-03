import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/bottom_prov.dart';
import '../values/colors.dart';

class BlocView extends StatefulWidget {
  final String address;
  const BlocView({
    super.key,
    required this.address,
  });

  @override
  State<BlocView> createState() => _BlocViewState();
}

class _BlocViewState extends State<BlocView> {
  // late InAppWebViewController _webViewController;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            Provider.of<BottomProv>(context, listen: false).setPage(0);
            Navigator.pop(context);
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
      ),
    );
  }
}
