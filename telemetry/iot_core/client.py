from awscrt import mqtt
from awsiot import mqtt_connection_builder
import sys
from telemetry.utils.logger import logger
import os
from dotenv import load_dotenv
from dotenv import find_dotenv


# Callback when connection is accidentally lost.
def on_connection_interrupted(connection, error, **kwargs):
    logger.error("Connection interrupted. error: {}", error)


# Callback when an interrupted connection is re-established.
def on_connection_resumed(connection, return_code, session_present, **kwargs):
    logger.info(
        "Connection resumed. return_code: {} session_present: {}",
        return_code,
        session_present,
    )

    if return_code == mqtt.ConnectReturnCode.ACCEPTED and not session_present:
        logger.info("Session did not persist. Resubscribing to existing topics...")
        resubscribe_future, _ = connection.resubscribe_existing_topics()

        # Cannot synchronously wait for resubscribe result because we're on the connection's event-loop thread,
        # evaluate result with a callback instead.
        resubscribe_future.add_done_callback(on_resubscribe_complete)


def on_resubscribe_complete(resubscribe_future):
    resubscribe_results = resubscribe_future.result()
    logger.info("Resubscribe results: {}", resubscribe_results)

    for topic, qos in resubscribe_results["topics"]:
        if qos is None:
            sys.exit("Server rejected resubscribe to topic: {}".format(topic))


# Callback when the subscribed topic receives a message
def on_message_received(topic, payload, dup, qos, retain, **kwargs):
    logger.info("Received message from topic '{}': {}", topic, payload)


# Callback when the connection successfully connects
def on_connection_success(connection, callback_data):
    assert isinstance(callback_data, mqtt.OnConnectionSuccessData)
    logger.info(
        "Connection Successful with return code: {} session present: {}",
        callback_data.return_code,
        callback_data.session_present,
    )


# Callback when a connection attempt fails
def on_connection_failure(connection, callback_data):
    assert isinstance(callback_data, mqtt.OnConnectionFailureData)
    logger.error("Connection failed with error code: {}", callback_data.error)


# Callback when a connection has been disconnected or shutdown successfully
def on_connection_closed(connection, callback_data):
    logger.info("Connection closed")


load_dotenv(find_dotenv())

# Load environment variables
IOT_ENDPOINT = os.getenv("IOT_ENDPOINT")
IOT_CERT_FILEPATH = os.getenv("IOT_CERT_FILEPATH")
IOT_PRI_KEY_FILEPATH = os.getenv("IOT_PRI_KEY_FILEPATH")
IOT_CA_FILEPATH = os.getenv("IOT_CA_FILEPATH")
IOT_CLIENT_ID = os.getenv("IOT_CLIENT_ID")

# Create a MQTT connection from the command line data
mqtt_connection = mqtt_connection_builder.mtls_from_path(
    endpoint=IOT_ENDPOINT,
    cert_filepath=IOT_CERT_FILEPATH,
    pri_key_filepath=IOT_PRI_KEY_FILEPATH,
    ca_filepath=IOT_CA_FILEPATH,
    client_id = IOT_CLIENT_ID,
    on_connection_interrupted=on_connection_interrupted,
    on_connection_resumed=on_connection_resumed,
    clean_session=False,
    keep_alive_secs=30,
    on_connection_success=on_connection_success,
    on_connection_failure=on_connection_failure,
    on_connection_closed=on_connection_closed,
)


connect_future = mqtt_connection.connect()
connect_future.result()
