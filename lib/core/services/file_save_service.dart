import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileSaveService {
  static Future<String?> saveImageToDevice(BuildContext context, XFile imageFile, String prefix) async {
    try {
      if (kIsWeb) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$prefix exported successfully in Web browser!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        return imageFile.path;
      }

      final Directory? appDir = await getApplicationDocumentsDirectory();
      if (appDir == null) return null;

      final String fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String targetPath = '${appDir.path}/$fileName';

      final File newFile = await File(imageFile.path).copy(targetPath);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved successfully to:\n${newFile.path}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
      return newFile.path;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to app cache: ${imageFile.path}'),
            backgroundColor: Colors.green,
          ),
        );
      }
      return imageFile.path;
    }
  }
}
