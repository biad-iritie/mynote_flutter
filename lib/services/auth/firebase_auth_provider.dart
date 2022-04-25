import 'package:firebase_core/firebase_core.dart';
import 'package:mynote/services/auth/auth_user.dart';
import 'package:mynote/services/auth/auth_exceptions.dart';
import 'package:mynote/services/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) 
      async {
    // TODO: implement createUser
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotFoundAuthException();
      }
    } on FirebaseAuthException catch(e) {
      switch (e.code) {
                  case 'weak-password':
                    //await showErrorDialog(context, "Weak password");
                    throw WeakPasswordAuthException();
                  case 'email-already-in-use':
                    //await showErrorDialog(context, "Email is already in use");
                    throw EmailAlreadyInUseAuthException();
                    
                  case 'invalid-email':
                    //await showErrorDialog(context, "Invalid email");
                    throw InvalidEmailAuthException();
                    
                  default:
                    //await showErrorDialog(context, "Error: ${e.code}");
                    throw GenericAuthException();
                }
    } catch (_){
        throw GenericAuthException();
    }
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) async{
    // TODO: implement logIn
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotFoundAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
                  case 'user-not-found':
                    //await showErrorDialog(context, "User not found");
                    throw UserNotFoundAuthException();
                  case 'wrong-password':
                    //await showErrorDialog(context, "Wrong credentials");
                    throw WrongPasswordAuthException();
                  default:
                    //await showErrorDialog(context, "Error: ${e.code}");
                    throw GenericAuthException();
                }
    }catch (_){
throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async{
    // TODO: implement logOut
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() 
  async {
    // TODO: implement sendEmailVerification
    final user  = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
