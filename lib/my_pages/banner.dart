import 'package:bamboo/my_pages/comment_banner.dart';
import 'package:banner_image/banner_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bamboo/values/colors.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';

final list = [
  "assets/images/cafebar.png",
  "assets/images/cafebar.png",
  "assets/images/cafebar.png",
  "assets/images/cafebar.png",
];

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  @override
  Widget build(BuildContext context) {
    var provDil = Provider.of<Which_page>(context).dil;
    return BannerImage(
      aspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height) / 0.25,
      itemLength: (Constants.banner.isNotEmpty) ? Constants.banner.length : 2,
      selectedIndicatorColor: AppColors.appBar_back,
      borderRadius: BorderRadius.circular(16),
      autoPlay: true,
      onTap: (int index) {
        //
      },
      children: List.generate(
        (Constants.banner.isNotEmpty) ? Constants.banner.length : 2,
        (index) => CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: (Constants.banner.isNotEmpty)
              ? provDil == 1
                  ? Constants.banner[index].image
                  : provDil == 0
                      ? Constants.banner[index].imageRu
                      : Constants.banner[index].imageEn
              : 'https//images.logo',
          errorWidget: (context, url, error) => const Icon(Icons.local_dining),
        ),
      ),
    );
  }
}

class BannerScreen2 extends StatefulWidget {
  const BannerScreen2({super.key});

  @override
  State<BannerScreen2> createState() => _BannerScreen2State();
}

class _BannerScreen2State extends State<BannerScreen2> {
  @override
  Widget build(BuildContext context) {
    var provDil = Provider.of<Which_page>(context).dil;

    if (Constants.commentBanner.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.campaign_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Constants.announcements_title[provDil],
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "GilroyBold",
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Constants.announcements_subtitle[provDil],
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Monto",
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Banner Cards
          SizedBox(
            height: 200,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              itemCount: Constants.commentBanner.length,
              itemBuilder: (context, index) {
                final banner = Constants.commentBanner[index];
                final provDil = Provider.of<Which_page>(context).dil;
                final imageUrl = provDil != 0 ? banner.imageTm : banner.imageRu;
                final title = provDil != 0 ? banner.nameTm : banner.nameRu;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentBannerPage(commentBanner: banner),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Background Image
                        Hero(
                          tag: 'banner_${banner.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppColors.light_silver,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.light_silver,
                                child: const Center(
                                  child: Icon(Icons.image_not_supported, size: 40),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),

                        // Content
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'GilroyBold',
                                    height: 1.3,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black45,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            Constants.view_details[provDil],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontFamily: 'Semi',
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalBannerScreen extends StatefulWidget {
  const HorizontalBannerScreen({super.key});

  @override
  State<HorizontalBannerScreen> createState() => _HorizontalBannerScreenState();
}

class _HorizontalBannerScreenState extends State<HorizontalBannerScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BannerImage(
            padding: const EdgeInsets.only(),
            itemLength: list.length,
            // ignore: sort_child_properties_last
            children: List.generate(
              list.length,
              (index) => Image.asset(
                list[index],
                fit: BoxFit.cover,
              ),
            ),
            selectedIndicatorColor: Colors.red,
            autoPlay: true,
            scrollDirection: Axis.vertical,
          ),
          const SizedBox(height: 15),
          BannerImage(
            itemLength: list.length,
            // ignore: sort_child_properties_last
            children: List.generate(
              list.length,
              (index) => Image.asset(
                list[index],
                fit: BoxFit.cover,
              ),
            ),
            borderRadius: BorderRadius.circular(8),
            selectedIndicatorColor: Colors.blue,
            indicatorColor: Colors.green.shade100,
            scrollDirection: Axis.vertical,
          ),
          const SizedBox(height: 15),
          BannerImage(
            aspectRatio: 2,
            itemLength: list.length,
            borderRadius: BorderRadius.circular(8),
            // ignore: sort_child_properties_last
            children: List.generate(
              list.length,
              (index) => Image.asset(
                list[index],
                fit: BoxFit.cover,
              ),
            ),
            selectedIndicatorColor: Colors.red,
            scrollDirection: Axis.vertical,
          ),
          const SizedBox(height: 15),
          BannerImage(
            aspectRatio: 20 / 10,
            itemLength: list.length,
            borderRadius: BorderRadius.circular(8),
            // ignore: sort_child_properties_last
            children: List.generate(
              list.length,
              (index) => Image.asset(
                list[index],
                fit: BoxFit.cover,
              ),
            ),
            selectedIndicatorColor: Colors.red,
            scrollDirection: Axis.vertical,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: [
            BannerImage(
              aspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height),
              padding: const EdgeInsets.only(),
              itemLength: list.length,
              // ignore: sort_child_properties_last
              children: List.generate(
                list.length,
                (index) => Image.asset(
                  list[index],
                  fit: BoxFit.cover,
                ),
              ),
              selectedIndicatorColor: Colors.red,
              autoPlay: false,
              fit: BoxFit.scaleDown,
            ),
          ],
        ),
      ),
    );
  }
}
