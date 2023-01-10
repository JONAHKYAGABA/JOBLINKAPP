import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
//import 'package:mak_past_papers/model/pdf_provider.dart';
//import 'package:mak_past_papers/screens/pdfstore.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class viewpdf extends StatefulWidget {
  final String pdfurl;
  viewpdf({
    Key? key,
    required this.pdfurl,
    //required pdfname
  }) : super(key: key);
  //File? file;

  @override
  State<viewpdf> createState() => _viewpdfState();
}

class _viewpdfState extends State<viewpdf> {
  bool _isLoading = true;
  String? _localFile;
//late PDFDocument document;

  @override
  void initState() {
    print(widget.pdfurl);
    super.initState();
    //loadDocument();
    // PDFApi.loadpdf().then((value) {
    // setState(() {
    //   //print('/////////////'+value+'////////////////');
    //   //_localFile = value;
    // });

    // }
    //);
  }

  loadDocument() async {
    _isLoading = false;
//document = await PDFDocument.fromURL('https://www.kindacode.com/wp-content/uploads/2021/07/test.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('text'),
              actions: <Widget>[
                TextButton(
                  //textColor: Colors.white,
                  onPressed: () {
                    //print(pdfProvider.pdfurl);
                  },
                  child: Text("Save"),
                ),
              ],
              // widget.pdfname
            ),
            body: Container(
              child: SfPdfViewer.network(widget.pdfurl.toString()),
              //  PDFView(
              //  filePath: widget.file!.path,

              //  )
            )));
  }
}
