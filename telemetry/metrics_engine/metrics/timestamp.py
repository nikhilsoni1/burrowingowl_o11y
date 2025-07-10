from telemetry.metrics_engine.base import Metric
import datetime

class TimeStamp(Metric):
    metric_name = "timestamp"

    def generate_metric(self):
        now = datetime.datetime.now(datetime.timezone.utc)
        now = now.replace(tzinfo=None)
        now = now.strftime("%Y-%m-%d %H:%M:%S")
        return now
