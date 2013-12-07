require_relative 'robotic_arm_driver/robotic_arm.rb'

arm = RoboticArm.new

arm.perform_action(RoboticArm::ELBOW_UP, 2)
arm.perform_action(RoboticArm::BASE_RIGHT, 6)
arm.perform_action(RoboticArm::SHOULDER_DOWN, 1.4)
arm.perform_action(RoboticArm::SHOULDER_UP, 1.6)
arm.perform_action(RoboticArm::BASE_LEFT, 6)
arm.perform_action(RoboticArm::ELBOW_DOWN, 1.76)

arm.close
