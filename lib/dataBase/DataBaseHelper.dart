import 'package:chat_pract/models/Message.dart';
import 'package:chat_pract/models/Room.dart';
import 'package:chat_pract/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference<Users> getUsersCollectionWithConverter(){

  return FirebaseFirestore.instance.collection(Users.COLLECTION_NAME).withConverter<Users>(
    fromFirestore: (snapshot, _) => Users.fromJson(snapshot.data()!),
    toFirestore: (users, _) => users.toJson(),
  );
}

CollectionReference<Room> getRoomsCollectionWithConverter(){

  return FirebaseFirestore.instance.collection(Room.COLLECTION_NAME).withConverter<Room>(
    fromFirestore: (snapshot, _) => Room.fromJson(snapshot.data()!),
    toFirestore: (room, _) => room.toJson(),
  );
}

CollectionReference<Message> getMessagesCollectionWithConverter(String roomId){

  final roomsCollections= getRoomsCollectionWithConverter();
  return roomsCollections.doc(roomId).collection(Message.COLLECTION_NAME).withConverter<Message>(
    fromFirestore: (snapshot, _) => Message.fromJson(snapshot.data()!),
    toFirestore: (message, _) => message.toJson(),
  );
}