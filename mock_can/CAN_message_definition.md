| Message Type       | CAN ID (Hex) | Data (Bytes)          | Description               |
|--------------------|--------------|-----------------------|---------------------------|
| Vehicle Speed      | 0x100        | [0, 255]              | Speed in km/h             |
| Engine RPM         | 0x101        | [0, 8000]             | Engine rotations per min  |
| Fuel Level         | 0x102        | [0, 100]              | Percentage fuel left      |
| Payload            | 0x104        | [0, 255]              | Payload in tonnes         |
| Battery Voltage    | 0x105        | [0, 255]              | Voltage level             |
| Hydraulic Pressure | 0x106        | [0, 500]              | Pressure in PSI           |
| Brake Status       | 0x107        | [0, 1]                | 0 = Off, 1 = Engaged      |
| Brake Failure      | 0x301        | [0, 1]                | 1 = Failure detected      |
| CAN Bus Error      | 0x400        | [0, 1]                | 1 = Error detected        |
| Start Engine       | 0x500        | [0, 1]                | 1 = Start engine          |
| Emergency Stop     | 0x501        | [0, 1]                | 1 = Activate E-Stop       |
| Autonomy Mode      | 0x502        | [0, 1]                | 1 = Enable autonomy       |
