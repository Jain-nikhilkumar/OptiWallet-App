import 'dart:convert';

import 'package:OptiWallet/download.dart';
import 'package:OptiWallet/firebasehandles/firestore_handler.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _isQRCodeFound = false;
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
              onQRViewCreated: (controller) {
                if (!_isQRCodeFound) {
                  _onQRViewCreated(controller);
                  _isQRCodeFound = true;
                }
              },
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

      if(filteredJsonFiles.isNotEmpty){
        Map<String, dynamic> vc = filteredJsonFiles.first;
        if(vc.containsKey("credentialDocument") && vc["credentialDocument"].isNotEmpty){
          var credentialDocument = vc["credentialDocument"];
          if(credentialDocument is Map<String, dynamic> &&
              credentialDocument.containsKey("id") &&
              credentialDocument["id"].toString().isNotEmpty) {
            print("VC : ${credentialDocument['id'].toString()}");
            String collection = 'Tokens';
            String documentId = extractedText['token'];
            Map<String, dynamic> data = {
              'VCId': credentialDocument['id'].toString(),
              'verified': true
            };
            FirestoreHandler firestoreHandler = FirestoreHandler();
            bool updateDocument = await firestoreHandler.updateDocument(collection, documentId, data);
            updateDocument ?
            _showDialogBox(title: 'Verifying Identity', content: "Auth success ") :
            _showDialogBox(title: 'Verifying Identity', content: "Couldn't Update") ;
            firestoreHandler.closeFirestore();
            return;
            // FirebaseDbOperations firebaseDbOperations = FirebaseDbOperations(Firebase.app());
            // await firebaseDbOperations.addKeyValuePair('Tokens/${extractedText['']}', 'VCId', credentialDocuments["id"].toString());
            // await firebaseDbOperations.addKeyValuePair('Tokens/${extractedText['']}', 'verified', true);
          } else {
            _showDialogBox(title: 'Verifying Identity', content: 'Cannot get VCId');
          }
        } else{
          _showDialogBox(title: 'Verifying Identity', content: 'Cannot get credentialDocument');
        }
      } else {
        // FirebaseDbOperations firebaseDbOperations = FirebaseDbOperations(Firebase.app());
        // await firebaseDbOperations.addKeyValuePair('/Tokens/${extractedText['token']}', 'VCId', 'Invalid Identity!');
        // await firebaseDbOperations.addKeyValuePair('/Tokens/${extractedText['token']}', 'verified', false);
        _showDialogBox(title: 'Verifying Identity', content: "You don't have required Identity !");
      }

      String collection = 'Tokens';
      String documentId = extractedText['token'];
      Map<String, dynamic> data = {
        'VCId': 'Invalid VC',
        'verified': false
      };
      FirestoreHandler firestoreHandler = FirestoreHandler();
      var updateDocument = await firestoreHandler.updateDocument(collection, documentId, data);
      firestoreHandler.closeFirestore();
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
