#include <stdio.h>

#include "em_chip.h"
#include "em_cmu.h"
#include "em_gpio.h"

#include "retargetserial.h"

int main(void) {
  // Chip errata
  CHIP_Init();

  // Enable GPIO clock and set the BCC_ENABLE pin high
  CMU_ClockEnable(cmuClock_GPIO, true);
  GPIO_PinModeSet(BSP_BCC_ENABLE_PORT, BSP_BCC_ENABLE_PIN, gpioModePushPull, 1);

  // Redirect STDOUT/STDERR to the UART
  RETARGET_SerialInit();

  while (1) {
    printf("Hello, World!\n");

    for (int i = 0; i < 1000000; i++)
      ;
  }
}