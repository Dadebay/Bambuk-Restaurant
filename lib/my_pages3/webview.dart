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
        body: Stack(
          children: [
            const Column(
              children: [
                // Expanded(
                //   child: Stack(children: [
                //     InAppWebView(
                //       initialUrlRequest: URLRequest(url: Uri.parse(widget.address)),
                //       initialOptions: InAppWebViewGroupOptions(
                //         crossPlatform: InAppWebViewOptions(
                //           useShouldOverrideUrlLoading: true,
                //           javaScriptCanOpenWindowsAutomatically: true,
                //         ),
                //       ),
                //       onWebViewCreated: (controller) {
                //         _webViewController = controller;
                //       },
                //       onProgressChanged: (controller, progress) {
                //         setState(() {
                //           this.progress = progress / 100;
                //         });
                //       },
                //     ),
                //     progress < 1.0
                //         ? Center(
                //             child: CircularProgressIndicator(
                //             value: progress,
                //             color: const Color.fromARGB(255, 14, 155, 226),
                //             strokeWidth: 2,
                //           ))
                //         : Container(),
                //   ]),
                // ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Provider.of<BottomProv>(context, listen: false).set_page0();
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
