import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFDownloadService {
  static Future<void> downloadPDF({
    required BuildContext context,
    required String pdfUrl,
    required String fileName,
  }) async {
    final dio = Dio();

    try {
      // Request storage permissions
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        _showPermissionDeniedDialog(context);
        return;
      }

      // Show loading dialog
      _showDownloadDialog(context);

      // Get the download directory
      final directory = await getExternalStorageDirectory();
      final savePath = '${directory!.path}/$fileName.pdf';

      // Download the PDF
      await dio.download(
        pdfUrl,
        savePath,
        onReceiveProgress: (received, total) {
          // You can update UI with download progress if needed
        },
      );

      // Dismiss loading dialog
      Navigator.of(context).pop();

      // Show success dialog
      _showSuccessDialog(context, savePath);

    } catch (e) {
      // Dismiss loading dialog
      Navigator.of(context).pop();

      // Show error dialog
      _showErrorDialog(context, e.toString());
    }
  }

  static void _showDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Downloading PDF...'),
          ],
        ),
      ),
    );
  }

  static void _showSuccessDialog(BuildContext context, String filePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Download Complete'),
        content: Text('PDF has been saved to $filePath'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  static void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text('Storage permission is required to download PDFs.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Open Settings'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  static void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Download Failed'),
        content: Text('An error occurred: $errorMessage'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}