import 'package:firmware_proto/command.dart';
import 'package:firmware_proto/firmware.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// Encapsulates a set of firmware-specific command buttons.
///
class CommandPanel extends StatefulWidget {
  final int firmwareVersion;
  const CommandPanel({required this.firmwareVersion, super.key});

  @override
  State<CommandPanel> createState() => _CommandPanelState();
}

class _CommandPanelState extends State<CommandPanel> {
  // Platform channel interfacing to the device via native (ios/android) layer
  static const channel =
      MethodChannel('com.eloesports.vagabond/firmware_configuration');

  late Firmware firmware;

  @override
  void initState() {
    firmware =
        Firmware.versions[widget.firmwareVersion] ?? Firmware.firmwareVersion1;

    channel.setMethodCallHandler(_channelHandler);
    super.initState();
  }

  ///
  /// Callback handler to receive messages back to Flutter from native layer.
  ///
  /// This gets executed asynchronously after every command invocation.
  ///
  Future<dynamic> _channelHandler(MethodCall call) async {
    if (call.method == 'commandStatus') {
      final command = call.arguments['name'];
      final bytes = call.arguments['bytes'];
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Executed "$command", bytes: $bytes',
              style: const TextStyle(color: Colors.yellow),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...firmware.commands.map(
          (command) => Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: color),
              onPressed: () => sendCommand(command),
              child: Text(command.name,
                  style: const TextStyle(color: Colors.black)),
            ),
          ),
        )
      ],
    );
  }

  ///
  /// Sends a command to the native layer.
  ///
  void sendCommand(Command command) async {
    return await channel.invokeMethod(
      'runCommand',
      {
        'name': command.name,
        'bytes': command.bytes,
        'callback': 'commandStatus'
      },
    );
  }

  Color? get color =>
      widget.firmwareVersion == 1 ? Colors.blue[200] : Colors.green[200];
}
