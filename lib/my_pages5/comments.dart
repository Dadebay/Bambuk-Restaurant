import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../values/colors.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;

class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController mess = TextEditingController();
  List<String> messageBody = [];
  int k = 0;

  Future getTime() async {
    Map<String, String> header = {'Authorization': 'Bearer ${Constants.token}'};
    var response3 = await http.get(Uri.https(Constants.api, '/api/v1/users/me/comments/'), headers: header);
    var mitem = json.decode(utf8.decode(response3.bodyBytes))['data'];
    messageBody.clear();
    for (int i = 0; i < mitem.length; i++) {
      messageBody.add(mitem[i]['body']);
    }
    setState(() {
      k = 1;
    });
    return 0;
  }

  @override
  void initState() {
    super.initState();
    getTime();
  }

  Future<void> sending(String message, BuildContext context) async {
    //if (name=="")name=Constants.pname;
    try {
      if (message.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Maglumaty doly dolduryň?"),
        ));
      } else {
        var url = Uri.https(Constants.api, '/api/v1/comments');
        var token = Constants.token;
        Map<String, String> data = {
          "body": message,
        };
        Map<String, String> headers = {'Authorization': 'Bearer $token'};
        var req = http.MultipartRequest('POST', url)
          ..fields.addAll(data)
          ..headers.addAll(headers);
        var res = await req.send();
        if (res.statusCode == 201) {}
      }
    } catch (_) {
      rethrow;
    }
  }

  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = mess.text.trim();
    if (text.isEmpty) return;
    sending(text, context);
    setState(() {
      messageBody.add(text);
      mess.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dil = Provider.of<Which_page>(context).dil;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF6F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(IconlyLight.arrow_left_circle, color: Colors.black),
        ),
        title: Text(
          Constants.ru_ttt[dil],
          style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Semi'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEEEEEE)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(IconlyLight.info_circle, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      Constants.ru_ttt_subtitle[dil],
                      maxLines: 3,
                      style: TextStyle(color: AppColors.primary.withOpacity(0.85), fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            // Messages list
            Expanded(
              child: k == 0
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : messageBody.isEmpty
                      ? _buildEmptyState(dil)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          physics: const BouncingScrollPhysics(),
                          itemCount: messageBody.length,
                          itemBuilder: (context, index) => _buildBubble(messageBody[index]),
                        ),
            ),
            // Input bar
            _buildInputBar(dil),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(int dil) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(IconlyLight.chat, color: AppColors.primary, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            Constants.ru_ttt_empty[dil],
            style: const TextStyle(color: Colors.grey, fontSize: 15, fontFamily: 'Semi'),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.only(top: 8, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
        ),
      ),
    );
  }

  Widget _buildInputBar(int dil) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, -3)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7FA),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: mess,
                style: const TextStyle(color: Colors.black87, fontSize: 15),
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: Constants.ru_ttt_hint[dil],
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              height: 48,
              width: 48,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: const Icon(IconlyBold.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
