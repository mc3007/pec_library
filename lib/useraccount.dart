import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:pec_library/sharedPreferences.dart';

class UserAccount extends StatefulWidget {
  @override
  _UserAccount createState() => _UserAccount();
}

class _UserAccount extends State<UserAccount>{

  String scanResult;
  bool barcodeGenerated=false;
  final ids=['IT','CS','ECE'];

  @override
  void initState(){
    super.initState();
    scanResult=UserSimplePreferences.getScanResult() ?? '';
    barcodeGenerated=UserSimplePreferences.getBarcodeGenerated() ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'back',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Visibility(
                visible: barcodeGenerated,
                child: Card(
                  color: Colors.white,
                  elevation: 6,
                  shadowColor: Colors.blueGrey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BarcodeWidget(
                      data: scanResult!=null? scanResult:"PEC Library Card",
                      barcode:Barcode.code128(),
                      width: 200,
                      height: 50,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: RaisedButton.icon(
                    color: Colors.blue,
                    onPressed: scanBarCode,
                    icon: Icon(Icons.line_weight),
                    label: Text(
                      barcodeGenerated?'Edit Barcode': 'Scan Barcode',
                    style: TextStyle(color: Colors.white),)),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> scanBarCode() async{
    String scanResult;
    bool barcodeGenerated=false;
    try{
      scanResult=await FlutterBarcodeScanner.scanBarcode(
          "#ff6666",
          "Cancel",
          true,
          ScanMode.BARCODE);
    }on PlatformException{
      scanResult='Invalid code';
    }
    for(int i=0;i<ids.length;i++){
      if(scanResult.contains(ids[i])){
        await UserSimplePreferences.setBarcode(this.scanResult=scanResult);
        await UserSimplePreferences.setBarcodeGenerated(this.barcodeGenerated=!barcodeGenerated);
        setState(() {
          this.scanResult=scanResult;
        });
      }
    }



  }
}

