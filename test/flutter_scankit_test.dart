import 'package:flutter_scankit/flutter_scankit.dart';
import 'package:flutter_test/flutter_test.dart';

List scanTypesName = [
  "AZTEC_SCAN_TYPE",
  "CODABAR_SCAN_TYPE",
  "CODE39_SCAN_TYPE",
  "CODE93_SCAN_TYPE",
  "CODE128_SCAN_TYPE",
  "DATAMATRIX_SCAN_TYPE",
  "EAN8_SCAN_TYPE",
  "EAN13_SCAN_TYPE",
  "ITF14_SCAN_TYPE",
  "PDF417_SCAN_TYPE",
  "QRCODE_SCAN_TYPE",
  "UPCCODE_A_SCAN_TYPE",
  "UPCCODE_E_SCAN_TYPE",
];

void main() {
  group('ScanTypes', () {
    test('Tests for ScanTypes bit', () {
      expect(ScanTypes.aztec.bit, equals(0x1));
      expect(ScanTypes.codaBar.bit, equals(0x2));
      expect(ScanTypes.code39.bit, equals(0x4));
      expect(ScanTypes.code93.bit, equals(0x8));
      expect(ScanTypes.code128.bit, equals(0x10));
      expect(ScanTypes.dataMatrix.bit, equals(0x20));
      expect(ScanTypes.ean8.bit, equals(0x40));
      expect(ScanTypes.ean13.bit, equals(0x80));
      expect(ScanTypes.itf14.bit, equals(0x100));
      expect(ScanTypes.pdf417.bit, equals(0x200));
      expect(ScanTypes.qRCode.bit, equals(0x400));
      expect(ScanTypes.upcCodeA.bit, equals(0x800));
      expect(ScanTypes.upcCodeE.bit, equals(0x1000));
      expect(ScanTypes.all.bit, equals(0x1fff));
    });
  });

  group('ScanTypes', () {
    test('Tests for ScanTypes flags', () {
      expect(getListFromFlags(ScanTypes.aztec.bit | ScanTypes.codaBar.bit),
          equals(["AZTEC_SCAN_TYPE", "CODABAR_SCAN_TYPE"]));

      expect(
          getListFromFlags(ScanTypes.aztec.bit |
              ScanTypes.codaBar.bit |
              ScanTypes.code39.bit),
          equals(["AZTEC_SCAN_TYPE", "CODABAR_SCAN_TYPE","CODE39_SCAN_TYPE"]));

      expect(
          getListFromFlags(ScanTypes.aztec.bit |
              ScanTypes.codaBar.bit |
              ScanTypes.code39.bit |
              ScanTypes.code93.bit),
          equals(["AZTEC_SCAN_TYPE", "CODABAR_SCAN_TYPE","CODE39_SCAN_TYPE", "CODE93_SCAN_TYPE"]));

      expect(
          getListFromFlags(ScanTypes.aztec.bit |
              ScanTypes.codaBar.bit |
              ScanTypes.code39.bit |
              ScanTypes.code93.bit |
              ScanTypes.code128.bit),
          equals([
            "AZTEC_SCAN_TYPE",
            "CODABAR_SCAN_TYPE",
            "CODE39_SCAN_TYPE",
            "CODE93_SCAN_TYPE",
            "CODE128_SCAN_TYPE"
          ]));

      expect(
          getListFromFlags(ScanTypes.aztec.bit |
              ScanTypes.codaBar.bit |
              ScanTypes.code39.bit |
              ScanTypes.code93.bit |
              ScanTypes.code128.bit |
              ScanTypes.dataMatrix.bit),
          equals([
            "AZTEC_SCAN_TYPE",
            "CODABAR_SCAN_TYPE",
            "CODE39_SCAN_TYPE",
            "CODE93_SCAN_TYPE",
            "CODE128_SCAN_TYPE",
            "DATAMATRIX_SCAN_TYPE"
          ]));

      expect(
          getListFromFlags(ScanTypes.aztec.bit |
              ScanTypes.codaBar.bit |
              ScanTypes.code39.bit |
              ScanTypes.code93.bit |
              ScanTypes.code128.bit |
              ScanTypes.dataMatrix.bit |
              ScanTypes.ean8.bit),
          equals([
            "AZTEC_SCAN_TYPE",
            "CODABAR_SCAN_TYPE",
            "CODE39_SCAN_TYPE",
            "CODE93_SCAN_TYPE",
            "CODE128_SCAN_TYPE",
            "DATAMATRIX_SCAN_TYPE",
            "EAN8_SCAN_TYPE"
          ]));

      expect(
          getListFromFlags(ScanTypes.aztec.bit |
              ScanTypes.codaBar.bit |
              ScanTypes.code39.bit |
              ScanTypes.code93.bit |
              ScanTypes.code128.bit |
              ScanTypes.dataMatrix.bit |
              ScanTypes.ean8.bit |
              ScanTypes.ean13.bit),
          equals([
            "AZTEC_SCAN_TYPE",
            "CODABAR_SCAN_TYPE",
            "CODE39_SCAN_TYPE",
            "CODE93_SCAN_TYPE",
            "CODE128_SCAN_TYPE",
            "DATAMATRIX_SCAN_TYPE",
            "EAN8_SCAN_TYPE",
            "EAN13_SCAN_TYPE"
          ]));

      expect(
          getListFromFlags(ScanTypes.aztec.bit |
              ScanTypes.codaBar.bit |
              ScanTypes.code39.bit |
              ScanTypes.code93.bit |
              ScanTypes.code128.bit |
              ScanTypes.dataMatrix.bit |
              ScanTypes.ean8.bit |
              ScanTypes.ean13.bit |
              ScanTypes.itf14.bit),
          equals([
            "AZTEC_SCAN_TYPE",
            "CODABAR_SCAN_TYPE",
            "CODE39_SCAN_TYPE",
            "CODE93_SCAN_TYPE",
            "CODE128_SCAN_TYPE",
            "DATAMATRIX_SCAN_TYPE",
            "EAN8_SCAN_TYPE",
            "EAN13_SCAN_TYPE",
            "ITF14_SCAN_TYPE"
          ]));

      expect(
          getListFromFlags(ScanTypes.aztec.bit |
              ScanTypes.codaBar.bit |
              ScanTypes.code39.bit |
              ScanTypes.code93.bit |
              ScanTypes.code128.bit |
              ScanTypes.dataMatrix.bit |
              ScanTypes.ean8.bit |
              ScanTypes.ean13.bit |
              ScanTypes.itf14.bit |
              ScanTypes.pdf417.bit),
          equals([
            "AZTEC_SCAN_TYPE",
            "CODABAR_SCAN_TYPE",
            "CODE39_SCAN_TYPE",
            "CODE93_SCAN_TYPE",
            "CODE128_SCAN_TYPE",
            "DATAMATRIX_SCAN_TYPE",
            "EAN8_SCAN_TYPE",
            "EAN13_SCAN_TYPE",
            "ITF14_SCAN_TYPE",
            "PDF417_SCAN_TYPE"
          ]));

      expect(
          getListFromFlags(ScanTypes.aztec.bit |
              ScanTypes.codaBar.bit |
              ScanTypes.code39.bit |
              ScanTypes.code93.bit |
              ScanTypes.code128.bit |
              ScanTypes.dataMatrix.bit |
              ScanTypes.ean8.bit |
              ScanTypes.ean13.bit |
              ScanTypes.itf14.bit |
              ScanTypes.pdf417.bit |
              ScanTypes.qRCode.bit),
          equals([
            "AZTEC_SCAN_TYPE",
            "CODABAR_SCAN_TYPE",
            "CODE39_SCAN_TYPE",
            "CODE93_SCAN_TYPE",
            "CODE128_SCAN_TYPE",
            "DATAMATRIX_SCAN_TYPE",
            "EAN8_SCAN_TYPE",
            "EAN13_SCAN_TYPE",
            "ITF14_SCAN_TYPE",
            "PDF417_SCAN_TYPE",
            "QRCODE_SCAN_TYPE"
          ]));

      expect(
          getListFromFlags(ScanTypes.aztec.bit |
              ScanTypes.codaBar.bit |
              ScanTypes.code39.bit |
              ScanTypes.code93.bit |
              ScanTypes.code128.bit |
              ScanTypes.dataMatrix.bit |
              ScanTypes.ean8.bit |
              ScanTypes.ean13.bit |
              ScanTypes.itf14.bit |
              ScanTypes.pdf417.bit |
              ScanTypes.qRCode.bit |
              ScanTypes.upcCodeA.bit),
          equals([
            "AZTEC_SCAN_TYPE",
            "CODABAR_SCAN_TYPE",
            "CODE39_SCAN_TYPE",
            "CODE93_SCAN_TYPE",
            "CODE128_SCAN_TYPE",
            "DATAMATRIX_SCAN_TYPE",
            "EAN8_SCAN_TYPE",
            "EAN13_SCAN_TYPE",
            "ITF14_SCAN_TYPE",
            "PDF417_SCAN_TYPE",
            "QRCODE_SCAN_TYPE",
            "UPCCODE_A_SCAN_TYPE"
          ]));

      expect(
          getListFromFlags(ScanTypes.aztec.bit |
              ScanTypes.codaBar.bit |
              ScanTypes.code39.bit |
              ScanTypes.code93.bit |
              ScanTypes.code128.bit |
              ScanTypes.dataMatrix.bit |
              ScanTypes.ean8.bit |
              ScanTypes.ean13.bit |
              ScanTypes.itf14.bit |
              ScanTypes.pdf417.bit |
              ScanTypes.qRCode.bit |
              ScanTypes.upcCodeA.bit |
              ScanTypes.upcCodeE.bit),
          equals([
            "ALL_SCAN_TYPE"
          ]));
    });
  });

  group('ScanTypes', () {
    test('Tests ScanTypes name to flags', () {
      expect(nameToFlags("AZTEC_SCAN_TYPE"), equals(0x1));
      expect(nameToFlags("CODABAR_SCAN_TYPE"), equals(0x2));
      expect(nameToFlags("CODE39_SCAN_TYPE"), equals(0x4));
      expect(nameToFlags("CODE93_SCAN_TYPE"), equals(0x8));
      expect(nameToFlags("CODE128_SCAN_TYPE"), equals(0x10));
      expect(nameToFlags("DATAMATRIX_SCAN_TYPE"), equals(0x20));
      expect(nameToFlags("EAN8_SCAN_TYPE"), equals(0x40));
      expect(nameToFlags("EAN13_SCAN_TYPE"), equals(0x80));
      expect(nameToFlags("ITF14_SCAN_TYPE"), equals(0x100));
      expect(nameToFlags("PDF417_SCAN_TYPE"), equals(0x200));
      expect(nameToFlags("QRCODE_SCAN_TYPE"), equals(0x400));
      expect(nameToFlags("UPCCODE_A_SCAN_TYPE"), equals(0x800));
      expect(nameToFlags("UPCCODE_E_SCAN_TYPE"), equals(0x1000));
      expect(nameToFlags("ALL_SCAN_TYPE"), equals(0x1fff));
    });
  });
}

List<String> getListFromFlags(int flags) {
  if (flags == ScanTypes.all.bit) {
    return ["ALL_SCAN_TYPE"];
  }
  var types = <String>[];
  for (int i = 0; i < 64; i++) {
    int mask = 1 << i;
    if ((flags & mask) != 0) {
      types.add(scanTypesName[i]);
    }
  }
  return types;
}

String getNameFromFlags(int flags) {
  if (flags == ScanTypes.all.bit) {
    return "ALL_SCAN_TYPE";
  }
  for (int i = 0; i < 64; i++) {
    int mask = 1 << i;
    if ((flags & mask) != 0) {
      return scanTypesName[i];
    }
  }
  return "ALL_SCAN_TYPE";
}

int nameToFlags(String name) {
  for (int i = 0; i < scanTypesName.length; i++) {
    if (scanTypesName[i] == name) {
      int mask = 1 << i;
      return mask;
    }
  }
  return 0x1fff;
}
