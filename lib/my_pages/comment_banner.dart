import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../photo_view.dart';
import '../providers/page1provider.dart';
import '../values/colors.dart';
import '../values/models.dart';
import 'package:bamboo/values/constants.dart' as Constants;

// ignore: must_be_immutable
class CommentBannerPage extends StatelessWidget {
  CommentBanner commentBanner;
  CommentBannerPage({super.key, required this.commentBanner});

  @override
  Widget build(BuildContext context) {
    var provDil = Provider.of<Which_page>(context).dil;
    final imageUrl = provDil != 0 ? commentBanner.imageTm : commentBanner.imageRu;
    final title = provDil != 0 ? commentBanner.nameTm : commentBanner.nameRu;
    final content = provDil != 0 ? commentBanner.contentTm : commentBanner.contentRu;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // Modern AppBar with image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.zoom_in, color: AppColors.primary),
                  onPressed: () {
                    Constants.op_image = imageUrl;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PhotView()),
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'banner_${commentBanner.id}',
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
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
                    child: const Icon(Icons.image_not_supported, size: 60),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'GilroyBold',
                            color: Colors.black,
                            height: 1.3,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.restaurant,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Bambuk Restaurant',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Semi',
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.light_silver,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Content Section
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: Text(
                      content,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Monto',
                        color: Color(0xFF2D2D2D),
                        height: 1.7,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
