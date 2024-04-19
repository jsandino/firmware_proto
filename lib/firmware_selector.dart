import 'package:firmware_proto/command_panel.dart';
import 'package:flutter/material.dart';

///
/// Prototype interface for selecting different Firmware versions.
///
/// The objective is to showcase how to execute different commands based on a
/// given firmware version.  The two sample firmware versions are hardcoded for
/// demonstration purposes - these can easily be fetched dynamically at runtime.
///
class FirmwareSelector extends StatefulWidget {
  const FirmwareSelector({super.key});

  @override
  State<FirmwareSelector> createState() => _FirmwareSelectorState();
}

class _FirmwareSelectorState extends State<FirmwareSelector> {
  int _firmwareVersion = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firmware Selection Prototype'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text('Select your Firmware Version'),
            const SizedBox(height: 50),
            ButtonBar(onSelection: _onVersionSelected),
            const SizedBox(height: 50),
            const Divider(indent: 40, endIndent: 40),
            CommandPanel(
              firmwareVersion: _firmwareVersion,
              key: ValueKey(_firmwareVersion),
            ),
          ],
        ),
      ),
    );
  }

  void _onVersionSelected(int version) {
    setState(() {
      _firmwareVersion = version;
    });
  }
}

class ButtonBar extends StatelessWidget {
  final Function onSelection;
  const ButtonBar({required this.onSelection, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => onSelection(1),
          child: const Text('Version 1'),
        ),
        const SizedBox(width: 50),
        ElevatedButton(
          onPressed: () => onSelection(2),
          child: const Text('Version 2'),
        ),
      ],
    );
  }
}
