import 'dart:io';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';

class SecondScannerLayout extends StatefulWidget {
  const SecondScannerLayout({Key? key}) : super(key: key);

  @override
  _SecondScannerLayoutState createState() => _SecondScannerLayoutState();
}

class _SecondScannerLayoutState extends State<SecondScannerLayout> {
  PDFDocument? _scannedDocument;
  File? _scannedDocumentFile;
  File? _scannedImage;
  Directory? documentDirectory;
  openPdfScanner(BuildContext context) async {
    var doc = await DocumentScannerFlutter.launchForPdf(
      context,
      labelsConfig: {
        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Steps",
        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_SINGLE: "Only 1 Page",
        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_MULTIPLE:
        "Only {PAGES_COUNT} Page"
      },
      source: ScannerFileSource.GALLERY,
    );
    if (doc != null) {
      _scannedDocument = null;
      setState(() {});
      await Future.delayed(Duration(milliseconds: 100));
      if (Platform.isAndroid) {
        documentDirectory = await getExternalStorageDirectory();
      }
      else{
        documentDirectory=await getApplicationDocumentsDirectory();
      }
      String documentPath = documentDirectory!.path;
      String fullPath = "$documentPath/example.pdf";
      print("FullPath: "+fullPath);
      File file = new File.fromUri(Uri.parse(fullPath));
      _scannedDocument = await PDFDocument.fromFile(file);
    }
  }
  openImageScanner(BuildContext context) async {
    var image = await DocumentScannerFlutter.launch(context,
        //source: ScannerFileSource.CAMERA,
        labelsConfig: {
          ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
          ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
        });
    if (image != null) {
      _scannedImage = image;
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Scanner Demo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_scannedDocument != null || _scannedImage != null) ...[
            if (_scannedImage != null)
              Image.file(_scannedImage!,
                  width: 300, height: 300, fit: BoxFit.contain),
            if (_scannedDocument != null)
              Expanded(
                  child: PDFViewer(
                    document: _scannedDocument!,
                  )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  _scannedDocumentFile?.path ?? _scannedImage?.path ?? ''),
            ),
          ],
          Center(
            child: Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () => openPdfScanner(context),
                  child: Text("PDF Scan"));
            }),
          ),
          Center(
            child: Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () => openImageScanner(context),
                  child: Text("Image Scan"));
            }),
          )
        ],
      ),
    );
  }
}
