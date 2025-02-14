import can
import time
import json
import os

STATE_FILE = "truck_state.json"

def load_truck_state():
    """Load truck state from a JSON file."""
    if not os.path.exists(STATE_FILE):
        state = {
            "speed": 0,
            "rpm": 0,
            "fuel": 100,
            "payload": 50,
            "voltage": 26,
            "pressure": 250,
            "brake": 0,
        }

        with open(STATE_FILE, "w") as file:
            json.dump(state, file)
        
        return state

    with open(STATE_FILE, "r") as file:
        state = json.load(file)

    return {k: int(v) for k, v in state.items()}

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
        os.remove(STATE_FILE)

    print("🚛 Truck simulator running...")


    while True:
        # Load the latest truck state
        state = load_truck_state()

        # Send telemetry messages based on the controlled state
        send_message(bus, 0x100, [state["speed"]])  # Speed
        send_message(bus, 0x101, [state["rpm"] >> 8, state["rpm"] & 0xFF])  # RPM (High Byte, Low Byte)
        send_message(bus, 0x102, [state["fuel"]])  # Fuel
        send_message(bus, 0x104, [state["payload"]])  # Payload
        send_message(bus, 0x105, [state["voltage"]])  # Voltage
        send_message(bus, 0x106, [state["pressure"] % 256])  # Hydraulic Pressure
        send_message(bus, 0x107, [state["brake"]])  # Brake Status

        time.sleep(1)  # Update CAN messages every second

if __name__ == "__main__":
    run_simulation()
