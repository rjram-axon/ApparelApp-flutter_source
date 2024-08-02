import 'package:encrypt/encrypt.dart';
import 'package:intl/intl.dart';

var currencyFormat = NumberFormat.currency(
  symbol: '₹ ', // currency symbol
  decimalDigits: 2, // number of decimal digits
);

class AxonFunction {
  String encrypt(String data) {
    late String plainText = data;
    final key = Key.fromUtf8('MAKV2SPBNI99212');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    late String encrypted = encrypter.encrypt(plainText, iv: iv) as String;
    return encrypted;

    //late String decrypted = encrypter.decrypt(encrypted, iv: iv) as String;
    //print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    //print(encrypted.base64); // R4PxiU3h8YoIRqVowBXm36ZcCeNeZ4s1OvVBTfFlZRdmohQqOpPQqD1YecJeZMAop/hZ4OxqgC1WtwvX/hP9mw==
  }

  String decrypt(Encrypted data) {
    final key = Key.fromUtf8('MAKV2SPBNI99212');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    late String decrypted = encrypter.decrypt(data, iv: iv);
    return decrypted.toString();

    //late String decrypted = encrypter.decrypt(data, iv: iv) as String;
    //print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    //print(encrypted.base64); // R4PxiU3h8YoIRqVowBXm36ZcCeNeZ4s1OvVBTfFlZRdmohQqOpPQqD1YecJeZMAop/hZ4OxqgC1WtwvX/hP9mw==
  }

  String currecyformat(dynamic data) {
    return currencyFormat.format(data);
  }

  String formatenumber(dynamic data) {
    var number = NumberFormat.currency(
      symbol: "",
      decimalDigits: 2,
    );
    return number.format(data);
  }
}
