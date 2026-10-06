import 'dart:async';

import 'package:bamboo/DB/db.dart';
import 'package:bamboo/my_pages5/chat_message.dart';
import 'package:bamboo/my_pages5/chat_service.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Timer? _refreshTimer;
  bool _loading = true;
  bool _sending = false;
  String? _error;
  int? _customerId;
  List<ChatMessage> _messages = <ChatMessage>[];

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    _customerId = await _resolveCustomerId();
    await _loadMessages(initial: true);
    _refreshTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _loadMessages();
    });
  }

  Future<int?> _resolveCustomerId() async {
    final userData = await DatabaseHelper.getUser();
    if (userData.isNotEmpty) {
      final dynamic rawId = userData.first['productId'];
      if (rawId is int && rawId > 0) {
        return rawId;
      }

      if (rawId is String) {
        final parsed = int.tryParse(rawId);
        if (parsed != null && parsed > 0) {
          return parsed;
        }
      }
    }

    return null;
  }

  Future<void> _loadMessages({bool initial = false}) async {
    if (_customerId == null) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = constants.ru_chat_customer_id_error[Provider.of<Which_page>(context, listen: false).dil];
      });
      return;
    }

    if (initial && mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final data = await _chatService.getMessages(customerId: _customerId!);
      if (!mounted) return;
      setState(() {
        _messages = data;
        _error = null;
        _loading = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '${constants.ru_error_occurred[Provider.of<Which_page>(context, listen: false).dil]} $e';
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _sending || _customerId == null) return;

    setState(() {
      _sending = true;
    });

    try {
      final sent = await _chatService.sendMessage(text: text);
      if (!mounted) return;

      _messageController.clear();
      if (sent != null) {
        setState(() {
          _messages.add(sent);
        });
      }

      _scrollToBottom();
      await _loadMessages();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final dil = Provider.of<Which_page>(context).dil;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // Klavye açılınca son mesaja scroll et
    if (bottomInset > 0) {
      _scrollToBottom();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: _buildAppBar(dil),
      body: Column(
        children: [
          Expanded(child: _buildBody(dil)),
          _buildInputBar(dil),
          SizedBox(height: bottomInset),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(int dil) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(IconlyLight.arrow_left, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(constants.logoImage, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        constants.ru_chat[dil],
                        style: const TextStyle(
                          fontFamily: 'Semi',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2ECC71),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            'Bamboo Restaurant',
                            style: TextStyle(
                              fontFamily: 'GilroyRegular',
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(int dil) {
    if (_loading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 2.5,
            ),
            const SizedBox(height: 14),
            Text(
              '...',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontFamily: 'GilroyRegular',
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(IconlyLight.info_circle, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 14),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'GilroyRegular',
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => _loadMessages(initial: true),
                child: const Text(
                  'Retry',
                  style: TextStyle(color: AppColors.primary, fontFamily: 'Semi'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(IconlyLight.chat, size: 38, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              constants.ru_chat_empty[dil],
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Semi',
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '💬',
              style: TextStyle(fontSize: 28),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => _loadMessages(initial: true),
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(4, 4, 4, 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(IconlyLight.info_circle, color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    constants.ru_ttt_subtitle[dil],
                    maxLines: 5,
                    style: TextStyle(color: AppColors.primary.withOpacity(0.85), fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          if (_messages.isEmpty)
            _buildEmptyState(dil)
          else
            ...List.generate(_messages.length, (index) {
              final message = _messages[index];
              final bool isMine = message.senderType == 'customer';
              final bool showDate = index == 0 || !_isSameDay(_messages[index - 1].createdAt, message.createdAt);

              return Column(
                crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (showDate) _buildDateChip(message.createdAt),
                  _buildBubble(message, isMine),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _buildDateChip(DateTime? date) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
            ),
          ],
        ),
        child: Text(
          _formatDate(date),
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontFamily: 'GilroyRegular',
          ),
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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(IconlyLight.chat, size: 38, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            constants.ru_chat_empty[dil],
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Semi',
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '💬',
            style: TextStyle(fontSize: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(ChatMessage message, bool isMine) {
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: message.message));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kopyalandı'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 6, bottom: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Image.asset(constants.logoImage, fit: BoxFit.contain),
              ),
            ),
          ],
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            child: IntrinsicWidth(
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isMine ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMine ? 16 : 4),
                    bottomRight: Radius.circular(isMine ? 4 : 16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isMine ? AppColors.primary.withOpacity(0.25) : Colors.black.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.message,
                      style: TextStyle(
                        color: isMine ? Colors.white : Colors.black87,
                        fontSize: 14.5,
                        fontFamily: 'GilroyRegular',
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatTime(message.createdAt),
                            style: TextStyle(
                              color: isMine ? Colors.white.withOpacity(0.7) : Colors.grey.shade500,
                              fontSize: 10.5,
                              fontFamily: 'GilroyRegular',
                            ),
                          ),
                          if (isMine) ...[
                            const SizedBox(width: 3),
                            Icon(
                              Icons.done_all,
                              size: 13,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(int dil) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5F8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _messageController,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    style: const TextStyle(
                      fontFamily: 'GilroyRegular',
                      fontSize: 14.5,
                    ),
                    decoration: InputDecoration(
                      hintText: constants.ru_ttt_hint[dil],
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontFamily: 'GilroyRegular',
                        fontSize: 14,
                      ),
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _sending ? null : _sendMessage,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: _sending ? AppColors.primary.withOpacity(0.5) : AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(IconlyBold.send, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Bugün';
    if (d == yesterday) return 'Dün';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
