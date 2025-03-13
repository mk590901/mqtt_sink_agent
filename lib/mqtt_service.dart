import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'client_helper.dart';
import 'mqtt_bridge.dart';
import 'typedef.dart';

class MqttService {

  static const String _server = 'test.mosquitto.org';
  //static const String _server = 'broker.hivemq.com';
  //static const String _server = 'broker.emqx.io';
  //static const String _server = 'mqtt.flespi.io';
  static String flutterClient = ClientHelper.instance()?.clientId()?? 'flutter_client' ;//'flutter_client';
  final MqttServerClient _client = MqttServerClient(_server, flutterClient);
  final VoidCallbackStringBoolString _cb;
  final MQTTBridge bridge;

  late bool unittest = false;
  
  late int mustBeSendPacketsNumber = 0;
  late int sentPacketsNumber = 0;

  MqttService(this._cb, this.bridge) {
    _client.logging(on: false); //  true
    _client.setProtocolV311();
    _client.connectTimeoutPeriod = 2000;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = onDisconnected;
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;
    _client.onUnsubscribed = onUnsubscribed;
  }

  void setUnitTest() {
    unittest = true;
  }

  void connect() {
    if (unittest) {
      return;
    }

    final connMess = MqttConnectMessage()
        .withClientIdentifier(flutterClient)
        .startClean();
    _client.connectionMessage = connMess;

    _client.connect().then((_) {
      if (_client.connectionStatus!.state == MqttConnectionState.connected) {
        _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
          final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
          final String pt = c[0].topic;
          onMessageReceived(pt, recMess);
        });
      }
      else {
        _cb.call('Connect', false, 'Connect: MQTT client connection failed', true);
        print(
            'ERROR MQTT client connection failed - disconnecting, status is ${_client.connectionStatus}');
        disconnect();
      }
    }).catchError((error) {
      _cb.call('Connect', false, 'Connect: $error', true);
      print('Exception: $error');
      disconnect();
    });
    _cb.call('Connect', true, 'Connecting to $_server started', true);
  }

  void disconnect() {
    if (unittest) {
      return;
    }
    _client.disconnect();
  }

  void subscribe(String topic) {
    if (unittest) {
      return;
    }
    try {
      _client.subscribe(topic, MqttQos.atMostOnce);
    }
    catch (exception) {
      _cb.call('Subscribe', false, 'Subscribe', true);
    }
  }

  void unsubscribe(String topic) {
    if (unittest) {
      return;
    }
    _client.unsubscribe(topic);
  }

  void publish(String topic, List<String> messages) {
    if (unittest) {
      return;
    }

    mustBeSendPacketsNumber = messages.length;
    sentPacketsNumber = 0;

    for (int i = 0; i < messages.length; i++) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(messages[i]);
      try {
        _client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
        //_cb.call('Publish', true, 'Publish', true);
      }
      catch (exception) {
        _cb.call('Publish', false, 'Publish', true);
      }
    }
    _cb.call('Publish', true, 'Publish', true);
  }

  // void publish(String topic, String message) {
  //   if (unittest) {
  //     return;
  //   }
  //   final builder = MqttClientPayloadBuilder();
  //   builder.addString(message);
  //   try {
  //     _client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  //     _cb.call('Publish', true, 'Publish', true);
  //   }
  //   catch (exception) {
  //     _cb.call('Publish', false, 'Publish', true);
  //   }
  // }

  void onMessageReceived(String topic, MqttPublishMessage message) {
    final String payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
    sentPacketsNumber++;
    //print('Received message: $payload from topic: $topic [$sentPacketsNumber]:[$mustBeSendPacketsNumber]');
    print('Received message: from topic: $topic [$sentPacketsNumber]:[$mustBeSendPacketsNumber]');
    _cb.call('Publish', true, payload, true);
    if (sentPacketsNumber == mustBeSendPacketsNumber) {
      bridge.post('Unsubscribe');
    }
  }

  void onConnected() {
    print('******* onConnected $_server *******');
    _cb.call('Connect', true, 'Connected to $_server', true);
    bridge.post('Subscribe');
  }

  void onDisconnected() {
    print('******* onDisconnected ******* [${bridge.state()}]');
    _cb.call('Disconnect', true, 'Disconnected from $_server', false);
    if (bridge.isConnected()) {
      bridge.post('Disconnect');
    }
   }

  void onSubscribed(String topic) {
    print('******* onSubscribed to topic: $topic *******');
    _cb.call('Subscribe', true, 'Subscribed to $topic', true);
    bridge.post('Publish');
  }

  void onUnsubscribed(String? topic) {
    print('***!*** onUnsubscribed from topic: $topic ***!*** ${bridge.state()}');
    _cb.call('Unsubscribe', true, 'Unsubscribed from $topic', false);
    if (bridge.isSubscribed()) {
      bridge.post('Unsubscribe');
    }
    bridge.post('Disconnect');
  }

}