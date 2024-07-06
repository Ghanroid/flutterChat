import 'package:chatflutter/models/chat.dart';
import 'package:chatflutter/models/message.dart';
import 'package:chatflutter/models/userprofile.dart';
import 'package:chatflutter/services/authservice.dart';
import 'package:chatflutter/services/uthils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class Databaseservice {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _usersCollection;
  CollectionReference? _chatsCollection;

  late Authservice _authservice;

  final GetIt _getIt = GetIt.instance;
  Databaseservice() {
    _authservice = _getIt.get<Authservice>();
    _setupCollectionRefereences();
  }

  void _setupCollectionRefereences() {
    _usersCollection = _firebaseFirestore
        .collection('users')
        .withConverter<Userprofile>(
            fromFirestore: (snapshot, _) =>
                Userprofile.fromJson(snapshot.data()!),
            toFirestore: (userprofile, _) => userprofile.toJson());

    _chatsCollection = _firebaseFirestore
        .collection('chats')
        .withConverter<Chat>(
            fromFirestore: (snapshot, _) => Chat.fromJson(snapshot.data()!),
            toFirestore: (chat, _) => chat.toJson());
  }

  Future<void> createUserprofile({required Userprofile userprofile}) async {
    await _usersCollection?.doc(userprofile.uid).set(userprofile);
  }

  Stream<QuerySnapshot<Userprofile>> getUserprofile() {
    return _usersCollection
        ?.where("uid", isNotEqualTo: _authservice.user!.uid)
        .snapshots() as Stream<QuerySnapshot<Userprofile>>;
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final result = await _chatsCollection?.doc(chatID).get();
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docref = _chatsCollection!.doc(chatID);
    final chat = Chat(id: chatID, messages: [], participants: [uid1, uid2]);
    await docref.set(chat);
  }

  Future<void> sendChatMessage(
      String uid1, String uid2, Message message) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docref = _chatsCollection!.doc(chatID);
    await docref.update({
      "messages": FieldValue.arrayUnion([
        message.toJson(),
      ])
    });
  }

  Stream<DocumentSnapshot<Chat>> getchatData(String uid1, String uid2) {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    return _chatsCollection?.doc(chatID).snapshots()
        as Stream<DocumentSnapshot<Chat>>;
  }
}
