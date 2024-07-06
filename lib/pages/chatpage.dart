import 'dart:io';

import 'package:chatflutter/models/chat.dart';
import 'package:chatflutter/models/message.dart';
import 'package:chatflutter/models/userprofile.dart';
import 'package:chatflutter/services/authservice.dart';
import 'package:chatflutter/services/databaseservice.dart';
import 'package:chatflutter/services/mediaservice.dart';
import 'package:chatflutter/services/storageservice.dart';
import 'package:chatflutter/services/uthils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Chatpage extends StatefulWidget {
  final Userprofile chatuser;

  const Chatpage({super.key, required this.chatuser});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  ChatUser? currentuser, otheruser;
  late Authservice _authservice;
  final GetIt _getIt = GetIt.instance;
  late Databaseservice _databaseservice;
  late Mediaservice _mediaservice;
  late Storageservice _storageservice;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authservice = _getIt.get<Authservice>();
    _databaseservice = _getIt.get<Databaseservice>();
    _mediaservice = _getIt.get<Mediaservice>();
    _storageservice = _getIt.get<Storageservice>();
    currentuser = ChatUser(
        id: _authservice.user!.uid, firstName: _authservice.user!.displayName);
    otheruser = ChatUser(
        id: widget.chatuser.uid!,
        firstName: widget.chatuser.name,
        profileImage: widget.chatuser.pfpurl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.chatuser.name!),
        ),
        body: StreamBuilder(
          stream: _databaseservice.getchatData(currentuser!.id, otheruser!.id),
          builder: (context, snapshot) {
            Chat? chat = snapshot.data?.data();
            List<ChatMessage> message = [];
            if (chat != null && chat.messages != null) {
              message = _generateChatMEssageList(chat.messages!);
            }
            return DashChat(
              messageOptions:
                  MessageOptions(showOtherUsersAvatar: true, showTime: true),
              inputOptions: InputOptions(
                alwaysShowSend: true,
                trailing: [
                  mediamessagebtn(),
                ],
              ),
              currentUser: currentuser!,
              onSend: _sendMessage,
              messages: message,
            );
          },
        ));
  }

  Future<void> _sendMessage(ChatMessage chatmessage) async {
    if (chatmessage.medias?.isNotEmpty ?? false) {
      if (chatmessage.medias!.first.type == MediaType.image) {
        Message message = Message(
            senderID: chatmessage.user.id,
            content: chatmessage.medias!.first.url,
            messageType: MessageType.Image,
            sentAt: Timestamp.fromDate(chatmessage.createdAt));
        await _databaseservice.sendChatMessage(
            currentuser!.id, otheruser!.id, message);
      }
    } else {
      Message message = Message(
          senderID: currentuser!.id,
          content: chatmessage.text,
          messageType: MessageType.Text,
          sentAt: Timestamp.fromDate(chatmessage.createdAt));
      await _databaseservice.sendChatMessage(
          currentuser!.id, otheruser!.id, message);
    }
  }

  List<ChatMessage> _generateChatMEssageList(List<Message> message) {
    List<ChatMessage> chatmessages = message.map((m) {
      if (m.messageType == MessageType.Image) {
        return ChatMessage(
            user: m.senderID == currentuser!.id ? currentuser! : otheruser!,
            createdAt: m.sentAt!.toDate(),
            medias: [
              ChatMedia(url: m.content!, fileName: "", type: MediaType.image)
            ]);
      } else {
        return ChatMessage(
          text: m.content!,
          user: m.senderID == currentuser!.id ? currentuser! : otheruser!,
          createdAt: m.sentAt!.toDate(),
        );
      }
    }).toList();
    chatmessages.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatmessages;
  }

  Widget mediamessagebtn() {
    return IconButton(
        onPressed: () async {
          File? file = await _mediaservice.getImagefromGallery();
          if (file != null) {
            String chatID =
                generateChatID(uid1: currentuser!.id, uid2: otheruser!.id);
            String? downloadurl = await _storageservice.uploadimagTOchat(
                file: file, chatID: chatID);
            if (downloadurl != null) {
              ChatMessage chatMessage = ChatMessage(
                  user: currentuser!,
                  createdAt: DateTime.now(),
                  medias: [
                    ChatMedia(
                        url: downloadurl, fileName: "", type: MediaType.image)
                  ]);
              _sendMessage(chatMessage);
            }
          }
        },
        icon: Icon(Icons.image));
  }
}
/*DashChat(
          messageOptions:
              const MessageOptions(showOtherUsersAvatar: true, showTime: true),
          inputOptions: const InputOptions(alwaysShowSend: true),
          currentUser: currentuser!,
          onSend: _sendMessage,
          messages: [],
        ) */