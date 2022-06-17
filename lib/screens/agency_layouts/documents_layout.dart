import 'dart:io';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:insurances/screens/agency_layouts/scanner_layout.dart';
import 'package:path_provider/path_provider.dart';

class DocumentsLayout extends StatefulWidget {
  final agencyId;
  final clientCIN;
  final uid;
  const DocumentsLayout({Key? key,this.agencyId,this.clientCIN,this.uid}) : super(key: key);

  @override
  _DocumentsLayoutState createState() => _DocumentsLayoutState();
}

class _DocumentsLayoutState extends State<DocumentsLayout> {
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
      } else {
        documentDirectory = await getApplicationDocumentsDirectory();
      }
      String documentPath = documentDirectory!.path;
      String fullPath = "$documentPath/example.pdf";
      print("FullPath: " + fullPath);
      File file = new File.fromUri(Uri.parse(fullPath));
      _scannedDocument = await PDFDocument.fromFile(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                    onPressed: () => openPdfScanner(context),
                    child: Text("Crop an existing image from gallery"),
                ),
          ),
          Center(
            child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=> ScannerLayout()));
                    },
                    child: Text("Import"),
                ),
          ),
        ],
      ),
    );
  }
}
