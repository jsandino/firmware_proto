package com.example.firmware_proto;

import java.util.Map;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "com.eloesports.vagabond/firmware_configuration";


      @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("runCommand")) {
                                String commandName = call.argument("name");
                                byte[] bytes = call.argument("bytes");
                                String callback = call.argument("callback");
                                runCommand(commandName, bytes, channel, callback, result);
                                result.success(true);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private void runCommand(String name, byte[] bytes, MethodChannel channel, String callback, Result result) {
      // After sometime, when the device replies...
      Map<String,Object> arguments = Map.of("name", name, "bytes", bytes);
      channel.invokeMethod(callback, arguments);
    }
}
