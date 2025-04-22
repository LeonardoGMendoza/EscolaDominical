import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return _userFromFirebaseUser(result.user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future logout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  UserModel? _userFromFirebaseUser(User user) {
    return user != null ? UserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      calling: '',
      organization: '',
    ) : null;
  }
}