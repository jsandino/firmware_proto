import 'dart:typed_data';

///
/// A Firmware Command.
///
/// Associates a textual label with a sequence of bytes to execute a device command.
///
class Command {
  final String name;
  final Uint8List bytes;

  Command({required this.name, required List<int> bytes})
      : bytes = Uint8List.fromList(bytes);
}
