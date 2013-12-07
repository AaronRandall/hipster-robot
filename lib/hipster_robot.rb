class HipsterRobot

  require_relative 'robotic_arm_driver/robotic_arm.rb'
  require 'net/http'
  require 'json'

  DELAY_BETWEEN_REQUESTS_SECONDS = 3

  def initialize
    @arm = RoboticArm.new
  end

  def listen(url)
    while true do
      uri = URI(url)
      response = Net::HTTP.get_response(uri)

      if response.body
        json_response = JSON.parse(response.body)
        artist_name   = json_response['artistName']
        track_name    = json_response['trackName']

        puts "artist_name=#{artist_name}, track_name=#{track_name}"

        if artist_is_not_hipster(artist_name)
          stop_track
        end

        sleep DELAY_BETWEEN_REQUESTS_SECONDS
      end
    end
  end

  private

  def artist_is_not_hipster(artist_name)
    if artist_name == "Taylor Swift" 
      return true
    end

    return false
  end

  def stop_track
    @arm.perform_action(RoboticArm::ELBOW_UP, 2)
    @arm.perform_action(RoboticArm::BASE_RIGHT, 6)
    @arm.perform_action(RoboticArm::SHOULDER_DOWN, 1.4)
    @arm.perform_action(RoboticArm::SHOULDER_UP, 1.6)
    @arm.perform_action(RoboticArm::BASE_LEFT, 6)
    @arm.perform_action(RoboticArm::ELBOW_DOWN, 1.76)
  end

  def close
    @arm.close
  end

end
