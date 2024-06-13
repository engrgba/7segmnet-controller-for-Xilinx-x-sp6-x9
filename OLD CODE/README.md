# 7segmnet-controller-for-Xilinx-x-sp6-x9
This project is developed for Xilinx X-SP6-X9 kit. <br />
This purpose of this project is to control and display data on seven segments of this kit. <br />

A wishbone compatable Uart core (wbuart) is used. <br />
In controller.v module, 115200 baud rate is set initially. <br />
Controller.v module talks with wbuart.v module over the wishbone interface. <br />

wbuart.v module receives the data from serial terminal (putty) and sends it towards controller.v module. <br />
controller.v module checks the data, if it is valid then controller.v module displays it on corresponding segment of the kit. <br />
It also sends back the data to display on serial terminal. <br />
Then it wait for 30us (Turn Around Time of Uart) before the next transaction. <br />
