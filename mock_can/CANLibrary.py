import can
import time
import json
import threading

class CANLibrary:

    def __init__(self, channel="vcan0", bustype="socketcan"):
        self.STATE_FILE = "../mock_can/truck_state.json"
        self.lock = threading.Lock()
        self.bus = can.interface.Bus(channel=channel, bustype=bustype)

    def send_can_message(self, can_id, data):
        """Send a CAN message"""
        msg = can.Message(arbitration_id=int(can_id, 16), data=[int(x) for x in data], is_extended_id=False)
        self.bus.send(msg)

    def wait_for_can_message(self, can_id, timeout=5):
        """Wait for a specific CAN message"""
        start_time = time.time()
        can_id_int = int(can_id, 16)

        while time.time() - start_time < timeout:
            msg = self.bus.recv(timeout=1)
            if msg and msg.arbitration_id == can_id_int:
                # If it's RPM (0x101), reconstruct two-byte integer
                if can_id_int == 0x101:
                    return (msg.data[0] << 8) + msg.data[1]
                return [int(x) for x in msg.data]

        raise AssertionError(f"Timeout: No message with ID {can_id} received within {timeout} seconds")

    def set_truck_state(self, speed=None, rpm=None, fuel=None, payload=None, voltage=None, pressure=None, brake=None):
            """Modify the truck state JSON file safely with correct data types."""
            with self.lock:
                try:
                    with open(self.STATE_FILE, "r") as file:
                        state = json.load(file)
                except (json.JSONDecodeError, IOError):
                    print("Warning: Corrupt state file. Resetting state.")
                    state = {
                        "speed": 0,
                        "rpm": 0,
                        "fuel": 100,
                        "payload": 50,
                        "voltage": 26,
                        "pressure": 250,
                        "brake": 0,
                    }

                # Convert Robot Framework string arguments to proper data types bc robot is weird
                #   and I'm kinda hacking it to simulate this truck
                def convert(value):
                    if isinstance(value, str):
                        try:
                            return int(value)  # Convert numbers to integers
                        except ValueError:
                            try:
                                return json.loads(value)  # Convert JSON strings to lists
                            except json.JSONDecodeError:
                                return value  # Leave as string if conversion fails
                    return value  # Return value as-is if already correct

                # Ensure proper data types before updating
                telemetry_updates = {
                    "speed": speed,
                    "rpm": rpm,
                    "fuel": fuel,
                    "payload": payload,
                    "voltage": voltage,
                    "pressure": pressure,
                    "brake": brake,
                }

                # Filter out None values (only update fields provided)
                state.update({k: v for k, v in telemetry_updates.items() if v is not None})

                with open(self.STATE_FILE, "w") as file:
                    json.dump(state, file)
