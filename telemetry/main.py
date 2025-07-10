from telemetry.iot_core import publish_message


dummy_payload = {"temperature": 22.5, "humidity": 45}
publish_message(
    "test/topic", dummy_payload)
