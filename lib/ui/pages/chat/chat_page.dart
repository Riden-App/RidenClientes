import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/scheduler.dart';
import 'package:ride_usuario/models/response/chat_response.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/services/socket_service.dart';
import 'package:intl/intl.dart';

import '../../../themes/themes.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final SocketService socketService = SocketService();

  final List<DataChats> messages = [];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  PreferenciasUsuario prefs = PreferenciasUsuario();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      socketService.sendChatMessage(
        prefs.detailTripResponse.data.roomId,
        _controller.text.trim(),
      );

      _controller.clear();

      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    socketService.connectToSocket();

    socketService.onNewMessage = (data) {
      setState(() {
        messages.add(DataChats.fromJson(data));
      });
      prefs.roomID = data['room_id'];
      _scrollToBottom();
    };
    getChatMessages();
  }

  void getChatMessages() async {
    print('ingreso al chat');
    final result =
        await socketService.getChatsRoom(prefs.detailTripResponse.data.roomId);
    if (result.isSuccess) {
      print('valores del chat ${result.data!.data.length}');
      setState(() {
        messages.addAll(result.data!.data.reversed.toList());
      });
      _scrollToBottom();
    }
  }

  String formatTime(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime).toLocal();
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            const SizedBox(height: 14),
            _buildHeader(context),
            const SizedBox(height: 20),
            const Text(
              'Hoy',
              style: TextStyle(
                color: AppColors.black50,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            _buildMessageList(),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
          ),
          const Expanded(
            child: Text(
              'Chat con conductor',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.black03,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return _buildMessageItem(messages[index]);
        },
      ),
    );
  }

  Widget _buildMessageItem(DataChats message) {
    final formatterDate = formatTime(message.createdAt.toString());
    print('Formatter Date: $formatterDate');
    return ListTile(
      title: Align(
        alignment: message.senderId == prefs.detailTripResponse.data.userId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            color: message.senderId == prefs.detailTripResponse.data.userId
                ? AppColors.blue06
                : AppColors.black08,
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  color:
                      message.senderId == prefs.detailTripResponse.data.userId
                          ? AppColors.black
                          : AppColors.black50,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  formatterDate,
                  style: const TextStyle(
                    color: AppColors.black50,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  borderSide: const BorderSide(
                    color: AppColors.black10,
                  ),
                ),
                hintStyle: TextStyle(
                  color: AppColors.black50,
                  fontSize: 16,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  borderSide: const BorderSide(
                    color: AppColors.blue,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/img/send.svg',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
