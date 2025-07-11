import socket

from telemetry.metrics_engine.base import Metric


def get_hostname():
    return socket.gethostname()


def get_os_version():
    try:
        with open("/etc/os-release", "r") as f:
            for line in f:
                if line.startswith("PRETTY_NAME="):
                    return line.strip().split("=")[1].strip('"')
    except FileNotFoundError:
        return "unknown"


def get_device_model():
    try:
        with open("/proc/device-tree/model", "r") as f:
            return f.read().strip("\x00").strip()
    except FileNotFoundError:
        return "unknown"


class SystemInfo(Metric):
    metric_name = "system_info"

    def generate_metric(self):
        payload = dict()
        payload["hostname"] = get_hostname()
        payload["os_version"] = get_os_version()
        payload["device_model"] = get_device_model()
        return payload
