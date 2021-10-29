import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences{
  static SharedPreferences _preferences;

  static const _keyScanResult='scanResult';
  static const _keyBarcodeGenerated='barcodeGenerated';

  static Future init() async =>
      _preferences=await SharedPreferences.getInstance();

  static Future setBarcode(String scanResult) async =>
      await _preferences.setString(_keyScanResult, scanResult);

  static Future setBarcodeGenerated(bool barcodeGenerated) async =>
  await _preferences.setBool(_keyBarcodeGenerated, barcodeGenerated);

  static getScanResult() => _preferences.getString(_keyScanResult);
  static getBarcodeGenerated() => _preferences.getBool(_keyBarcodeGenerated);
}