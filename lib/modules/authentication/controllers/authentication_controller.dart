import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toastification/toastification.dart';
import 'package:wingai/core/helpers/auth_status.dart';
import 'package:wingai/core/llibraries/storage/shared_preferences.dart';
import 'package:wingai/core/service/firebase/api.service.dart';
import 'package:wingai/modules/chat/models/user_model.dart';

import '../../../core/helpers/dialog_helper.dart';

class AuthenticationController extends GetxController {
  final FirebaseService _api = FirebaseService();
  RxBool isValidated = RxBool(false);
  RxBool validOtp = RxBool(false);
  RxBool isPasswordVisible = false.obs;
  Rxn<UserModel> userStore = Rxn<UserModel>();

  RxString signInVerificationId = RxString('');
  int? _resendToken;
  RxnString errorValidateText = RxnString();
  var phoneNumberController = TextEditingController(text: '');
  var otpController = TextEditingController(text: '');

  var emailController = TextEditingController(text: '');
  var passwordController = TextEditingController(text: '');

  FirebaseAuth get _firebaseAuth => FirebaseAuth.instance;

  /// sign up
  TextEditingController signUpemailController = TextEditingController();
  var resetPasswordemailController = TextEditingController();
  TextEditingController signUppasswordController = TextEditingController();
  var signUpFullName = TextEditingController(text: '');
  var signUpAge = TextEditingController(text: '');
  RxString signUpGender = 'Male'.obs;

  // Firebase user one-time fetch
  User? get getUser => _firebaseAuth.currentUser;

  Future<void> signInWithEmailPassword() async {
    DialogHelper.showLoading(Get.context!);
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final userInfo = await checkUserInfo(userCredential.user!.uid.toString());
      log('user info###: $userInfo');
      clearFormLogin();
      if (userInfo != null) {
        toastification.show(
          type: ToastificationType.success,
          title: const Text('successful login'),
          autoCloseDuration: const Duration(seconds: 2),
        );
        Get.offAllNamed("/chat");
      } else {
        Get.offAllNamed("/sign_up");
      }
    } on FirebaseAuthException catch (e) {
      _hideLoading();
      final status = AuthExceptionHandler.handleAuthException(e);
      final error = AuthExceptionHandler.generateErrorMessage(status);
      _showErrorMessage(error);
    } catch (e) {
      _hideLoading();
      _showErrorMessage('Error : $e');
    }
  }

  Future<void> signInWithGoogle(BuildContext context, void Function() successfulLoggedInCallback,
      void Function(AuthCredential) pushGoogleAuthCredential, void Function() setProfileCallback) async {
    try {
      await SharedPreferencesManager().deleteAll();
      AuthCredential googleAuthCredential;
      UserCredential? userCredential;
      if (kIsWeb) {
        userCredential = await _firebaseAuth.signInWithPopup(GoogleAuthProvider());
        googleAuthCredential = userCredential.credential!;
      } else {
        final GoogleSignInAuthentication googleSignInAuthentication = await GoogleSignIn()
            .signIn()
            .then((googleSignInAccount) async => await googleSignInAccount!.authentication);
        // Google Automatically SignOut from App
        googleAuthCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        userCredential = await _firebaseAuth.signInWithCredential(googleAuthCredential);
      }

      if (userCredential.user != null) {
        final userInfo = await checkUserInfo(userCredential.user!.uid.toString());
        if (userInfo == null) {
          await _api.set(
            'users',
            userCredential.user!.uid,
            {
              "email": userCredential.user!.email,
              "userId": userCredential.user!.uid,
              "createdAt": DateTime.now(),
            },
          );
          userStore.value = UserModel(
            userId: userCredential.user!.uid,
            email: userCredential.user!.email.toString(),
          );
        }
        // successfulLoggedInCallback();
        Get.offAllNamed("/chat");
        toastification.show(
          type: ToastificationType.success,
          title: const Text('successful login'),
          autoCloseDuration: const Duration(seconds: 3),
        );
      } else {
        print('Can\'t logged in user.');
      }
    } catch (e) {
      // print(e);
      // ScaffoldMessenger.of(context).showSnackBar(_buildSnackBar(contentCode: 'invalid_google_account'));
      toastification.show(
        type: ToastificationType.error,
        title: const Text('Invalid google account'),
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  clearFormLogin() {
    emailController.text = '';
    passwordController.text = '';
    signUpemailController.text = '';
    signUppasswordController.text = '';
    signUpFullName.text = '';
    signUpAge.text = '';
  }

  Future<void> signUpWithEmailPassword() async {
    DialogHelper.showLoading(Get.context!);
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: signUpemailController.text.trim(),
        password: signUppasswordController.text,
      );

      await _api.set(
        'users',
        userCredential.user!.uid,
        {
          "email": signUpemailController.text.toLowerCase().trim(),
          "userId": userCredential.user!.uid,
          "createdAt": DateTime.now(),
        },
      );
      userStore.value = UserModel(
        userId: userCredential.user!.uid,
        email: signUpemailController.text,
      );
      clearFormLogin();
      toastification.show(
        type: ToastificationType.success,
        title: const Text('successful Sign up'),
        autoCloseDuration: const Duration(seconds: 2),
      );
      Get.offAllNamed('/chat');
      // }
    } on FirebaseAuthException catch (e) {
      _hideLoading();

      final status = AuthExceptionHandler.handleAuthException(e);
      final error = AuthExceptionHandler.generateErrorMessage(status);
      _showErrorMessage('Error : $error');
      // _showErrorMessage('Error : ${e.message!}');
    } catch (e) {
      _hideLoading();

      _showErrorMessage('Error : $e');
    }
  }

  handleAuthChanged(firebaseUser) async {
    //get user data from firestore
    if (firebaseUser == null) {
      Get.offAllNamed("/sign_in");
    } else {
      userStore.bindStream(streamFirestoreUser(firebaseUser.uid));
    }
  }

  //Streams the firestore user from the firestore collection
  Stream<UserModel?> streamFirestoreUser(String uid) {
    return _api.streamDocument("users", uid).map((snapshot) => UserModel.fromMap(snapshot.data()!));
  }

  Future checkUserInfo(String uid) async {
    var data = await _api.getDocument("users", uid);
    if (data.exists) {
      userStore.value = UserModel.fromMap(data.data()!);
      return userStore.value;
    }
  }

  Future splashScreenCheckExistingUser() async {
    Future.delayed(const Duration(seconds: 3), () async {
      if (_firebaseAuth.currentUser == null) {
        Get.offAllNamed("/sign_in");
      } else {
        final userInfo = await checkUserInfo(_firebaseAuth.currentUser!.uid.toString());
        if (userInfo == null) {
          Get.offAllNamed("/sign_up");
        } else {
          Get.offAllNamed("/chat");
        }
      }
    });
  }

  Future<void> _onVerifyPhoneNumber({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    // to stop app verify i'm not a robot disable reCAPTCHA verification
    // await _firebaseAuth.setSettings(appVerificationDisabledForTesting: true);
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      codeSent: codeSent,
      forceResendingToken: _resendToken,
    );
  }

  Future<void> onVerifyPhoneNumberWhenSignIn(
      {required String phoneNumber, bool resend = false, Function? onCodeSent}) async {
    await _onVerifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        await signInWithCredentialFirebase(credential);
      },
      verificationFailed: (FirebaseAuthException error) {
        // DialogHelper.showLoading(Get.context!);
        _hideLoading();

        log('message: VerificationFailed $error');
        String message = AuthExceptionHandler.handleAuthException(error);
        _showErrorMessage(message);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log('message: Timeout $verificationId');
      },

      // called when the SMS code is sent
      codeSent: (verificationId, resendToken) {
        _hideLoading();

        _resendToken = resendToken;
        signInVerificationId.value = verificationId;

        if (onCodeSent != null) {
          onCodeSent();
        }

        if (!resend) {
          validOtp.value = true;
        }
      },
    );
  }

  Future<void> signInWithCredentialFirebase(AuthCredential credential) async {
    DialogHelper.showLoading(Get.context!);

    await _firebaseAuth.signInWithCredential(credential).then((userCredential) async {
      try {
        final userInfo = await checkUserInfo(userCredential.user!.uid.toString());
        log('user info###: $userInfo');
        phoneNumberController.text = '';
        otpController.text = '';
        validOtp.value = false;
        // print(userCredential.user!.uid);

        if (userInfo == null) {
          Get.offAllNamed("/userInfoForm");
        } else {
          Get.offAllNamed("/");
        }
      } catch (e) {
        _hideLoading();
        // _showErrorMessage('Error sign in with credential: $e');
      }
    }).catchError((e) async {
      _hideLoading();

      _showErrorMessage('@auth.invalidOTPCode'.tr);
      log('show error message: $e');
    });
  }

  void _showErrorMessage(String message, [String? title]) {
    DialogHelper.showResultDialog(
      title ?? '',
      message,
    );
  }

  void _hideLoading() {
    Get.back();
  }

  Future<void> getOTP() async {
    try {
      if (phoneNumberController.text.length >= 8 && phoneNumberController.text.length <= 10) {
        DialogHelper.showLoading(Get.context!);
        var fullPhoneNumber = '';
        if (phoneNumberController.text.startsWith('0')) {
          fullPhoneNumber = '+855${phoneNumberController.text.substring(1)}';
          // Output: 855123456789
        }
        // if(phoneNumberController.text[0]=='0'){
        log("get OTP");
        await onVerifyPhoneNumberWhenSignIn(phoneNumber: fullPhoneNumber.toString());
        // }
        // await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumberController.text);
      }
    } catch (e) {
      log('error: $e');
    }
  }

  Future<void> verificationCode(
    String smsCode,
  ) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: signInVerificationId.value,
      smsCode: smsCode,
    );

    await signInWithCredentialFirebase(phoneAuthCredential);
  }

  Future signOut() async {
    try {
      userStore.value = null;
      _firebaseAuth.signOut();

      // _user.value = null;
      Get.offAndToNamed('/sign_in');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<AuthStatus> resetPassword({required String email}) async {
    AuthStatus status = AuthStatus.unknown;
    await _firebaseAuth
        .sendPasswordResetEmail(email: email)
        .then((value) => status = AuthStatus.successful)
        .catchError((e) => status = AuthExceptionHandler.handleAuthException(e));
    return status;
  }

  Future recoverPassword(String email) async {
    try {
      DialogHelper.showLoading(Get.context!);
      final status = await resetPassword(email: email.trim());
      if (status == AuthStatus.successful) {
        Get.close(1);
        _showErrorMessage(
            'Reset password link has been sent to $email, Please follow that link to input a new password');
      } else {
        Get.close(1);
        final error = AuthExceptionHandler.generateErrorMessage(status);
        _showErrorMessage(error);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
