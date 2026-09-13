import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Restoranyň telefon belgisi.
const String restaurantPhone = '+99363334994';

/// Jaň etmek. Öňki kodda `launch("tel://...")` ulanylýardy:
///   * `launch` köne API, ýalňyşlygy ýuwudýar - düwme "işlänok" bolup görünýär;
///   * `tel://` nädogry görnüş, dogrusy `tel:`;
///   * iOS simulýatorynda Telefon programmasy asla ýok, şonuň üçin ol ýerde
///     jaň hiç haçan açylmaz - ulanyja belgini görkezmek galýar.
Future<void> callRestaurant(BuildContext context) async {
  final Uri uri = Uri(scheme: 'tel', path: restaurantPhone);
  try {
    final bool ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (ok) return;
  } catch (_) {
    // aşakda habar berilýär
  }
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20),
      content: Text(restaurantPhone),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {},
      ),
    ),
  );
}
