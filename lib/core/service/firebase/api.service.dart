import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wingai/modules/chat/models/chat_topic_model.dart';

class FirebaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  batchAdd(dynamic data) async {
    final bath = db.batch();
    for (var item in data.docs) {
      var ref = db.collection('audio_record').doc('').collection('_').doc(item.id);
      bath.set(ref, item.data());
    }
    await bath.commit();
  }

  CollectionReference<Map<String, dynamic>> refAll(String controller) {
    return db.collection(controller);
  }

  CollectionReference<Map<String, dynamic>> refSubAll(String controller, String id, String sub) {
    return db.collection(controller).doc(id).collection(sub);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAll(String controller) {
    return db.collection(controller).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument(String controller, String id) {
    return db.collection(controller).doc(id).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentByPath(String path) {
    return db.doc(path).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String controller, String id) {
    return db.collection(controller).doc(id).get();
  }

  Future<List<ChatTopicModel>> getAllTopicsByUser(String collection, String userId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await db
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .get();
    List<ChatTopicModel> topics = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      return ChatTopicModel.fromJson(data);
    }).toList();
    return topics;
  }

  Future<dynamic> createTopic(String controller, Map<String, dynamic> data) async {
    var ref = db.collection(controller).doc();
    data["chatId"] = ref.id;
    await ref.set(data);
    return data;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllDocument(String controller) {
    return db.collection(controller).get();
  }

  Future<List<DocumentSnapshot>> getLimitSubColletionDocuments(
      String controller, String id, String subController, int limit) async {
    CollectionReference collectionRef = db.collection(controller).doc(id).collection(subController);
    QuerySnapshot querySnapshot = await collectionRef.orderBy('createdAt', descending: false).limit(limit).get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getsubColletionDocuments(
    String controller,
    String id,
    String subController,
  ) async {
    CollectionReference collectionRef = db.collection(controller).doc(id).collection(subController);
    QuerySnapshot querySnapshot = await collectionRef.orderBy('createdAt', descending: false).get();
    return querySnapshot.docs;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSubDocument(
      String controller, String id, String sub, String subId) {
    return db.collection(controller).doc(id).collection(sub).doc(subId).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamSubDocument(
      String controller, String id, String sub, String subId) {
    return db.collection(controller).doc(id).collection(sub).doc(subId).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllSub(String controller, String id, String sub) {
    return db.collection(controller).doc(id).collection(sub).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllSubChat(String controller, String id, String sub) {
    return db.collection(controller).doc(id).collection(sub).orderBy('createdAt', descending: true).snapshots();
  }

  Future<DocumentReference> create(String controller, Map<String, dynamic> data) {
    return db.collection(controller).add(data);
  }

  Future<dynamic> createSub(String controller, String id, String sub, Map<String, dynamic> data) {
    return db.collection(controller).doc(id).collection(sub).add(data);
  }

  Future<dynamic> setSub(String controller, String id, String sub, Map<String, dynamic> data) {
    return db.collection(controller).doc(id).collection(sub).doc().set(
          data,
          SetOptions(merge: true),
        );
  }

  Future<dynamic> setSubById(String controller, String id, String sub, String subId, Map<String, dynamic> data) {
    return db.collection(controller).doc(id).collection(sub).doc(subId).set(
          data,
          SetOptions(merge: true),
        );
  }

  Future<dynamic> setSubWithMerge(String controller, String id, String sub, String subId, Map<String, dynamic> data) {
    return db.collection(controller).doc(id).collection(sub).doc(subId).set(
          data,
          SetOptions(merge: true),
        );
  }

  Future<dynamic> set(String controller, String id, Map<String, dynamic> data) {
    return db.collection(controller).doc(id).set(
          data,
          SetOptions(merge: true),
        );
  }

  Future<dynamic> update(String controller, String id, Map<String, dynamic> data) {
    return db.collection(controller).doc(id).update(data);
  }

  Future<dynamic> updatePath(String path, Map<String, dynamic> data) {
    return db.doc(path).update(data);
  }

  Future<dynamic> updateSub(String controller, String id, String sub, String subId, Map<String, dynamic> data) {
    return db.collection(controller).doc(id).collection(sub).doc(subId).update(data);
  }

  Future<void> deleteDocument(String controller, String id) {
    return db.collection(controller).doc(id).delete();
  }

  Future<void> deleteBy(String controller, Query query) {
    return db.collection(controller).where(query).snapshots().first.then((value) {
      value.docs[0].reference.delete();
    });
  }

  Future<void> deleteSubDocument(String controller, String id, String sub, String subId) {
    return db.collection(controller).doc(id).collection(sub).doc(subId).delete();
  }
}
