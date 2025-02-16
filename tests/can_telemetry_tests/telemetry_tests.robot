*** Settings ***
Resource   telemetry_keywords.robot


Suite Setup      Start Truck Simulator
Suite Teardown   Shutdown Truck Simulator


*** Variables ***
${SPEED_CAN_ID}        0x100
${RPM_CAN_ID}          0x101
${FUEL_CAN_ID}         0x102
${PAYLOAD_CAN_ID}      0x104
${VOLTAGE_CAN_ID}      0x105
${PRESSURE_CAN_ID}     0x106
${BRAKE_CAN_ID}        0x107
${BRAKE_FAILURE_ID}    0x301
${START_ENGINE_ID}     0x500
${EMERGENCY_STOP_ID}   0x501
${AUTONOMY_MODE_ID}    0x502

*** Test Cases ***

### **Initialize Default Truck State**
Set Truck to Default State
    [Documentation]  Reset the truck to a default where all telemetry values are zero.
    Set Truck Telemetry  speed=0  rpm=0  fuel=0  payload=0  voltage=0  pressure=0  brake=0  
    ...  brake_failure=0  start_engine=0  emergency_stop=0  autonomy_mode=0


### **Vehicle Speed Tests**
Verify Speed Clamps to Minimum
    [Documentation]  Attempt to set speed below 0 and verify it is clamped to 0.
    Set Truck Telemetry  speed=-1
    Verify CAN Message  ${SPEED_CAN_ID}  0

Verify Speed Within Valid Range
    [Documentation]  Set a valid speed and ensure it is correctly transmitted.
    Set Truck Telemetry  speed=50
    Verify CAN Message  ${SPEED_CAN_ID}  50

Verify Speed Clamps to Maximum
    [Documentation]  Attempt to set speed above 255 and verify it is clamped to 255.
    Set Truck Telemetry  speed=300
    Verify CAN Message  ${SPEED_CAN_ID}  255


### **Engine RPM Tests**
Verify RPM Clamps to Minimum
    [Documentation]  Attempt to set RPM below 0 and verify it is clamped to 0.
    Set Truck Telemetry  rpm=-50
    Verify CAN Message  ${RPM_CAN_ID}  0

Verify RPM Within Valid Range
    [Documentation]  Set a valid RPM and ensure it is correctly transmitted.
    Set Truck Telemetry  rpm=4000
    Verify CAN Message  ${RPM_CAN_ID}  4000

Verify RPM Clamps to Maximum
    [Documentation]  Attempt to set RPM above 8000 and verify it is clamped to 8000.
    Set Truck Telemetry  rpm=9000
    Verify CAN Message  ${RPM_CAN_ID}  8000


### **Fuel Level Tests**
Verify Fuel Clamps to Minimum
    [Documentation]  Attempt to set fuel below 0 and verify it is clamped to 0.
    Set Truck Telemetry  fuel=-5
    Verify CAN Message  ${FUEL_CAN_ID}  0

Verify Fuel Within Valid Range
    [Documentation]  Set a valid fuel level and ensure it is correctly transmitted.
    Set Truck Telemetry  fuel=75
    Verify CAN Message  ${FUEL_CAN_ID}  75

Verify Fuel Clamps to Maximum
    [Documentation]  Attempt to set fuel above 100 and verify it is clamped to 100.
    Set Truck Telemetry  fuel=150
    Verify CAN Message  ${FUEL_CAN_ID}  100


### **Payload Weight Tests**
Verify Payload Clamps to Minimum
    [Documentation]  Attempt to set payload below 0 and verify it is clamped to 0.
    Set Truck Telemetry  payload=-10
    Verify CAN Message  ${PAYLOAD_CAN_ID}  0

Verify Payload Within Valid Range
    [Documentation]  Set a valid payload and ensure it is correctly transmitted.
    Set Truck Telemetry  payload=120
    Verify CAN Message  ${PAYLOAD_CAN_ID}  120

Verify Payload Clamps to Maximum
    [Documentation]  Attempt to set payload above 255 and verify it is clamped to 255.
    Set Truck Telemetry  payload=300
    Verify CAN Message  ${PAYLOAD_CAN_ID}  255


### **Battery Voltage Tests**
Verify Voltage Clamps to Minimum
    [Documentation]  Attempt to set voltage below 0 and verify it is clamped to 0.
    Set Truck Telemetry  voltage=-2
    Verify CAN Message  ${VOLTAGE_CAN_ID}  0

Verify Voltage Within Valid Range
    [Documentation]  Set a valid voltage and ensure it is correctly transmitted.
    Set Truck Telemetry  voltage=26
    Verify CAN Message  ${VOLTAGE_CAN_ID}  26

Verify Voltage Clamps to Maximum
    [Documentation]  Attempt to set voltage above 255 and verify it is clamped to 255.
    Set Truck Telemetry  voltage=300
    Verify CAN Message  ${VOLTAGE_CAN_ID}  255


### **Hydraulic Pressure Tests**
Verify Pressure Clamps to Minimum
    [Documentation]  Attempt to set pressure below 0 and verify it is clamped to 0.
    Set Truck Telemetry  pressure=-10
    Verify CAN Message  ${PRESSURE_CAN_ID}  0

Verify Pressure Within Valid Range
    [Documentation]  Set a valid hydraulic pressure and ensure it is correctly transmitted.
    Set Truck Telemetry  pressure=300
    Verify CAN Message  ${PRESSURE_CAN_ID}  300

Verify Pressure Clamps to Maximum
    [Documentation]  Attempt to set pressure above 500 and verify it is clamped to 500.
    Set Truck Telemetry  pressure=600
    Verify CAN Message  ${PRESSURE_CAN_ID}  500


### **Brake Status Tests**
Verify Brake Clamps to Minimum
    [Documentation]  Attempt to set brake below 0 and verify it is clamped to 0.
    Set Truck Telemetry  brake=-1
    Verify CAN Message  ${BRAKE_CAN_ID}  0

Verify Brake Within Valid Range
    [Documentation]  Set a valid brake value and ensure it is correctly transmitted.
    Set Truck Telemetry  brake=1
    Verify CAN Message  ${BRAKE_CAN_ID}  1

Verify Brake Clamps to Maximum
    [Documentation]  Attempt to set brake above 1 and verify it is clamped to 1.
    Set Truck Telemetry  brake=2
    Verify CAN Message  ${BRAKE_CAN_ID}  1


### **Brake Failure Tests**
Verify Brake Failure Clamps to Minimum
    [Documentation]  Attempt to set brake failure below 0 and verify it is clamped to 0.
    Set Truck Telemetry  brake_failure=-1
    Verify CAN Message  ${BRAKE_FAILURE_ID}  0

Verify Brake Failure Within Valid Range
    [Documentation]  Set a valid brake failure value and ensure it is correctly transmitted.
    Set Truck Telemetry  brake_failure=1
    Verify CAN Message  ${BRAKE_FAILURE_ID}  1

Verify Brake Failure Clamps to Maximum
    [Documentation]  Attempt to set brake failure above 1 and verify it is clamped to 1.
    Set Truck Telemetry  brake_failure=2
    Verify CAN Message  ${BRAKE_FAILURE_ID}  1


### **Start Engine Command Tests**
Verify Start Engine Clamps to Minimum
    [Documentation]  Attempt to set start engine below 0 and verify it is clamped to 0.
    Set Truck Telemetry  start_engine=-1
    Verify CAN Message  ${START_ENGINE_ID}  0

Verify Start Engine Within Valid Range
    [Documentation]  Set a valid start engine command and ensure it is correctly transmitted.
    Set Truck Telemetry  start_engine=1
    Verify CAN Message  ${START_ENGINE_ID}  1

Verify Start Engine Clamps to Maximum
    [Documentation]  Attempt to set start engine above 1 and verify it is clamped to 1.
    Set Truck Telemetry  start_engine=2
    Verify CAN Message  ${START_ENGINE_ID}  1


### **Emergency Stop Command Tests**
Verify Emergency Stop Clamps to Minimum
    [Documentation]  Attempt to set emergency stop below 0 and verify it is clamped to 0.
    Set Truck Telemetry  emergency_stop=-1
    Verify CAN Message  ${EMERGENCY_STOP_ID}  0

Verify Emergency Stop Within Valid Range
    [Documentation]  Set a valid emergency stop command and ensure it is correctly transmitted.
    Set Truck Telemetry  emergency_stop=1
    Verify CAN Message  ${EMERGENCY_STOP_ID}  1

Verify Emergency Stop Clamps to Maximum
    [Documentation]  Attempt to set emergency stop above 1 and verify it is clamped to 1.
    Set Truck Telemetry  emergency_stop=2
    Verify CAN Message  ${EMERGENCY_STOP_ID}  1


### **Autonomy Mode Command Tests**
Verify Autonomy Mode Clamps to Minimum
    [Documentation]  Attempt to set autonomy mode below 0 and verify it is clamped to 0.
    Set Truck Telemetry  autonomy_mode=-1
    Verify CAN Message  ${AUTONOMY_MODE_ID}  0

Verify Autonomy Mode Within Valid Range
    [Documentation]  Set a valid autonomy mode command and ensure it is correctly transmitted.
    Set Truck Telemetry  autonomy_mode=1
    Verify CAN Message  ${AUTONOMY_MODE_ID}  1

Verify Autonomy Mode Clamps to Maximum
    [Documentation]  Attempt to set autonomy mode above 1 and verify it is clamped to 1.
    Set Truck Telemetry  autonomy_mode=2
    Verify CAN Message  ${AUTONOMY_MODE_ID}  1


### **Shutdown Truck Simulator**
Shutdown Truck Simulator
    [Documentation]  Ensure the truck simulator is properly terminated after tests.
    Terminate Process  ${SIMULATOR_PROCESS}