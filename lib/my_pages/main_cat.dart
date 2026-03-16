import 'package:bamboo/my_pages/categories.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../my_pages2/sub_cat.dart';
import '../values/models.dart';

class MainCat extends StatefulWidget {
  const MainCat({super.key});

  @override
  _MainCatState createState() => _MainCatState();
}

class _MainCatState extends State<MainCat> {
  List<categorys> child = [];
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Which_page>(context);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          topPartName(prov, context),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 14, bottom: 15),
                itemCount: Constants.category.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return _CategoryCard(
                    category: Constants.category[index],
                    index: index,
                    dil: prov.dil,
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget topPartName(Which_page prov, BuildContext context) {
    return Padding(
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
              IconlyBold.category,
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
                  Constants.ru_category[prov.dil],
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "GilroyBold",
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Constants.choose_what_you_need[prov.dil],
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Monto",
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Categories()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Constants.ru_show_all[prov.dil],
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: "Semi",
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    IconlyLight.arrow_right_2,
                    color: AppColors.primary,
                    size: 16,
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

// Resim Bazlı Modern Category Card Widget
class _CategoryCard extends StatelessWidget {
  final categorys category;
  final int index;
  final int dil;

  const _CategoryCard({
    required this.category,
    required this.index,
    required this.dil,
  });

  @override
  Widget build(BuildContext context) {
    final categoryName = dil == 1
        ? category.name_tm
        : dil == 0
            ? category.name_ru
            : category.name_en;

    return GestureDetector(
      onTap: () async {
        Constants.children = category.children;
        Constants.myCatID = category.id;
        Constants.myCatName = (dil != 0) ? category.name_tm : category.name_ru;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SubCat()),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Kategori Resmi - Arka Plan
              CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: category.image,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Image.asset(
                    logoImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Gradient Overlay - Alt kısımda koyu
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),

              // Üst köşede hafif overlay
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: const Icon(
                    IconlyLight.arrow_right_2,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),

              // Kategori Adı - Alt kısımda
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        categoryName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'GilroyBold',
                          height: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(0, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 30,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
