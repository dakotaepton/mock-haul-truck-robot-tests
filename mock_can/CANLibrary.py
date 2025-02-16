import can
import time
import json
import threading

class CANLibrary:

    def __init__(self, channel="vcan0", bustype="socketcan"):
        self.STATE_FILE = "truck_state.json"
        self.lock = threading.Lock()
        self.bus = can.interface.Bus(channel=channel, bustype=bustype)

    def send_can_message(self, can_id, data):
        """Send a CAN message"""
        msg = can.Message(arbitration_id=int(can_id, 16), data=[int(x) for x in data], is_extended_id=False)
        self.bus.send(msg)

    def wait_for_can_message(self, can_id, timeout=5):
        """Wait for a specific CAN message and always return an integer."""
        start_time = time.time()
        can_id_int = int(can_id, 16)

        while time.time() - start_time < timeout:
            msg = self.bus.recv(timeout=1)
            if msg and msg.arbitration_id == can_id_int:
                # If the message contains multiple bytes, reconstruct an integer from them
                if len(msg.data) > 1:
                    value = 0
                    for byte in msg.data:
                        value = (value << 8) | byte  # Shift left and OR with next byte
                    return value

                # If single byte, return it as an integer
                return int(msg.data[0])

        raise AssertionError(f"Timeout: No message with ID {can_id} received within {timeout} seconds")


    def set_truck_state(self, speed=None, rpm=None, fuel=None, payload=None, voltage=None,
                        pressure=None, brake=None, brake_failure=None, start_engine=None, 
                        emergency_stop=None, autonomy_mode=None):
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
                    "brake_failure": 0,
                    "start_engine": 0,
                    "emergency_stop": 0,
                    "autonomy_mode": 0
                }

        # Function to safely convert Robot Framework string arguments to correct data types
        def convert(value, min_val, max_val):
            if value is not None:
                try:
                    value = int(value)
                    return max(min_val, min(value, max_val))  # Clamp value within range
                except ValueError:
                    return value  # Leave as string if conversion fails
            return None

        # Ensure proper data types and enforce value limits based on CAN message definitions
        telemetry_updates = {
            "speed": convert(speed, 0, 255),
            "rpm": convert(rpm, 0, 8000),
            "fuel": convert(fuel, 0, 100),
            "payload": convert(payload, 0, 255),
            "voltage": convert(voltage, 0, 255),
            "pressure": convert(pressure, 0, 500),
            "brake": convert(brake, 0, 1),
            "brake_failure": convert(brake_failure, 0, 1),
            "start_engine": convert(start_engine, 0, 1),
            "emergency_stop": convert(emergency_stop, 0, 1),
            "autonomy_mode": convert(autonomy_mode, 0, 1)
        }

        # Update only the provided values (ignore None)
        state.update({k: v for k, v in telemetry_updates.items() if v is not None})

        with open(self.STATE_FILE, "w") as file:
            json.dump(state, file)
