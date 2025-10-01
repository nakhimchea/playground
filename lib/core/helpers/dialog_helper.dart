import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playground/core/helpers/circle_indecator.dart';

class DialogHelper {
  static void showLoading(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      barrierColor: Colors.black45,
      builder: (context) {
        return WillPopScope(
          onWillPop: () => Future.value(true),
          child: const Center(
            child: CircularIndicator(),
          ),
          //  isProgressLoading
          //     ? const CustomProgressLoadingWidget()
          //     : const CustomLoadingWidget(),
        );
      },
    );
  }

  static void showViewImageDialog(
    BuildContext context, {
    required Widget child,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (context) {
        return child;
      },
    );
  }

  static void showResultDialog(
    String title,
    String message, {
    void Function()? nextClick,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const SizedBox(width: 8.0),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: <Widget>[
            if (nextClick != null)
              TextButton(
                onPressed: nextClick,
                child: const Text('Next'),
              ),
            if (nextClick == null)
              TextButton(
                  child: Text(
                    'Ok',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
          ],
        );
      },
    );
  }

  static void success(
    String title,
    String message, {
    void Function()? nextClick,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 40,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  static void yesNoAlert(
    String title,
    String message, {
    void Function()? yes,
    void Function()? no,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(onPressed: no, child: const Text('No')),
            TextButton(
              onPressed: yes,
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  static void warnningDialog(
    String title,
    String message, {
    void Function()? close,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: close,
              child: const Text('CLose'),
            ),
          ],
        );
      },
    );
  }
}
