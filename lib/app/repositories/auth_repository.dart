import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthRepository {
  Future<User?> signUpWithEmail(String email, String password);
  Future<User?> signInWithEmail(String email, String password);
  Future<void> signInWithPhone(
      String phoneNumber,
      Function(PhoneAuthCredential) verificationCompleted,
      Function(FirebaseAuthException) verificationFailed,
      Function(String, int?) codeSent,
      Function(String) codeAutoRetrievalTimeout);
  Future<User?> verifyPhoneCode(String verificationId, String smsCode);
  Future<void> resetPassword(String email);
  Future<void> signOut();
  User? getCurrentUser();
}

class AuthRepository extends BaseAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // E-posta ve şifre ile kayıt
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  // E-posta ve şifre ile giriş
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  // Telefon numarası ile giriş (ilk aşama)
  Future<void> signInWithPhone(
      String phoneNumber,
      Function(PhoneAuthCredential) verificationCompleted,
      Function(FirebaseAuthException) verificationFailed,
      Function(String, int?) codeSent,
      Function(String) codeAutoRetrievalTimeout) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  // Telefon numarası ile giriş (doğrulama kodu ile)
  Future<User?> verifyPhoneCode(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  // Şifre sıfırlama
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  // Çıkış yapma
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Mevcut kullanıcıyı alma
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
