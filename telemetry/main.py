from telemetry.iot_core import publish_message
from telemetry.metrics_engine import get_all_metric_values
import awscrt
import sys
import uuid
import json
import datetime
import os
from telemetry.utils.logger import logger

metrics = get_all_metric_values()
result = publish_message("topic/burrowing_owl_metrics", metrics)

if result is None:
    BACKUP_DIR = "unsent_metrics"
    os.makedirs(BACKUP_DIR, exist_ok=True)
    timestamp_utc = datetime.datetime.now(datetime.timezone.utc)
    timestamp_utc = timestamp_utc.replace(tzinfo=None)
    timestamp_utc_stub = timestamp_utc.strftime("%Y%m%d_%H%M%S")
    _uuid = uuid.uuid4().hex
    filename = f"{timestamp_utc_stub}_{_uuid}.json"
    filepath = os.path.join(BACKUP_DIR, filename)
    payload = dict()
    payload["timestamp_utc"] = timestamp_utc
    payload["payload"] = metrics
    with open(filepath, "w") as f:
        json.dump(payload, f, indent=4, default=str)
    logger.info(f"Unsent metrics backed up to {filepath}")
