import 'dart:typed_data';

extension DoubleToBinaryExtension on double {
  String toBinary() {
    final buffer = Uint8List(8).buffer;

    final byteData = ByteData.view(buffer);
    byteData.setFloat64(0, this);

    final StringBuffer binary = StringBuffer();
    for (var i = 0; i < 8; i++) {
      final int byte = byteData.getUint8(i);
      for (int j = 7; j >= 0; j--) {
        binary.write((byte >> j) & 1);
      }
    }
    return binary.toString();
  }
}

extension StringBinatyExtension on String {
  double? tryParseBinaryToDouble() {
    if (length != 64) {
      throw ArgumentError('Binary string must be exactly 64 bits long');
    }

    final buffer = Uint8List(8);

    for (int i = 0; i < 8; i++) {
      int byteValue = 0;
      for (int j = 0; j < 8; j++) {
        if (this[i * 8 + j] == '1') {
          byteValue |= 1 << (7 - j);
        }
      }
      buffer[i] = byteValue;
    }

    final byteData = ByteData.view(buffer.buffer);
    return byteData.getFloat64(0);
  }
}
