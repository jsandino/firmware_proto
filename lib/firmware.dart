import 'package:firmware_proto/command.dart';

///
/// Basic representation of a device firmware version.
///
typedef Data = Map<String, dynamic>;

class Firmware {
  final int version;
  final List<Command> commands;

  Firmware({required this.version, required this.commands});

  /// A factory method for dynamic creation of Firmaware instances from data.
  ///
  /// The main idea is to provide a mechanism to dynamicall construct a
  /// firmware-to-commands mapping that can be sent to both, iOS and Android.
  ///
  factory Firmware.from(Data data) {
    return Firmware(
        version: data['version'], commands: _createCommands(data['commands']));
  }

  static List<Command> _createCommands(Data data) {
    // This would need proper error handling...
    List<Command> commands = [];
    data.forEach((name, values) {
      if (values is List<int>) {
        commands.add(Command(name: name, bytes: values));
      }
    });
    return commands;
  }

  static Map<int, Firmware> get versions {
    return {
      1: firmwareVersion1,
      2: firmwareVersion2,
    };
  }

  static Firmware get firmwareVersion1 {
    return Firmware(version: 1, commands: [
      Command(name: 'get_state', bytes: [0x12, 0x01, 0x10]),
      Command(name: 'turn_on', bytes: [0x12, 0x01, 0x20, 0x01]),
      Command(name: 'turn_off', bytes: [0x12, 0x01, 0x20, 0x00]),
    ]);
  }

  static Firmware get firmwareVersion2 {
    return Firmware(version: 2, commands: [
      Command(name: 'status', bytes: [0x11, 0x02, 0x20]),
      Command(name: 'increase', bytes: [0x13, 0x01, 0x21]),
      Command(name: 'decrease', bytes: [0x10, 0x020, 0x00, 0x20]),
    ]);
  }
}
