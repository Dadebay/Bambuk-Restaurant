import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;

import '../providers/page1provider.dart';
import '../providers/page1settings.dart';
import '../values/colors.dart';

class ContorlMyOrder extends StatefulWidget {
  const ContorlMyOrder({super.key});

  @override
  _ContorlMyOrderState createState() => _ContorlMyOrderState();
}

class _ContorlMyOrderState extends State<ContorlMyOrder> {
  static const _steps = [
    _StepData(
      tm: 'Sargyt barlan\u00fdar',
      ru: '\u0417\u0430\u043a\u0430\u0437 \u0432 \u043e\u0436\u0438\u0434\u0430\u043d\u0438\u0438',
      icon: IconlyBold.time_circle,
      color: Color(0xFFFF9800),
      minStatus: 1,
    ),
    _StepData(
      tm: 'Sargyt tassyklandy',
      ru: '\u0417\u0430\u043a\u0430\u0437 \u043f\u043e\u0434\u0442\u0432\u0435\u0440\u0436\u0434\u0435\u043d',
      icon: IconlyBold.tick_square,
      color: AppColors.primary,
      minStatus: 2,
    ),
    _StepData(
      tm: 'Sargyt ugradyldy',
      ru: '\u0417\u0430\u043a\u0430\u0437 \u0432 \u043f\u0443\u0442\u0438',
      icon: IconlyBold.send,
      color: Color(0xFF2196F3),
      minStatus: 3,
    ),
    _StepData(
      tm: 'Sargyt gow\u015furyldy',
      ru: '\u0417\u0430\u043a\u0430\u0437 \u0434\u043e\u0441\u0442\u0430\u0432\u043b\u0435\u043d',
      icon: IconlyBold.home,
      color: AppColors.green,
      minStatus: 4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (Provider.of<PageSettings>(context).page == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
    }
    final prov = Provider.of<Which_page>(context);
    final status = Constants.or_status;
    final isCancelled = status == 5;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Provider.of<PageSettings>(context, listen: false).set_page0();
            Navigator.pop(context);
          },
          icon: const Icon(IconlyLight.arrow_left, color: Colors.black),
        ),
        title: Text(
          Constants.ru_control_oder[prov.dil],
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontFamily: 'Semi'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEEEEEE)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _buildInfoCard(),
          const SizedBox(height: 16),
          _buildTimelineCard(prov.dil, status, isCancelled),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(IconlyLight.bag_2,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${Constants.ru_orderNo} #${Constants.or_track_code}',
                  style: const TextStyle(
                      fontFamily: 'Semi', fontSize: 15, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${Constants.or_total_price} TMT',
                style: const TextStyle(
                    fontFamily: 'Semi', fontSize: 15, color: AppColors.green),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(IconlyLight.profile,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Constants.name,
                      style: const TextStyle(
                          fontFamily: 'Semi',
                          fontSize: 14,
                          color: Colors.black)),
                  const SizedBox(height: 2),
                  Text(Constants.email,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.silver)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(int dil, int status, bool isCancelled) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: isCancelled
          ? _buildCancelledState(dil)
          : _buildNormalTimeline(dil, status),
    );
  }

  Widget _buildNormalTimeline(int dil, int status) {
    return Column(
      children: List.generate(_steps.length, (i) {
        final step = _steps[i];
        final active = status >= step.minStatus;
        final isCurrent = status == step.minStatus;
        final isLast = i == _steps.length - 1;
        return _buildStep(
          label: dil != 0 ? step.tm : step.ru,
          icon: step.icon,
          color: step.color,
          active: active,
          isCurrent: isCurrent,
          showConnector: !isLast,
        );
      }),
    );
  }

  Widget _buildCancelledState(int dil) {
    return Column(
      children: [
        _buildStep(
          label: dil != 0
              ? 'Sargyt barlan\u00fdar'
              : '\u0417\u0430\u043a\u0430\u0437 \u0432 \u043e\u0436\u0438\u0434\u0430\u043d\u0438\u0438',
          icon: IconlyBold.time_circle,
          color: const Color(0xFFFF9800),
          active: true,
          isCurrent: false,
          showConnector: true,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(IconlyBold.close_square,
                  size: 18, color: Colors.red),
            ),
            const SizedBox(width: 14),
            Padding(
              padding: const EdgeInsets.only(top: 9),
              child: Text(
                dil != 0
                    ? 'Sargyt \u00fdatyryldy'
                    : '\u0417\u0430\u043a\u0430\u0437 \u043e\u0442\u043c\u0435\u043d\u0435\u043d',
                style: const TextStyle(
                    fontFamily: 'Semi', fontSize: 14, color: Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep({
    required String label,
    required IconData icon,
    required Color color,
    required bool active,
    required bool isCurrent,
    required bool showConnector,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: active
                    ? color.withValues(alpha: 0.15)
                    : const Color(0xFFF0F0F0),
                shape: BoxShape.circle,
                border: isCurrent ? Border.all(color: color, width: 2) : null,
              ),
              child: Icon(icon,
                  size: 18, color: active ? color : Colors.grey.shade400),
            ),
            if (showConnector)
              Container(
                width: 2,
                height: 32,
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: active
                      ? color.withValues(alpha: 0.35)
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Padding(
          padding: const EdgeInsets.only(top: 9),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Semi',
              fontSize: 14,
              color: active ? Colors.black : Colors.grey.shade400,
            ),
          ),
        ),
      ],
    );
  }
}

class _StepData {
  final String tm;
  final String ru;
  final IconData icon;
  final Color color;
  final int minStatus;
  const _StepData(
      {required this.tm,
      required this.ru,
      required this.icon,
      required this.color,
      required this.minStatus});
}
