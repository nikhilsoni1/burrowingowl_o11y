from telemetry.metrics_engine.base import Metric
import subprocess
from telemetry.utils.logger import logger

class CPUTemp(Metric):
    metric_name = "cpu_temp"

    def generate_metric(self):
        try:
            output = subprocess.check_output(["vcgencmd", "measure_temp"]).decode()
            # output looks like: "temp=45.2'C"
            temp_str = output.strip().split('=')[1].replace("'C", "")
            return {"value": float(temp_str), "unit": "celsius"}
        except Exception as e:
            logger.warning(f"[{self.metric_name}] Failed to get temperature: {e}")
            return {"value": None, "unit": None}
