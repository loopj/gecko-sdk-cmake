function(add_openocd_flash_target TARGET)
  set(BINARY "${TARGET}.hex")

  add_custom_target(
    "${TARGET}_flash_openocd"
    COMMAND
      openocd -f "interface/cmsis-dap.cfg" -c "transport select swd" -f "target/efm32s2.cfg" -c
      "init" -c "halt" -c "flash write_image erase ${BINARY}" -c "exit"
    DEPENDS ${TARGET}
  )
endfunction()
