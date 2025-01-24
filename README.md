# Washing-Machine-Controller
The project aims at practicing the ASIC flow by implementing a washing machine controller, assume realistic design specifications for a washing machine containing the different options and buttons as the power button, alarms etc…


Design Team:

1-Specifications Gathering:
Define the basic controls for a washing machine, including power, start/stop, wash modes (quick, normal, heavy), water levels, alarms, etc.
Define timing cycles for washing, rinsing, and spinning.
Consider safety features like lid locking and alarm systems.


2-FSM (Finite State Machine) Design:
State Definition: States could include Power_Off, Idle, Washing, Rinsing, Spinning, Error (for alarms), etc.
Transitions: Transition logic should handle input from buttons (power, start, mode selection), sensor signals (water level, lid status), and timer-driven events.
Verilog Implementation: Translate the FSM state diagram into Verilog code, ensuring modular design for different components (e.g., timer, motor controller, etc.).


Verification Team:

1-Verification Plan:

Test Stimulus Generation:
Directed Tests: For specific edge cases, such as transition from Idle to Washing based on button inputs.
Constrained Random: For varied button press sequences and sensor inputs within specific bounds.
Random Tests: For full random button presses to explore unplanned scenarios.


Assertions:
Use assertions to check FSM state transitions (e.g., if the Power button is pressed, ensure the system transitions from Power_Off to Idle).
Check for critical conditions like simultaneous pressing of incompatible buttons or transitions from unsafe states (e.g., spinning with the lid open).


Code Coverage:
Statement Coverage: Ensure all lines of Verilog code are executed during testing.
Branch Coverage: Verify that all possible outcomes of conditionals are tested.
FSM Coverage: Ensure all states and transitions of the FSM are exercised.
Toggle Coverage: Test critical signal transitions like power, motor on/off, or water level sensor status.


2-Testbench Creation:
Build a testbench to simulate the design using a combination of random, constrained random, and directed tests.
Ensure correct stimulus generation for buttons and sensors.


3-Design Properties & Assertions (PSL):
Implement key properties to check state transitions, alarm triggering, and input validity (e.g., lid must be closed during spin).


4-Coverage Report:
After simulation, use QuestaSim to generate coverage reports and evaluate the quality of your test suite.
