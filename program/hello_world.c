#include <inttypes.h>
// #include <stdio.h>

// Write a byte to this memory-mapped address to send a byte over UART
#define UART_BASE_ADDRESS 0x10000000

void uart_write(uint8_t data) {
    // Write data to UART through the memory-mapped interface
    *(volatile uint8_t *)UART_BASE_ADDRESS = data;
    // printf("The character is: %c\n", data);
}

int uart_print(const char *msg) {

    // Send every char before the NULL termination to the UART
    for (uint32_t i = 0; msg[i] != '\0'; i++) {
        uart_write(msg[i]);
    }
}

int main()
{
    uart_print("Hello World!\r\n");
    
    while(1);
}