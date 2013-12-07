class RoboticArm
  require 'libusb'

  # Generic constant
  OFF = 0x00

  # First byte
  GRIP_CLOSE    = {:byte => 0, :value => 0x01}
  GRIP_OPEN     = {:byte => 0, :value => 0x02}
  WRIST_UP      = {:byte => 0, :value => 0x04}
  WRIST_DOWN    = {:byte => 0, :value => 0x08}
  ELBOW_UP      = {:byte => 0, :value => 0x10}
  ELBOW_DOWN    = {:byte => 0, :value => 0x20}
  SHOULDER_UP   = {:byte => 0, :value => 0x40}
  SHOULDER_DOWN = {:byte => 0, :value => 0x80}

  # Second byte
  BASE_RIGHT    = {:byte => 1, :value => 0x01}
  BASE_LEFT     = {:byte => 1, :value => 0x02}

  # Third byte
  LED_OFF       = {:byte => 2, :value => 0x00}
  LED_ON        = {:byte => 2, :value => 0x01}

  def initialize
    @usb = LIBUSB::Context.new

    arm_device = nil
    arm_device = @usb.devices(:idVendor => 0x1267, :idProduct => 0x0000).first

    if arm_device == nil
      raise Exception.new("Cannot access arm. Is it plugged-in, turned-on and you have permission to access it?") 
    end

    @arm = arm_device.open
    @arm.claim_interface(0)
  end

  def close
    @arm.release_interface(0)
  end

  def perform_action(action, seconds)
    datapack=[OFF, OFF, OFF]
    datapack[action[:byte]] = action[:value]
    @arm.control_transfer(:bmRequestType => 0x40, :bRequest => 6, :wValue => 0x100, :wIndex => 0, :dataOut => datapack.pack('CCC'), :timeout => 1000)

    sleep(seconds)
    stop_all
  end

  private

  def stop_all
    datapack=[OFF, OFF, OFF]
    @arm.control_transfer(:bmRequestType => 0x40, :bRequest => 6, :wValue => 0x100, :wIndex => 0, :dataOut => datapack.pack('CCC'), :timeout => 1000)
  end

end
