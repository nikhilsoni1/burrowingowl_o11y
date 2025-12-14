import base64
import logging
import datetime
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    _now = datetime.datetime.now(datetime.timezone.utc)
    _now = _now.replace(tzinfo=None)
    logger.info(f"Lambda triggered at {_now} with {len(event['Records'])} records")

    for idx, record in enumerate(event['Records']):
        try:
            b64_data = record['kinesis']['data']
            payload_bytes = base64.b64decode(b64_data)
            payload_str = payload_bytes.decode('utf-8')
            payload_json = json.loads(payload_str)
            _keys = ", ".join(payload_json.keys())
            logger.info(f"[{idx}] Keys: {_keys}")
            size = len(payload_bytes)
            logger.info(f"[{idx}] 📦 Payload size: {size} bytes at {_now}")
        except Exception as e:
            logger.error(f"[{idx}] ❌ Failed to process record: {e}")

    return {
        "statusCode": 200,
        "message": f"Processed {len(event['Records'])} records"
    }
