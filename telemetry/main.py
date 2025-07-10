from telemetry.iot_core import publish_message
from telemetry.metrics_engine import get_all_metric_values

metrics = get_all_metric_values()
publish_message("topic/burrowing_owl_metrics", metrics)
