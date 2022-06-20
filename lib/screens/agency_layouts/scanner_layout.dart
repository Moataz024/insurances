import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insurances/model/document_model.dart';
import 'package:insurances/screens/agency_layouts/documents_layout.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
class ScannerLayout extends StatefulWidget {
  final agencyId;
  final clientCIN;
  final uid;
  const ScannerLayout({Key? key,this.uid,this.clientCIN,this.agencyId}) : super(key: key);

  @override
  _ScannerLayoutState createState() => _ScannerLayoutState();
}

class _ScannerLayoutState extends State<ScannerLayout> {
  bool? picked = false;
  final picker = ImagePicker();
  final pdf = pw.Document();
  List<Uint8List> image = [];
  File? _image;
  Uint8List? _byte, salida;
  String _versionOpenCV = 'OpenCV';
  bool _visible = false;
  @override
  void initState() {
    super.initState();
    _getOpenCVVersion();
  }
  testOpenCV({
    required String pathString,
    required CVPathFrom pathFrom,
    required double thresholdValue,
    required double maxThresholdValue,
    required int thresholdType,
  }) async {
    try {
      _byte = await Cv2.threshold(
        pathFrom: pathFrom,
        pathString: pathString,
        maxThresholdValue: maxThresholdValue,
        thresholdType: thresholdType,
        thresholdValue: thresholdValue,
      );

      setState(() async {
        _byte;
        image.add(_byte!);
        _visible = false;
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _getOpenCVVersion() async {
    String? versionOpenCV = await Cv2.version();
    setState(() {
      _versionOpenCV = 'OpenCV: ' + versionOpenCV!;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          image.length == 0
              ? Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Select Image From Camera or File explorer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.indigo[900],
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment(-0.5, 0.8),
                            child: FloatingActionButton(
                              elevation: 0.0,
                              child: new Icon(
                                Icons.image,
                              ),
                              backgroundColor: Colors.indigo[900],
                              onPressed: getImageFromGallery,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment(0.5, 0.8),
                            child: FloatingActionButton(
                              elevation: 0.0,
                              child: new Icon(
                                Icons.camera,
                              ),
                              backgroundColor: Colors.indigo[900],
                              onPressed: getImageFromcamera,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
              : PdfPreview(
            maxPageWidth: 1000,
            canChangeOrientation: true,
            canDebug: false,
            build: (format) => generateDocument(
              format,
              1,
              image,
            ),
            actions: [
              IconButton(onPressed: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=> DocumentsLayout()),ModalRoute.withName('/documents_layout'));
              }, icon: Icon(Icons.cancel_outlined, color: Colors.redAccent,)),
              IconButton(onPressed: (){
                firebase_storage.FirebaseStorage.instance.ref().child('documents/${Uri.file(_image!.path).pathSegments.last}')
                    .putFile(_image!).then((p0) {
                    p0.ref.getDownloadURL().then((value) {
                      DocumentModel model = new DocumentModel(
                        agencyId: widget.agencyId,
                        clientCIN: widget.clientCIN,
                        employeeId: widget.uid,
                        creationDate: DateTime.now().toIso8601String(),
                        fileUrl: value,
                      );
                      FirebaseFirestore.instance.collection('documents').add(model.toMap());
                      Navigator.pop(context);
                    });
                }).catchError((error) {});
              }, icon: Icon(Icons.add_circle,size: 30 , color: Colors.white,)),
            ],
          ),
        ],
      ),
    );
  }
  getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    _image = File(pickedFile!.path);

    setState(() {
      if (pickedFile != null) {
        picked = true;
        print('image picked ');
        testOpenCV(
          pathFrom: CVPathFrom.GALLERY_CAMERA,
          pathString: _image!.path,
          thresholdValue: 130,
          maxThresholdValue: 200,
          thresholdType: Cv2.THRESH_BINARY,
        );
      } else {
        print('No image selected');
      }
    });
  }

  getImageFromcamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    setState(() {
      if (pickedFile != null) {
        testOpenCV(
          pathFrom: CVPathFrom.GALLERY_CAMERA,
          pathString: _image!.path,
          thresholdValue: 130,
          maxThresholdValue: 200,
          thresholdType: Cv2.THRESH_BINARY,
        );

        setState(() {
          _visible = true;
        });
      } else {
        print('No image selected');
      }
    });
  }

  Future<Uint8List> generateDocument(
      PdfPageFormat format, imagelenght, image) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();
    for (var im in image) {
      final showimage = pw.MemoryImage(im);

      doc.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: format.copyWith(
              marginBottom: 0,
              marginLeft: 0,
              marginRight: 0,
              marginTop: 0,
            ),
            orientation: pw.PageOrientation.portrait,
            theme: pw.ThemeData.withFont(
              base: font1,
              bold: font2,
            ),
          ),
          build: (context) {
            return pw.Center(
              child: pw.Image(showimage, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    }
    return await doc.save();
  }
}
