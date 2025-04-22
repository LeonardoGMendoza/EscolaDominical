import 'dart:io'; // Adicione este import
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(String path, File file) async { // Alterado de String para File
    try {
      TaskSnapshot snapshot = await _storage.ref(path).putFile(file);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Erro no upload: $e');
      return '';
    }
  }
}