Hi, 
This code is written for developing an understanding that how to interface with WISHBONE. <br />
UART core named WB_UART is used which is directly controlled by Wishbone_Controller module. <br />
WB_UART core takes RX signal from the PC Serial Terminal and sends TX signal towards the serial terminal. <br />
This core is wishbone compatible so Wishbone_Controller Module can read the data which is received by this core. <br />
Then this data is fowarded to the ENABLER Module which simply enables the all 7 segments displays available on the kit. <br />
Then hex7seg Module displays the incoming data on the respected segment. <br />
![new 7seg](https://github.com/engrgba/7segmnet-controller-for-Xilinx-x-sp6-x9/assets/169391539/c71f3d36-4da4-4bcd-a098-76c64923a80d) <br />
