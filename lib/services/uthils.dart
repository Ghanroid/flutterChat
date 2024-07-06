import 'package:chatflutter/services/alertservice.dart';
import 'package:chatflutter/services/authservice.dart';
import 'package:chatflutter/services/databaseservice.dart';
import 'package:chatflutter/services/mediaservice.dart';
import 'package:chatflutter/services/navigatorservice.dart';
import 'package:chatflutter/services/storageservice.dart';
import 'package:get_it/get_it.dart';

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<Authservice>(Authservice());
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<Alertservice>(Alertservice());
  getIt.registerSingleton<Mediaservice>(Mediaservice());
  getIt.registerSingleton<Storageservice>(Storageservice());
  getIt.registerSingleton<Databaseservice>(Databaseservice());
}

String generateChatID({required String uid1, required String uid2}) {
  List uids = [uid1, uid2];
  uids.sort();
  String chatId = uids.fold("", (id, uid) => "$id$uid");
  return chatId;
}
