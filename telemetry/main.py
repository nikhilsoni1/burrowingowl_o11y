from telemetry.iot_core import publish_message
from telemetry.metrics_engine import get_all_metric_values
import awscrt
import sys
import uuid
import json
import datetime
import os
from telemetry.utils.logger import logger

# Step 1: Fetch metrics
metrics = get_all_metric_values()

# Step 2: Define backup path
BACKUP_DIR = "unsent_metrics"
os.makedirs(BACKUP_DIR, exist_ok=True)

try:
    publish_message("topic/burrowing_owl_metrics", metrics)
except awscrt.exceptions.AwsCrtError as e:
    logger.error(f"Failed to publish message: {e}")
    _uuid = uuid.uuid4().hex
    ts = datetime.datetime.now(datetime.timezone.utc)
    ts = ts.replace(tzinfo=None)
    payload = dict()
    payload["uuid"] = _uuid
    payload["timestamp_utc"] = ts
    payload["metrics"] = metrics
    payload["error"] = str(e)
    ts_stub = ts.strftime("%Y_%m_%d_%H_%M_%S")
    # Step 5: Save to file
    backup_filename = f"{ts_stub}_{_uuid}.json"
    backup_filepath = os.path.join(BACKUP_DIR, backup_filename)

    try:
        with open(backup_filepath, "w") as f:
            json.dump(payload, f, indent=4)
        logger.info(f"Metrics saved to: {backup_filepath}")
    except Exception as file_error:
        logger.fatal(f"Failed to save metrics: {file_error}")
        sys.exit(2)

    sys.exit(1)
