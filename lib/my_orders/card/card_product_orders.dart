import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:bamboo/values/colors.dart';

import '../../providers/page1provider.dart';
import '../../values/models.dart';

class CardProductOrders extends StatefulWidget {
  final List<order_items> product;
  final int index;
  const CardProductOrders(this.product, this.index, {super.key});

  @override
  _CardProductOrdersState createState() => _CardProductOrdersState();
}

class _CardProductOrdersState extends State<CardProductOrders> {
  @override
  Widget build(BuildContext context) {
    final dil = Provider.of<Which_page>(context).dil;
    final item = widget.product[widget.index];
    final isLast = widget.index == widget.product.length - 1;

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              imageUrl: item.image,
              errorWidget: (context, url, error) => Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(IconlyLight.image,
                    color: AppColors.primary, size: 28),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dil != 0 ? item.name_tm : item.name_ru,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontFamily: 'Semi', fontSize: 14, color: Colors.black),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.price} TMT',
                      style: const TextStyle(
                          fontFamily: 'Semi',
                          fontSize: 14,
                          color: AppColors.green),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '× ${item.count}',
                        style: const TextStyle(
                            fontFamily: 'Semi',
                            fontSize: 13,
                            color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
