#include "em_chip.h"
#include "em_cmu.h"
#include "em_gpio.h"

#define BSP_GPIO_LED0_PORT gpioPortD
#define BSP_GPIO_LED0_PIN 2
#define BSP_GPIO_PB0_PORT gpioPortB
#define BSP_GPIO_PB0_PIN 0

int main(void) {
  // Chip errata
  CHIP_Init();

  // Enable GPIO clock. Note this step is not required for EFR32xG21 devices
  CMU_ClockEnable(cmuClock_GPIO, true);

  // Configure Push Button 0 as input
  GPIO_PinModeSet(BSP_GPIO_PB0_PORT, BSP_GPIO_PB0_PIN, gpioModeInput, 0);

  // Configure LED0 as a push pull for LED drive
  GPIO_PinModeSet(BSP_GPIO_LED0_PORT, BSP_GPIO_LED0_PIN, gpioModePushPull, 1);

  while (1) {
    // Check if button is pressed - when pressed, value will be 0
    if (!GPIO_PinInGet(BSP_GPIO_PB0_PORT, BSP_GPIO_PB0_PIN)) {
      GPIO_PinOutSet(BSP_GPIO_LED0_PORT, BSP_GPIO_LED0_PIN);
    } else {
      GPIO_PinOutClear(BSP_GPIO_LED0_PORT, BSP_GPIO_LED0_PIN);
    }
  }
}