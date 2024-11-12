# Set the path to Simplicity Commander, if configured
if(DEFINED ENV{SIMPLICITY_COMMANDER_PATH})
  set(SIMPLICITY_COMMANDER_PATH $ENV{SIMPLICITY_COMMANDER_PATH})
endif()

# Create .bin artifact after building the target
function(GeckoSDK_generate_bin TARGET)
  add_custom_command(
    TARGET ${TARGET}
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY}
    ARGS -O binary ${TARGET} ${TARGET}.bin
  )
endfunction()

# Create .hex artifact after building the target
function(GeckoSDK_generate_hex TARGET)
  add_custom_command(
    TARGET ${TARGET}
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY}
    ARGS -O ihex ${TARGET} ${TARGET}.hex
  )
endfunction()

# Create .s37 artifact after building the target
function(GeckoSDK_generate_s37 TARGET)
  add_custom_command(
    TARGET ${TARGET}
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY}
    ARGS -O srec ${TARGET} ${TARGET}.s37
  )
endfunction()

# Create a .gbl file for use with the Gecko Bootloader
function(GeckoSDK_generate_gbl TARGET)
  if(NOT SIMPLICITY_COMMANDER_PATH)
    message(WARNING "SIMPLICITY_COMMANDER_PATH must be defined to generate .gbl files")
    return()
  endif()

  add_custom_command(
    TARGET ${TARGET}
    POST_BUILD
    COMMAND ${SIMPLICITY_COMMANDER_PATH}/commander
    ARGS gbl create ${TARGET}.gbl --app ${TARGET}.hex
  )
endfunction()
