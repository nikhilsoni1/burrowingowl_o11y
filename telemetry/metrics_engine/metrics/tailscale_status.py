import subprocess
import json
from telemetry.metrics_engine.base import Metric

def peer_to_list(peer):
    peer_list = list()
    for k, v in peer.items():
        peer_record = dict()
        peer_record["node_key"] = k
        peer_record["node_data"] = v
        peer_list.append(peer_record)
    return peer_list

def user_to_list(user):
    user_list = list()
    for k, v in user.items():
        user_record = dict()
        user_record["user_key"] = k
        user_record["user_data"] = v
        user_list.append(user_record)
    return user_list

class TailscaleStatus(Metric):
    metric_name = "tailscale_status"

    def generate_metric(self):
        try:
            result = subprocess.run(
                ["tailscale", "status", "--json"],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=True,
                text=True,
            )
            status_data = json.loads(result.stdout)
            peer = status_data.pop("Peer", None)
            peer_list = peer_to_list(peer) if peer else list()
            status_data["Peer"] = peer_list
            user = status_data.pop("User", None)
            user_list = user_to_list(user) if user else list()
            status_data["User"] = user_list
            return status_data
        except (
            subprocess.CalledProcessError,
            json.JSONDecodeError,
            FileNotFoundError,
        ) as e:
            return dict()
