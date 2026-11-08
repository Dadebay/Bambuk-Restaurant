import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../DB/db.dart';
import '../providers/bottom_prov.dart';
import '../providers/page1provider.dart';
import '../values/colors.dart';
import '../values/constants.dart' as constants;

class UserInf extends StatefulWidget {
  const UserInf({super.key});

  @override
  _UserInfState createState() => _UserInfState();
}

class _UserInfState extends State<UserInf> {
  final TextEditingController regName1 =
      TextEditingController(text: constants.name1);
  final TextEditingController regSurname1 =
      TextEditingController(text: constants.name2);
  final TextEditingController regPhone1 =
      TextEditingController(text: constants.phone);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Which_page>(context);
    final bottomProv = Provider.of<BottomProv>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(IconlyLight.arrow_left_circle, color: Colors.black),
        ),
        title: Text(
          constants.ru_profil[prov.dil],
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontFamily: 'Semi'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEEEEEE)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          _buildAvatarSection(prov, bottomProv),
          const SizedBox(height: 20),
          _buildFieldsCard(prov),
          const SizedBox(height: 16),
          if (bottomProv.reg) _buildDeleteButton(context, bottomProv, prov),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(Which_page prov, BottomProv bottomProv) {
    final fullName = '${constants.name1} ${constants.name2}'.trim();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color.fromRGBO(97, 140, 20, 1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5), width: 2),
              ),
              child: const Icon(IconlyBold.profile,
                  color: Colors.white, size: 40)),
          const SizedBox(height: 12),
          if (fullName.isNotEmpty)
            Text(
              fullName,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: 'Semi'),
            ),
          const SizedBox(height: 4),
          if (constants.phone.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(IconlyLight.call, color: Colors.white70, size: 14),
                const SizedBox(width: 5),
                Text(
                  constants.phone,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(IconlyBold.star, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${constants.bonusMoney} TMT ${constants.bonus[prov.dil]}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 13, fontFamily: 'Semi'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldsCard(Which_page prov) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildField(
            icon: IconlyLight.profile,
            label: constants.ru_name[prov.dil],
            controller: regName1,
            isFirst: true,
          ),
          const Divider(height: 1, indent: 56, color: Color(0xFFF0F0F0)),
          _buildField(
            icon: IconlyLight.profile,
            label: constants.ru_surname[prov.dil],
            controller: regSurname1,
          ),
          const Divider(height: 1, indent: 56, color: Color(0xFFF0F0F0)),
          _buildField(
            icon: IconlyLight.call,
            label: '** ** ** **',
            controller: regPhone1,
            keyboardType: TextInputType.phone,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(16) : Radius.zero,
        bottom: isLast ? const Radius.circular(16) : Radius.zero,
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        style: const TextStyle(
            fontSize: 15, color: Colors.black87, fontFamily: 'GilroyMedium'),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 56, minHeight: 56),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          floatingLabelStyle:
              const TextStyle(color: AppColors.primary, fontSize: 12),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.fromLTRB(0, 18, 20, 14),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(
      BuildContext context, BottomProv bottomProv, Which_page prov) {
    return GestureDetector(
      onTap: () => _confirmDelete(context, bottomProv),
      child: Container(
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(IconlyLight.delete, color: Colors.red.shade600, size: 20),
            const SizedBox(width: 8),
            Text(
              constants.ru_delete[prov.dil],
              style: TextStyle(
                  fontFamily: 'Semi', fontSize: 14, color: Colors.red.shade600),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, BottomProv bottomProv) {
    final dil = Provider.of<Which_page>(context, listen: false).dil;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child:
                  Icon(IconlyBold.delete, color: Colors.red.shade500, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              constants.ru_delete[dil],
              style: const TextStyle(
                  fontFamily: 'Semi', fontSize: 17, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              constants.ru_irrev_warning[dil],
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F7FA),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(constants.ruCykmakNo[dil],
                          style: const TextStyle(
                              fontFamily: 'Semi',
                              fontSize: 15,
                              color: Colors.black87)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _handleDeleteAccount(context, bottomProv);
                    },
                    child: Container(
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(constants.ruCykmakYes[dil],
                          style: const TextStyle(
                              fontFamily: 'Semi',
                              fontSize: 15,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDeleteAccount(
      BuildContext context, BottomProv bottomProv) async {
    final headers = {'Authorization': 'Bearer ${constants.token}'};
    final url = Uri.https(constants.api, '/api/v1/users/me/destroy');

    final response = await http.delete(url, headers: headers);
    if (!mounted) return;
    if (response.statusCode == 204) {
      DatabaseHelper.deleteUserAll();
      setState(() {
        constants.phone = '';
        constants.token = '';
        constants.name = '';
        constants.name1 = '';
        constants.name2 = '';
        constants.email = '';
        regName1.text = constants.name1;
        regSurname1.text = constants.name2;
        regPhone1.text = constants.phone;
      });
      bottomProv.set_reg(false);
      final dil = Provider.of<Which_page>(context, listen: false).dil;
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(constants.ru_acc_deleted[dil])));
    } else {
      final dil = Provider.of<Which_page>(context, listen: false).dil;
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(constants.ru_acc_delete_error[dil])));
    }
  }
}
