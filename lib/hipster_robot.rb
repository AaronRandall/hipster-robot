class HipsterRobot
  require_relative 'robotic_arm_driver/robotic_arm'
  require_relative 'artist_hipster_analyser'
  require 'net/http'
  require 'json'

  DELAY_BETWEEN_REQUESTS_SECONDS = 3

  def initialize
    @arm = RoboticArm.new
    @hipster_analyser = ArtistHipsterAnalyser.new
  end

  def listen(url)
    while true do
      uri = URI(url)
      response = Net::HTTP.get_response(uri)

      if response.body
        json_response = JSON.parse(response.body)
        artist_name   = json_response['artistName']
        track_name    = json_response['trackName']

        if ((artist_name != @last_artist_name) || (track_name != @last_track_name)) &&
          (!artist_name.nil? && !track_name.nil?)

          if @hipster_analyser.artist_is_not_hipster(artist_name)
            puts "Caught you listening to #{artist_name}, #{track_name}! Stop it!"
            stop_track
            @last_artist_name = ""
            @last_track_name  = ""
          else
            puts "Listening to #{artist_name}, #{track_name}. That's cool."
            @last_artist_name = artist_name
            @last_track_name  = track_name
          end
        end
      end

      sleep DELAY_BETWEEN_REQUESTS_SECONDS
    end
  end

  private

  def stop_track
    @arm.perform_action(RoboticArm::ELBOW_UP, 2)
    @arm.perform_action(RoboticArm::BASE_RIGHT, 6.1)
    @arm.perform_action(RoboticArm::SHOULDER_DOWN, 1.4)
    @arm.perform_action(RoboticArm::SHOULDER_UP, 1.6)
    @arm.perform_action(RoboticArm::BASE_LEFT, 6)
    @arm.perform_action(RoboticArm::ELBOW_DOWN, 1.76)
  end

  def close
    @arm.close
  end

end
