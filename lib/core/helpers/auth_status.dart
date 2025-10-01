import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  userNotFound,
  operationNotAllowed,
  invalidCredential,
  accountExistsWithDifferentCredential,
  requiresRecentLogin,
  userDisabled,
  tooManyRequests,
  unknown,
}

class AuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      case "user-not-found":
        status = AuthStatus.userNotFound;
        break;
      case "operation-not-allowed":
        status = AuthStatus.operationNotAllowed;
        break;
      case "invalid-credential":
        status = AuthStatus.invalidCredential;
        break;
      case "account-exists-with-different-credential":
        status = AuthStatus.accountExistsWithDifferentCredential;
        break;
      case "requires-recent-login":
        status = AuthStatus.requiresRecentLogin;
        break;
      case "user-disabled":
        status = AuthStatus.userDisabled;
        break;
      case "too-many-requests":
        status = AuthStatus.tooManyRequests;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthStatus.weakPassword:
        errorMessage = "Your password should be at least 6 characters.";
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "Your email or password is wrong.";
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage = "The email address is already in use by another account.";
        break;
      case AuthStatus.userNotFound:
        errorMessage = "No user found with the given email.";
        break;
      case AuthStatus.operationNotAllowed:
        errorMessage = "The operation is not allowed. Please check with the administrator.";
        break;
      case AuthStatus.invalidCredential:
        errorMessage = "The provided authentication credential is invalid. Please input the correct email and password";
        break;
      case AuthStatus.accountExistsWithDifferentCredential:
        errorMessage = "An account already exists with the same email address but different sign-in credentials.";
        break;
      case AuthStatus.requiresRecentLogin:
        errorMessage = "This operation is sensitive and requires recent authentication. Log in again before retrying this request.";
        break;
      case AuthStatus.userDisabled:
        errorMessage = "The user account has been disabled by an administrator.";
        break;
      case AuthStatus.tooManyRequests:
        errorMessage = "We have blocked all requests from this device due to unusual activity. Try again later.";
        break;
      default:
        errorMessage = "An error occurred. Please try again later.";
    }
    return errorMessage;
  }
}
