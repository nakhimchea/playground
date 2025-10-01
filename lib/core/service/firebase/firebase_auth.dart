// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:toastification/toastification.dart';
// import 'package:playground/core/llibraries/storage/shared_preferences.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   User? get getUser => _auth.currentUser;

//   Future<void> signInWithGoogle(BuildContext context, void Function() successfulLoggedInCallback,
//       void Function(AuthCredential) pushGoogleAuthCredential, void Function() setProfileCallback) async {
//     try {
//       await SharedPreferencesManager().deleteAll();
//       AuthCredential googleAuthCredential;
//       UserCredential? userCredential;
//       if (kIsWeb) {
//         userCredential = await _auth.signInWithPopup(GoogleAuthProvider());
//         googleAuthCredential = userCredential.credential!;
//       } else {
//         final GoogleSignInAuthentication googleSignInAuthentication = await GoogleSignIn()
//             .signIn()
//             .then((googleSignInAccount) async => await googleSignInAccount!.authentication);
//         // Google Automatically SignOut from App
//         googleAuthCredential = GoogleAuthProvider.credential(
//           idToken: googleSignInAuthentication.idToken,
//           accessToken: googleSignInAuthentication.accessToken,
//         );

//         userCredential = await _auth.signInWithCredential(googleAuthCredential);
//       }

//       if (userCredential.user != null) {
//         // successfulLoggedInCallback();

//         toastification.show(
//           type: ToastificationType.success,
//           title: const Text('successful login'),
//           autoCloseDuration: const Duration(seconds: 3),
//         );
//       } else {
//         print('Can\'t logged in user.');
//       }
//     } catch (e) {
//       // print(e);
//       // ScaffoldMessenger.of(context).showSnackBar(_buildSnackBar(contentCode: 'invalid_google_account'));
//       toastification.show(
//         type: ToastificationType.error,
//         title: const Text('Invalid google account'),
//         autoCloseDuration: const Duration(seconds: 3),
//       );
//     }
//   }

//   // Sign out
//   signOut() async {
//     _auth.signOut();
//     await SharedPreferencesManager().deleteAll();
//     return true;
//   }
// }
