import can
import time
import json
import os

STATE_FILE = "truck_state.json"

DEFAULT_STATE = {
    "speed": 0,
    "rpm": 0,
    "fuel": 0,
    "payload": 0,
    "voltage": 0,
    "pressure": 0,
    "brake": 0,
    "brake_failure": 0,
    "can_bus_error": 0,
    "start_engine": 0,
    "emergency_stop": 0,
    "autonomy_mode": 0
}

def load_truck_state():
    """Load truck state from a JSON file, ensuring all keys are present."""
    if not os.path.exists(STATE_FILE):
        save_truck_state(DEFAULT_STATE)
        return DEFAULT_STATE

    try:
        with open(STATE_FILE, "r") as file:
            state = json.load(file)
            return {k: int(v) for k, v in {**DEFAULT_STATE, **state}.items()}  # Merge missing values
    except (json.JSONDecodeError, ValueError):
        print("Warning: Corrupt state file detected, resetting state.")
        save_truck_state(DEFAULT_STATE)
        return DEFAULT_STATE

def save_truck_state(state):
    """Save truck state to a JSON file."""
    with open(STATE_FILE, "w") as file:
        json.dump(state, file)

def send_message(bus, can_id, data):
    """Send a CAN message."""
    msg = can.Message(arbitration_id=can_id, data=data, is_extended_id=False)
    bus.send(msg)

def run_simulation():
    bus = can.interface.Bus(channel='vcan0', interface='socketcan')

    if os.path.exists(STATE_FILE):
        os.remove(STATE_FILE)  # Ensure a clean start

    print("Truck simulator running...")

    while True:
        # Load the latest truck state
        state = load_truck_state()
        print(f"Sending CAN Messages: {state}")

        # Send telemetry messages
        send_message(bus, 0x100, [state["speed"]])  # Speed
        send_message(bus, 0x101, [state["rpm"] >> 8, state["rpm"] & 0xFF])  # RPM (2 bytes: High Byte, Low Byte)
        send_message(bus, 0x102, [state["fuel"]])  # Fuel
        send_message(bus, 0x104, [state["payload"]])  # Payload
        send_message(bus, 0x105, [state["voltage"]])  # Voltage
        send_message(bus, 0x106, [state["pressure"] >> 8, state["pressure"] & 0xFF])  # Hydraulic Pressure (2 bytes)
        send_message(bus, 0x107, [state["brake"]])  # Brake Status

        # Send error & control messages
        send_message(bus, 0x301, [state["brake_failure"]])  # Brake Failure
        send_message(bus, 0x500, [state["start_engine"]])  # Start Engine
        send_message(bus, 0x501, [state["emergency_stop"]])  # Emergency Stop
        send_message(bus, 0x502, [state["autonomy_mode"]])  # Autonomy Mode

        time.sleep(1)  # Update CAN messages every second

if __name__ == "__main__":
    run_simulation()
