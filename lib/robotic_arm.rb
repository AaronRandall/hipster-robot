class RoboticArm
  require 'libusb'

  # Hardware device details 
  USB_VENDOR_ID  = 0x1267
  USB_PRODUCT_ID = 0x0000
  USB_INTERFACE  = 0

  # Supported commands
  OFF            = 0x00
  GRIP_CLOSE     = {:byte => 0, :value => 0x01}
  GRIP_OPEN      = {:byte => 0, :value => 0x02}
  WRIST_UP       = {:byte => 0, :value => 0x04}
  WRIST_DOWN     = {:byte => 0, :value => 0x08}
  ELBOW_UP       = {:byte => 0, :value => 0x10}
  ELBOW_DOWN     = {:byte => 0, :value => 0x20}
  SHOULDER_UP    = {:byte => 0, :value => 0x40}
  SHOULDER_DOWN  = {:byte => 0, :value => 0x80}
  BASE_RIGHT     = {:byte => 1, :value => 0x01}
  BASE_LEFT      = {:byte => 1, :value => 0x02}
  LED_OFF        = {:byte => 2, :value => 0x00}
  LED_ON         = {:byte => 2, :value => 0x01}

  def initialize
    # Attempt to instantiate the robotic arm
    @usb = LIBUSB::Context.new

    arm_device = nil
    arm_device = @usb.devices(:idVendor => USB_VENDOR_ID, :idProduct => USB_PRODUCT_ID).first

    if arm_device == nil
      raise Exception.new("Cannot access arm. Is it plugged-in, turned-on and you have permission to access it?") 
    end

    @arm = arm_device.open
    @arm.claim_interface(USB_INTERFACE)
  end

  def close
    # Release control of the robotic arm
    @arm.release_interface(USB_INTERFACE)
  end

  def perform_action(action, seconds)
    # Perform the desired action for a set number of seconds
    datapack= empty_datapack
    datapack[action[:byte]] = action[:value]

    arm_control_transfer_with_datapack(datapack)

    sleep(seconds)
    stop_all
  end

  private

  def arm_control_transfer_with_datapack(datapack)
    @arm.control_transfer(:bmRequestType => 0x40, 
                          :bRequest => 6, 
                          :wValue => 0x100, 
                          :wIndex => 0, 
                          :dataOut => datapack.pack('CCC'), 
                          :timeout => 1000)
  end

  def empty_datapack
    return datapack=[OFF, OFF, OFF]
  end

  def stop_all
    arm_control_transfer_with_datapack(empty_datapack)
  end

end
