import 'package:bamboo/providers/bottom_prov.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

/// Bildirime basylanda (FCM ýa-da ýerli bildiris; aplikasiýa açyk, arka planda
/// ýa-da ýapyk bolsun) bottom-nav-daky Profil sahypasyna geçirýär.
///
/// Kök Navigator-yň üstündäki sahypalar (Get.to, dialog we ş.m.) ýapylýar,
/// şonuň üçin ulanyjy islendik ýerde bolsa-da Profil-i görýär.
/// Aplikasiýa ýapykka kök Navigator-da diňe Splash bar, onuň üçin
/// `popUntil(isFirst)` howpsuz.
void openProfileFromNotification([BuildContext? context]) {
  final BuildContext? ctx = context ?? Get.context;
  if (ctx == null || !ctx.mounted) return;

  Get.key.currentState?.popUntil((route) => route.isFirst);
  Provider.of<BottomProv>(ctx, listen: false).goToProfile();
}
