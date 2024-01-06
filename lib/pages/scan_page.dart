import 'dart:convert';

import 'package:OptiWallet/download.dart';
import 'package:OptiWallet/firebasehandles/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController _controller;
  // String _extractedText = '';
  late Map<String, dynamic> _extractedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
            height: 400.0,
            child: QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.green,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });

    _controller.scannedDataStream.listen((scanData) {
      setState(() {
        _extractedText = jsonDecode(scanData.code!);
      });

      // Call your custom function with the extracted text
      onQRCodeDetected(_extractedText);
    });
  }

  void onQRCodeDetected(Map<String, dynamic> extractedText) async {
    try {
      // Call the getFilteredJsonFiles function with the extracted text
      List<Map<String, dynamic>> filteredJsonFiles = await getFilteredJsonFiles(extractedText["type"]);

      // Handle the filteredJsonFiles as needed
      // print('Filtered JSON Files: $filteredJsonFiles');
      _showDialogBox(title: 'Filtered JSON Files', content: 'Data: $filteredJsonFiles');

      if(filteredJsonFiles.isNotEmpty){
        Map<String, dynamic> vc = filteredJsonFiles.first;
        if(vc.containsKey("credentialDocuments") && vc["credentialDocuments"].isNotEmpty){
          var credentialDocuments = vc["credentialDocuments"];
          if(credentialDocuments is Map<String, dynamic> &&
              credentialDocuments.containsKey("did") &&
              credentialDocuments["id"].toString().isNotEmpty) {
              FirebaseDbOperations firebaseDbOperations = FirebaseDbOperations(Firebase.app());
              await firebaseDbOperations.addKeyValuePair('Tokens/${extractedText['']}', 'VCId', credentialDocuments["id"].toString());
              await firebaseDbOperations.addKeyValuePair('Tokens/${extractedText['']}', 'verified', true);
          }
        }
      } else {
        FirebaseDbOperations firebaseDbOperations = FirebaseDbOperations(Firebase.app());
        await firebaseDbOperations.addKeyValuePair('/Tokens/${extractedText['token']}', 'VCId', 'Invalid Identity!');
        await firebaseDbOperations.addKeyValuePair('/Tokens/${extractedText['token']}', 'verified', false);
        _showDialogBox(title: 'Verifying Identity', content: "Invalid Identity!");
      }
    } catch (e) {
      _showDialogBox(title: 'Error in onQRCodeDetected', content: 'Error fetching filtered JSON files: $e');
      // Handle errors or exceptions here
    }
  }

  void _showDialogBox({String title="Title", String content="Content"}){
    // Show a dialog box with the filtered data
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog box
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
