import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:bamboo/my_orders/about_products.dart';
import 'package:bamboo/my_orders/contorl_my_order.dart';
import 'package:bamboo/values/colors.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/models.dart';

import '../../providers/page1provider.dart';

class CardOrders extends StatefulWidget {
  final List<orders> product;
  final int index;
  const CardOrders(this.product, this.index, {super.key});

  @override
  _CardOrdersState createState() => _CardOrdersState();
}

class _CardOrdersState extends State<CardOrders> {
  // status label & color
  _StatusInfo _getStatus(int id, int dil) {
    final labels = {
      1: ['Sargyt barlanýar', 'Заказ в ожидании'],
      2: ['Sargyt tassyklandy', 'Заказ подтвержден'],
      3: ['Sargyt ugradyldy', 'Заказ в пути'],
      4: ['Sargyt gowşuryldy', 'Заказ доставлен'],
      5: ['Sargyt ýatyryldy', 'Заказ отменен'],
    };
    final colors = {
      1: const Color(0xFFFF9800),
      2: AppColors.primary,
      3: const Color(0xFF2196F3),
      4: AppColors.green,
      5: Colors.red,
    };
    final label = labels[id] ?? ['', ''];
    return _StatusInfo(
      text: dil != 0 ? label[0] : label[1],
      color: colors[id] ?? Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Which_page>(context);
    final card = widget.product[widget.index];
    final status = _getStatus(card.status_id, prov.dil);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(IconlyLight.bag_2,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${Constants.ru_orderNo[prov.dil]} #${card.order_no}',
                        style: const TextStyle(
                            fontFamily: 'Semi',
                            fontSize: 14,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(IconlyLight.time_circle,
                              size: 13, color: AppColors.silver),
                          const SizedBox(width: 4),
                          Text(
                            card.date.toString(),
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.silver),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '${card.total_price} TMT',
                  style: const TextStyle(
                      fontFamily: 'GilroyBold',
                      fontSize: 18,
                      color: AppColors.primary),
                ),
              ],
            ),
          ),
          // Status pill
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: status.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.text,
                  style: TextStyle(
                      fontSize: 12, fontFamily: 'Semi', color: status.color),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Divider
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          // Action buttons
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: Constants.ru_inform[prov.dil],
                    icon: IconlyLight.document,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AboutProducts(
                            widget.product[widget.index].my_products),
                      ));
                    },
                  ),
                ),
                const VerticalDivider(width: 1, color: Color(0xFFF0F0F0)),
                Expanded(
                  child: _ActionButton(
                    label: Constants.ru_control_oder[prov.dil],
                    icon: IconlyLight.activity,
                    isPrimary: true,
                    onTap: () {
                      Constants.or_status = card.status_id;
                      Constants.or_track_code = card.order_no;
                      Constants.or_total_price = card.total_price;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const ContorlMyOrder(),
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusInfo {
  final String text;
  final Color color;
  _StatusInfo({required this.text, required this.color});
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;
  const _ActionButton(
      {required this.label,
      required this.icon,
      required this.onTap,
      this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: isPrimary ? AppColors.primary : Colors.grey.shade500),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Semi',
                color: isPrimary ? AppColors.primary : Colors.grey.shade600,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
