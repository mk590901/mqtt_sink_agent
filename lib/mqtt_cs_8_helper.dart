//	Class Mqtt_cs_8Helper automatically generated at 2025-02-13 12:20:09
import '../core/q_hsm_helper.dart';
import '../core/threaded_code_executor.dart';
import 'mqtt_bridge.dart';
import 'mqtt_client.dart';
import 'typedef.dart';

class MqttHelper {
	final QHsmHelper	helper_ = QHsmHelper('MQTTClientServer');
	final VoidCallbackStringBoolString callbackFunction;
	final MQTTBridge bridge;

	late 	MQTTClient mqttClient;

	void response(String tag, bool ok, String text, bool next) {
		//print('- MqttHelper.response->[$text]->[$ok] [${helper_.getState()}] =');
		callbackFunction.call(tag,ok,text,next);
		//print('+ MqttHelper.response->[$text]->[$ok] [${helper_.getState()}] +');
	}

	MqttHelper (this.callbackFunction, this.bridge) {
		mqttClient = MQTTClient(response, bridge);
		createHelper();
	}

	// void mQTTClientServerEntry([Object? data]) {
	// }
	//
	// void mQTTClientServerInit([Object? data]) {
	// }
	//
	// void disconnectedEntry([Object? data]) {
	// }

	void disconnectedConnect ([Object? data]){
		mqttClient.connect();
	}

	// void connectingEntry([Object? data]) {
	// }

	void disconnectedDisconnect([Object? data]) {
		callbackFunction.call('Disconnect', true,'Already disconnected', false);
	}

	// void disconnectedExit([Object? data]) {
	// }

	void disconnectedSubscribe([Object? data]) {
		callbackFunction.call('Subscribe', false,'Not connected', false);
	}

	void disconnectedPublish([Object? data]) {
		callbackFunction.call('Publish', false,'Not connected', false);
	}

	void disconnectedUnsubscribe([Object? data]) {
		callbackFunction.call('Unsubscribe', false,'Not connected', false);
	}

	// void connectedExit([Object? data]) {
	// }

	void connectedDisconnect([Object? data]) {
		mqttClient.disconnect();
	}

	void awaitSubscribeConnect([Object? data]) {
		callbackFunction.call('Connect', true,'Already connected', false);
	}

	// void awaitSubscribeExit([Object? data]) {
	// }
	//
	// void awaitSubscribeEntry([Object? data]) {
	// }

	void awaitSubscribeSubscribe([Object? data]) {
		mqttClient.subscribe();
	}

	// void subscribingEntry([Object? data]) {
	// }

	void awaitSubscribePublish([Object? data]) {
		callbackFunction.call('Publish', true,'No subscribed', false);
	}

	void awaitSubscribeUnsubscribe([Object? data]) {
		callbackFunction.call('Unsubscribe', true,'No subscribed', false);
	}

	// void subscribedExit([Object? data]) {
	// }

	void subscribedUnsubscribe([Object? data]) {
		mqttClient.unsubscribe();
	}

	// void connectedInit([Object? data]) {
	// }

	void awaitPublishingConnect([Object? data]) {
		callbackFunction.call('Connect', true,'Already connected', false);
	}

	// void awaitPublishingExit([Object? data]) {
	// }
	//
	// void awaitPublishingEntry([Object? data]) {
	// }

	void awaitPublishingSubscribe([Object? data]) {
		callbackFunction.call('Subscribe', true,'Already subscribed', false);
	}

	void awaitPublishingPublish([Object? data]) {
		mqttClient.publish();
	}

	// void publishingEntry([Object? data]) {
	// }
	//
	// void publishingExit([Object? data]) {
	// }
	//
	// void publishingFailed([Object? data]) {
	// }
	//
	// void subscribedInit([Object? data]) {
	// }
	//
	// void publishingSucceeded([Object? data]) {
	// }
	//
	// void subscribingExit([Object? data]) {
	// }
	//
	// void subscribingFailed([Object? data]) {
	// }
	//
	// void subscribingSucceeded([Object? data]) {
	// }
	//
	// void subscribedEntry([Object? data]) {
	// }
	//
	// void connectingExit([Object? data]) {
	// }
	//
	// void connectingFailed([Object? data]) {
	// }
	//
	// void connectingSucceeded([Object? data]) {
	// }
	//
	// void connectedEntry([Object? data]) {
	// }

	void init() {
		helper_.post('init');
	}

	void run(final String eventName) {
		helper_.post(eventName);
	}

	String state() {
		return helper_.getState();
	}

	void createHelper() {
		helper_.insert('MQTTClientServer', 'init', ThreadedCodeExecutor(helper_, 'Disconnected', [
			// mQTTClientServerEntry,
			// mQTTClientServerInit,
			// disconnectedEntry,
		]));
		helper_.insert('Disconnected', 'Connect', ThreadedCodeExecutor(helper_, 'Connecting', [
			disconnectedConnect,
			// connectingEntry,
		]));
		helper_.insert('Disconnected', 'Disconnect', ThreadedCodeExecutor(helper_, 'Disconnected', [
			disconnectedDisconnect,
			// disconnectedExit,
			// disconnectedEntry,
		]));
		helper_.insert('Disconnected', 'Subscribe', ThreadedCodeExecutor(helper_, 'Disconnected', [
			disconnectedSubscribe,
			// disconnectedExit,
			// disconnectedEntry,
		]));
		helper_.insert('Disconnected', 'Publish', ThreadedCodeExecutor(helper_, 'Disconnected', [
			disconnectedPublish,
			// disconnectedExit,
			// disconnectedEntry,
		]));
		helper_.insert('Disconnected', 'Unsubscribe', ThreadedCodeExecutor(helper_, 'Disconnected', [
			disconnectedUnsubscribe,
			// disconnectedExit,
			// disconnectedEntry,
		]));
		helper_.insert('Connected', 'Connect', ThreadedCodeExecutor(helper_, 'Connecting', [
			//disconnectedConnect,
			//connectedExit,
			//connectingEntry,
		]));
		helper_.insert('Connected', 'Disconnect', ThreadedCodeExecutor(helper_, 'Disconnected', [
			connectedDisconnect,
			// connectedExit,
			// disconnectedExit,
			// mQTTClientServerInit,
			// disconnectedEntry,
		]));
		helper_.insert('Connected', 'Subscribe', ThreadedCodeExecutor(helper_, 'Disconnected', [
			disconnectedSubscribe,
			// connectedExit,
			// disconnectedExit,
			// disconnectedEntry,
		]));
		helper_.insert('Connected', 'Publish', ThreadedCodeExecutor(helper_, 'Disconnected', [
			disconnectedPublish,
			// connectedExit,
			// disconnectedExit,
			// disconnectedEntry,
		]));
		helper_.insert('Connected', 'Unsubscribe', ThreadedCodeExecutor(helper_, 'Disconnected', [
			disconnectedUnsubscribe,
			// connectedExit,
			// disconnectedExit,
			// disconnectedEntry,
		]));
		helper_.insert('AwaitSubscribe', 'Connect', ThreadedCodeExecutor(helper_, 'AwaitSubscribe', [
			awaitSubscribeConnect,
			// awaitSubscribeExit,
			// awaitSubscribeEntry,
		]));
		helper_.insert('AwaitSubscribe', 'Disconnect', ThreadedCodeExecutor(helper_, 'Disconnected', [
			connectedDisconnect,
			// awaitSubscribeExit,
			// connectedExit,
			// disconnectedExit,
			// mQTTClientServerInit,
			// disconnectedEntry,
		]));
		helper_.insert('AwaitSubscribe', 'Subscribe', ThreadedCodeExecutor(helper_, 'Subscribing', [
			awaitSubscribeSubscribe,
			// subscribingEntry,
		]));
		helper_.insert('AwaitSubscribe', 'Publish', ThreadedCodeExecutor(helper_, 'AwaitSubscribe', [
			awaitSubscribePublish,
			// awaitSubscribeExit,
			// awaitSubscribeEntry,
		]));
		helper_.insert('AwaitSubscribe', 'Unsubscribe', ThreadedCodeExecutor(helper_, 'AwaitSubscribe', [
			awaitSubscribeUnsubscribe,
			// awaitSubscribeExit,
			// awaitSubscribeEntry,
		]));
		helper_.insert('Subscribed', 'Connect', ThreadedCodeExecutor(helper_, 'AwaitSubscribe', [
			awaitSubscribeConnect,
			// subscribedExit,
			// awaitSubscribeExit,
			// awaitSubscribeEntry,
		]));
		helper_.insert('Subscribed', 'Disconnect', ThreadedCodeExecutor(helper_, 'Disconnected', [
			connectedDisconnect,
			// subscribedExit,
			// awaitSubscribeExit,
			// connectedExit,
			// disconnectedExit,
			// mQTTClientServerInit,
			// disconnectedEntry,
		]));
		helper_.insert('Subscribed', 'Subscribe', ThreadedCodeExecutor(helper_, 'Subscribing', [
			awaitSubscribeSubscribe,
			// subscribedExit,
			// subscribingEntry,
		]));
		helper_.insert('Subscribed', 'Publish', ThreadedCodeExecutor(helper_, 'AwaitSubscribe', [
			awaitSubscribePublish,
			// subscribedExit,
			// awaitSubscribeExit,
			// awaitSubscribeEntry,
		]));
		helper_.insert('Subscribed', 'Unsubscribe', ThreadedCodeExecutor(helper_, 'AwaitSubscribe', [
			subscribedUnsubscribe,
			// subscribedExit,
			// awaitSubscribeExit,
			// connectedInit,
			// awaitSubscribeEntry,
		]));
		helper_.insert('AwaitPublishing', 'Connect', ThreadedCodeExecutor(helper_, 'AwaitPublishing', [
			awaitPublishingConnect,
			// awaitPublishingExit,
			// awaitPublishingEntry,
		]));
		helper_.insert('AwaitPublishing', 'Disconnect', ThreadedCodeExecutor(helper_, 'Disconnected', [
			connectedDisconnect,
			// awaitPublishingExit,
			// subscribedExit,
			// awaitSubscribeExit,
			// connectedExit,
			// disconnectedExit,
			// mQTTClientServerInit,
			// disconnectedEntry,
		]));
		helper_.insert('AwaitPublishing', 'Subscribe', ThreadedCodeExecutor(helper_, 'AwaitPublishing', [
			awaitPublishingSubscribe,
			// awaitPublishingExit,
			// awaitPublishingEntry,
		]));
		helper_.insert('AwaitPublishing', 'Publish', ThreadedCodeExecutor(helper_, 'Publishing', [
			awaitPublishingPublish,
			// publishingEntry,
		]));
		helper_.insert('AwaitPublishing', 'Unsubscribe', ThreadedCodeExecutor(helper_, 'AwaitSubscribe', [
			subscribedUnsubscribe,
			// awaitPublishingExit,
			// subscribedExit,
			// awaitSubscribeExit,
			// connectedInit,
			// awaitSubscribeEntry,
		]));
		helper_.insert('Publishing', 'Connect', ThreadedCodeExecutor(helper_, 'AwaitPublishing', [
			awaitPublishingConnect,
			// publishingExit,
			// awaitPublishingExit,
			// awaitPublishingEntry,
		]));
		helper_.insert('Publishing', 'Disconnect', ThreadedCodeExecutor(helper_, 'Disconnected', [
			connectedDisconnect,
			// publishingExit,
			// awaitPublishingExit,
			// subscribedExit,
			// awaitSubscribeExit,
			// connectedExit,
			// disconnectedExit,
			// mQTTClientServerInit,
			// disconnectedEntry,
		]));
		helper_.insert('Publishing', 'Subscribe', ThreadedCodeExecutor(helper_, 'AwaitPublishing', [
			awaitPublishingSubscribe,
			// publishingExit,
			// awaitPublishingExit,
			// awaitPublishingEntry,
		]));
		helper_.insert('Publishing', 'Publish', ThreadedCodeExecutor(helper_, 'Publishing', [
			awaitPublishingPublish,
			// publishingExit,
			// publishingEntry,
		]));
		helper_.insert('Publishing', 'Unsubscribe', ThreadedCodeExecutor(helper_, 'AwaitSubscribe', [
			subscribedUnsubscribe,
			// publishingExit,
			// awaitPublishingExit,
			// subscribedExit,
			// awaitSubscribeExit,
			// connectedInit,
			// awaitSubscribeEntry,
		]));
		helper_.insert('Publishing', 'Failed', ThreadedCodeExecutor(helper_, 'AwaitPublishing', [
			// publishingFailed,
			// publishingExit,
			// awaitPublishingExit,
			// subscribedInit,
			// awaitPublishingEntry,
		]));
		helper_.insert('Publishing', 'Succeeded', ThreadedCodeExecutor(helper_, 'AwaitPublishing', [
			// publishingSucceeded,
			// publishingExit,
			// awaitPublishingExit,
			// subscribedInit,
			// awaitPublishingEntry,
		]));
		helper_.insert('Subscribing', 'Connect', ThreadedCodeExecutor(helper_, 'AwaitSubscribe', [
			awaitSubscribeConnect,
			// subscribingExit,
			// awaitSubscribeExit,
			// awaitSubscribeEntry,
		]));
		helper_.insert('Subscribing', 'Disconnect', ThreadedCodeExecutor(helper_, 'Disconnected', [
			connectedDisconnect,
			// subscribingExit,
			// awaitSubscribeExit,
			// connectedExit,
			// disconnectedExit,
			// mQTTClientServerInit,
			// disconnectedEntry,
		]));
		helper_.insert('Subscribing', 'Subscribe', ThreadedCodeExecutor(helper_, 'Subscribing', [
			awaitSubscribeSubscribe,
			// subscribingExit,
			// subscribingEntry,
		]));
		helper_.insert('Subscribing', 'Publish', ThreadedCodeExecutor(helper_, 'AwaitSubscribe', [
			awaitSubscribePublish,
			// subscribingExit,
			// awaitSubscribeExit,
			// awaitSubscribeEntry,
		]));
		helper_.insert('Subscribing', 'Unsubscribe', ThreadedCodeExecutor(helper_, 'AwaitSubscribe', [
			awaitSubscribeUnsubscribe,
			// subscribingExit,
			// awaitSubscribeExit,
			// awaitSubscribeEntry,
		]));
		helper_.insert('Subscribing', 'Failed', ThreadedCodeExecutor(helper_, 'AwaitSubscribe', [
			// subscribingFailed,
			// subscribingExit,
			// awaitSubscribeExit,
			// connectedInit,
			// awaitSubscribeEntry,
		]));
		helper_.insert('Subscribing', 'Succeeded', ThreadedCodeExecutor(helper_, 'AwaitPublishing', [
			// subscribingSucceeded,
			// subscribingExit,
			// subscribedEntry,
			// subscribedInit,
			// awaitPublishingEntry,
		]));
		helper_.insert('Connecting', 'Connect', ThreadedCodeExecutor(helper_, 'Connecting', [
			disconnectedConnect,
			// connectingExit,
			// connectingEntry,
		]));
		helper_.insert('Connecting', 'Disconnect', ThreadedCodeExecutor(helper_, 'Disconnected', [
			disconnectedDisconnect,
			// connectingExit,
			// disconnectedExit,
			// disconnectedEntry,
		]));
		helper_.insert('Connecting', 'Subscribe', ThreadedCodeExecutor(helper_, 'Disconnected', [
			disconnectedSubscribe,
			// connectingExit,
			// disconnectedExit,
			// disconnectedEntry,
		]));
		helper_.insert('Connecting', 'Publish', ThreadedCodeExecutor(helper_, 'Disconnected', [
			disconnectedPublish,
			// connectingExit,
			// disconnectedExit,
			// disconnectedEntry,
		]));
		helper_.insert('Connecting', 'Unsubscribe', ThreadedCodeExecutor(helper_, 'Disconnected', [
			disconnectedUnsubscribe,
			// connectingExit,
			// disconnectedExit,
			// disconnectedEntry,
		]));
		helper_.insert('Connecting', 'Failed', ThreadedCodeExecutor(helper_, 'Disconnected', [
			// connectingFailed,
			// connectingExit,
			// disconnectedExit,
			// mQTTClientServerInit,
			// disconnectedEntry,
		]));
		helper_.insert('Connecting', 'Succeeded', ThreadedCodeExecutor(helper_, 'AwaitSubscribe', [
			// connectingSucceeded,
			// connectingExit,
			// connectedEntry,
			// connectedInit,
			// awaitSubscribeEntry,
		]));
	}

  void setUnitTest() {
		mqttClient.setUnitTest();
	}
}
