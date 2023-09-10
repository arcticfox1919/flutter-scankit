
const scanTypeAll = (1<<13)-1;

const ScanResult _empty = ScanResult('',ScanTypes.all);

class ScanResult {
  final String originalValue;
  final ScanTypes scanType;

  const ScanResult(this.originalValue,this.scanType);

  ScanResult.from(Map map)
      : originalValue = map["originalValue"] ?? '',
        scanType = ScanTypes.getByValue(map["scanType"] ?? scanTypeAll);

  factory ScanResult.empty(){
    return _empty;
  }

  bool get isEmpty => originalValue.isEmpty;
  bool get isNotEmpty => originalValue.isNotEmpty;

  @override
  String toString() => '[$scanType] : $originalValue';
}

class ScanTypes {
  final int bit;
  final String name;

  const ScanTypes._(this.bit, this.name);

  static const ScanTypes aztec = ScanTypes._(1 << 0, "Aztec");
  static const ScanTypes codaBar = ScanTypes._(1 << 1, "Codabar");
  static const ScanTypes code39 = ScanTypes._(1 << 2, "Code39");
  static const ScanTypes code93 = ScanTypes._(1 << 3, "Code93");
  static const ScanTypes code128 = ScanTypes._(1 << 4, "Code128");
  static const ScanTypes dataMatrix = ScanTypes._(1 << 5, "DataMatrix");
  static const ScanTypes ean8 = ScanTypes._(1 << 6, "EAN-8");
  static const ScanTypes ean13 = ScanTypes._(1 << 7, "EAN-13");
  static const ScanTypes itf14 = ScanTypes._(1 << 8, "ITF14");
  static const ScanTypes pdf417 = ScanTypes._(1 << 9, "PDF417");
  static const ScanTypes qRCode = ScanTypes._(1 << 10, "QRCode");
  static const ScanTypes upcCodeA = ScanTypes._(1 << 11, "UPC-A");
  static const ScanTypes upcCodeE = ScanTypes._(1 << 12, "UPC-E");

  static const ScanTypes all = ScanTypes._(scanTypeAll, "All");

  static const Map<int, ScanTypes> _map = {
    1 << 0: aztec,
    1 << 1: codaBar,
    1 << 2: code39,
    1 << 3: code93,
    1 << 4: code128,
    1 << 5: dataMatrix,
    1 << 6: ean8,
    1 << 7: ean13,
    1 << 8: itf14,
    1 << 9: pdf417,
    1 << 10: qRCode,
    1 << 11: upcCodeA,
    1 << 12: upcCodeE,
    scanTypeAll: all
  };

  static ScanTypes getByValue(int value) {
    var r = _map[value];
    if (r == null) {
      throw Exception("`value` Not a supported ScanTypes!");
    }
    return r;
  }

  @override
  String toString() => name;
}
