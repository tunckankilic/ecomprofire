import 'package:ecomprofire/app/service/assets_manager.dart';
import 'package:ecomprofire/view/components/subtitle_text.dart';
import 'package:flutter/material.dart';

class MyAppFunctions {
  static Future<void> showErrorOrWarningDialog({
    required BuildContext context,
    required String subtitle,
    bool isError = true,
    required Function fct,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  isError ? AssetsManager.error : AssetsManager.warning,
                  height: 60,
                  width: 60,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                SubtitleTextWidget(
                  label: subtitle,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !isError,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const SubtitleTextWidget(
                          label: "Cancel",
                          color: Colors.green,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        fct();
                        Navigator.pop(context);
                      },
                      child: const SubtitleTextWidget(
                        label: "OK",
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required VoidCallback cameraFCT,
    required VoidCallback galleryFCT,
    required VoidCallback removeFCT,
  }) async {
    // Bu fonksiyonun içindeki kodu kontrol etmelisiniz.
    // Örneğin, bir AlertDialog kullanılabilir.
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an option'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                cameraFCT();
              },
              child: Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                galleryFCT();
              },
              child: Text('Gallery'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                removeFCT();
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}
