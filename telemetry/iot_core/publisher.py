from awscrt import mqtt
from telemetry.iot_core.client import mqtt_connection
import json
from telemetry.utils.logger import logger


def sanitize_json(data):
    return json.dumps(data, indent=4, default=str)


def publish_message(message_topic, message_payload):
    if mqtt_connection is None:
        logger.error("MQTT connection is not established. Cannot publish message.")
        return None
    message_json = sanitize_json(message_payload)
    result = mqtt_connection.publish(
        topic=message_topic, payload=message_json, qos=mqtt.QoS.AT_LEAST_ONCE
    )
    message_size = len(message_json.encode("utf-8"))
    logger.info(f"Published message to topic '{message_topic}': {message_size} bytes")
    return result
