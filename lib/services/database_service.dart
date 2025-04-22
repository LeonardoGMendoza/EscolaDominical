import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoladominical/models/user_model.dart';
import 'package:escoladominical/models/training_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Métodos para User
  Future<void> addUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? UserModel.fromMap(doc.data()!) : null;
  }

  // Métodos para Eventos
  Stream<QuerySnapshot> getOrganizationEvents(String org) {
    return _firestore
        .collection('events')
        .where('organization', isEqualTo: org)
        .snapshots();
  }

  // Métodos para Treinamentos
  Future<void> addTraining(Training training) async {
    await _firestore.collection('trainings').add(training.toMap());
  }

  Stream<QuerySnapshot> getTrainings(String organization) {
    return _firestore
        .collection('trainings')
        .where('organization', isEqualTo: organization)
        .snapshots();
  }
}