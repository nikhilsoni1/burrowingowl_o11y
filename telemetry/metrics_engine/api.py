from telemetry.metrics_engine.registry import metric_registry
from telemetry.metrics_engine import metrics
from telemetry.utils.logger import logger


def get_all_metric_values():
    results = {}
    for name, instance in metric_registry.all().items():
        try:
            results[name] = instance.generate_metric()
            logger.info(f"Generated metric '{name}'")
        except Exception as e:
            results[name] = None
            logger.error(f"Error generating metric '{name}': {e}")
    return results
