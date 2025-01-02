import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../DB/db.dart';
import '../providers/bottom_prov.dart';
import '../providers/page1provider.dart';
import '../values/colors.dart';
import '../values/constants.dart' as Constants;

class UserInf extends StatefulWidget {
  const UserInf({super.key});

  @override
  _UserInfState createState() => _UserInfState();
}

class _UserInfState extends State<UserInf> {
  final TextEditingController regName1 = TextEditingController(text: Constants.name1);
  final TextEditingController regMoney = TextEditingController(text: '${Constants.bonusMoney} TMT');
  final TextEditingController regSurname1 = TextEditingController(text: Constants.name2);
  final TextEditingController regEmail1 = TextEditingController(text: Constants.email);
  final TextEditingController regPhone1 = TextEditingController(text: Constants.phone);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Which_page>(context);
    final bottomProv = Provider.of<BottomProv>(context);

    return Scaffold(
      body: Stack(
        children: [
          _buildForm(context, prov, bottomProv),
          _buildBackButton(context),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, Which_page prov, BottomProv bottomProv) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 35),
      child: ListView(
        children: [
          const SizedBox(height: 60),
          _buildProfileImage(),
          const SizedBox(height: 20),
          _buildTextField(
            controller: regName1,
            labelText: Constants.ru_name[prov.dil],
            icon: Icons.person,
          ),
          const SizedBox(height: 30),
          _buildTextField(
            controller: regSurname1,
            labelText: Constants.ru_surname[prov.dil],
            icon: Icons.person,
          ),
          Visibility(
            visible: false,
            child: _buildTextField(
              controller: regEmail1,
              labelText: 'Email',
              icon: Icons.email,
            ),
          ),
          const SizedBox(height: 30),
          _buildTextField(
            controller: regPhone1,
            labelText: '** ** ** **',
            icon: Icons.phone,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 30),
          _buildTextField(
            controller: regMoney,
            labelText: Constants.bonus[prov.dil],
            readOnly: true,
          ),
          const SizedBox(height: 30),
          if (bottomProv.reg) _buildDeleteButton(context, bottomProv),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: AppColors.silver,
          borderRadius: BorderRadius.circular(75),
        ),
        child: Image.asset('assets/images/profil.png', fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? icon,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.primary),
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
        labelText: labelText,
        contentPadding: const EdgeInsets.only(left: 25, right: 20, bottom: 20, top: 20),
        labelStyle: const TextStyle(color: AppColors.primary),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppColors.primary), borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25)), borderRadius: BorderRadius.circular(20)),
        hintStyle: const TextStyle(
          fontSize: 14.0,
          fontFamily: "WorkSansLight",
          color: Color.fromRGBO(0, 0, 0, 0.25),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, BottomProv bottomProv) {
    return GestureDetector(
      onTap: () => _handleDeleteAccount(context, bottomProv),
      child: Container(
        height: 60,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          Constants.ru_delete[Provider.of<Which_page>(context).dil],
          style: const TextStyle(fontFamily: 'Semi', color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _handleDeleteAccount(BuildContext context, BottomProv bottomProv) async {
    final headers = {'Authorization': 'Bearer ${Constants.token}'};
    final url = Uri.https(Constants.api, '/api/v1/users/me/destroy');

    final response = await http.delete(url, headers: headers);
    if (response.statusCode == 204) {
      DatabaseHelper.deleteUserAll();
      setState(() {
        Constants.phone = '';
        Constants.token = '';
        Constants.name = '';
        Constants.name1 = '';
        Constants.name2 = '';
        Constants.email = '';
        regName1.text = Constants.name1;
        regSurname1.text = Constants.name2;
        regEmail1.text = Constants.email;
        regPhone1.text = Constants.phone;
      });
      bottomProv.set_reg(false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Siz ulgamdan çykdyňyz!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ýalňyşlyk ýüze çykdy täzeden synanyşyň!")));
    }
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 40,
      left: 10,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
    );
  }
}
// import 'package:bamboo/providers/page1provider.dart';
// import 'package:bamboo/values/colors.dart';
// // ignore: library_prefixes
// import 'package:bamboo/values/constants.dart' as Constants;
// import 'package:bamboo/values/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';

// import '../DB/db.dart';
// import '../providers/bottom_prov.dart';

// class UserInf extends StatefulWidget {
//   const UserInf({super.key});

//   @override
//   _UserInfState createState() => _UserInfState();
// }

// class _UserInfState extends State<UserInf> {
//   TextEditingController regName1 = TextEditingController(text: Constants.name1);
//   TextEditingController regMoney = TextEditingController(text: '${Constants.bonusMoney} TMT');
//   TextEditingController regSurname1 = TextEditingController(text: Constants.name2);
//   TextEditingController regEmail1 = TextEditingController(text: Constants.email);
//   TextEditingController regPhone1 = TextEditingController(text: Constants.phone);
//   @override
//   Widget build(BuildContext context) {
//     var prov = Provider.of<Which_page>(context);

//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             alignment: Alignment.center,
//             margin: const EdgeInsets.only(left: 35, right: 35),
//             child: Center(
//               child: ListView(
//                 children: [
//                   Container(
//                     alignment: Alignment.center,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         const SizedBox(
//                           height: 60,
//                         ),
//                         Container(
//                           alignment: Alignment.center,
//                           child: Container(
//                             height: 100,
//                             width: 100,
//                             alignment: Alignment.center,
//                             padding: const EdgeInsets.only(right: 5),
//                             decoration: BoxDecoration(
//                               color: AppColors.silver,
//                               borderRadius: BorderRadius.circular(75),
//                             ),
//                             child: Image.asset(
//                               'assets/images/profil.png',
//                               fit: BoxFit.contain,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         TextFormField(
//                           controller: regName1,
//                           style: const TextStyle(color: AppColors.primary),
//                           keyboardType: TextInputType.text,
//                           decoration: InputDecoration(
//                               prefixIcon: const Icon(
//                                 Icons.person,
//                                 color: AppColors.primary,
//                               ),
//                               labelStyle: const TextStyle(color: AppColors.primary),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                     color: AppColors.primary,
//                                   ),
//                                   borderRadius: BorderRadius.circular(30)),
//                               enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25)), borderRadius: BorderRadius.circular(30)),
//                               hintStyle: const TextStyle(
//                                 inherit: true,
//                                 fontSize: 14.0,
//                                 fontFamily: gilroyMedium,
//                                 color: Color.fromRGBO(0, 0, 0, 0.25),
//                               ),
//                               labelText: Constants.ru_name[prov.dil]),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         TextFormField(
//                           controller: regSurname1,
//                           style: const TextStyle(color: AppColors.primary),
//                           keyboardType: TextInputType.text,
//                           decoration: InputDecoration(
//                               prefixIcon: const Icon(
//                                 Icons.person,
//                                 color: AppColors.primary,
//                               ),
//                               labelStyle: const TextStyle(color: AppColors.primary),
//                               focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
//                               enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
//                               hintStyle: const TextStyle(
//                                 inherit: true,
//                                 fontSize: 14.0,
//                                 fontFamily: "WorkSansLight",
//                                 color: Color.fromRGBO(0, 0, 0, 0.25),
//                               ),
//                               hintText: Constants.ru_surname[prov.dil]),
//                         ),
//                         Visibility(
//                           visible: false,
//                           child: TextFormField(
//                             controller: regEmail1,
//                             style: const TextStyle(color: AppColors.primary),
//                             keyboardType: TextInputType.text,
//                             decoration: const InputDecoration(
//                                 prefixIcon: Icon(
//                                   Icons.person,
//                                   color: AppColors.primary,
//                                 ),
//                                 labelStyle: TextStyle(color: AppColors.primary),
//                                 focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
//                                 enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
//                                 hintStyle: TextStyle(
//                                   inherit: true,
//                                   fontSize: 14.0,
//                                   fontFamily: "WorkSansLight",
//                                   color: Color.fromRGBO(0, 0, 0, 0.25),
//                                 ),
//                                 hintText: 'Email'),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         TextFormField(
//                           controller: regPhone1,
//                           style: const TextStyle(color: AppColors.primary),
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                               // ignore: prefer_const_constructors
//                               prefixIcon: Icon(
//                                 Icons.phone,
//                                 color: AppColors.primary,
//                               ),
//                               labelStyle: TextStyle(color: AppColors.primary),
//                               focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
//                               enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
//                               hintStyle: TextStyle(
//                                 inherit: true,
//                                 fontSize: 14.0,
//                                 fontFamily: "WorkSansLight",
//                                 color: Color.fromRGBO(0, 0, 0, 0.25),
//                               ),
//                               hintText: '** ** ** **'),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         TextFormField(
//                           controller: regMoney,
//                           readOnly: true,
//                           style: const TextStyle(color: AppColors.primary),
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                               // ignore: prefer_const_constructors

//                               labelStyle: TextStyle(color: AppColors.primary),
//                               focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
//                               enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
//                               hintStyle: TextStyle(
//                                 inherit: true,
//                                 fontSize: 14.0,
//                                 fontFamily: "WorkSansLight",
//                                 color: Color.fromRGBO(0, 0, 0, 0.25),
//                               ),
//                               hintText: '** ** ** **'),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             (Provider.of<BottomProv>(context).reg)
//                                 ? GestureDetector(
//                                     onTap: (() async {
//                                       Map<String, String> header = {'Authorization': 'Bearer ${Constants.token}'};
//                                       var url = Uri.https(Constants.api, '/api/v1/users/me/destroy');
//                                       var response = await http.delete(url, headers: header);
//                                       if (response.statusCode == 204) {
//                                         DatabaseHelper.deleteUserAll();
//                                         setState(() {
//                                           Constants.phone = '';
//                                           Constants.token = '';
//                                           Constants.name = '';
//                                           Constants.name1 = '';
//                                           Constants.name2 = '';
//                                           Constants.email = '';
//                                           regName1 = TextEditingController(text: Constants.name1);
//                                           regSurname1 = TextEditingController(text: Constants.name2);
//                                           regEmail1 = TextEditingController(text: Constants.email);
//                                           regPhone1 = TextEditingController(text: Constants.phone);
//                                         });
//                                         Provider.of<BottomProv>(context, listen: false).set_reg(false);
//                                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                                           content: Text("Siz ulgamdan çykdyňyz!"),
//                                         ));
//                                       } else {
//                                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                                           content: Text("Ýalňyşlyk ýüze çykdy täzeden synanyşyň!"),
//                                         ));
//                                       }
//                                     }),
//                                     child: Container(
//                                       alignment: Alignment.bottomCenter,
//                                       child: Container(
//                                         height: 60,
//                                         padding: const EdgeInsets.only(left: 20, right: 20),
//                                         alignment: Alignment.center,
//                                         margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
//                                         decoration: BoxDecoration(
//                                           color: Colors.red,
//                                           borderRadius: BorderRadius.circular(10),
//                                         ),
//                                         child: Text(
//                                           Constants.ru_delete[Provider.of<Which_page>(context).dil],
//                                           style: const TextStyle(fontFamily: 'Semi', color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 : Container(),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     height: 55,
//                     width: 55,
//                     margin: const EdgeInsets.only(top: 40, left: 10),
//                     color: const Color.fromARGB(0, 255, 255, 255),
//                     child: const Icon(
//                       Icons.arrow_back_ios,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
