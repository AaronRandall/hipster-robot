class HipsterRobot
  require_relative 'robotic_arm'
  require_relative 'artist_hipster_analyser'
  require 'net/http'
  require 'json'

  DELAY_BETWEEN_REQUESTS_IN_SECONDS = 3

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
        @artist_name   = json_response['artistName']
        @track_name    = json_response['trackName']

        if artist_and_track_are_not_nil && artist_or_track_has_changed
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

      sleep DELAY_BETWEEN_REQUESTS_IN_SECONDS
    end
  end

  private

  def stop_track
    # The arm actions required to move the robot to press the spacebar.
    # Note that the actions (e.g. ELBOW_UP) are not equal to the equivalent 
    # reverse action (e.g. ELBOW_DOWN). This is because the arm's motors 
    # have to work harder to perform against gravity
    @arm.perform_action(RoboticArm::ELBOW_UP, 2)
    @arm.perform_action(RoboticArm::BASE_RIGHT, 6.3)
    @arm.perform_action(RoboticArm::SHOULDER_DOWN, 1.4)
    @arm.perform_action(RoboticArm::SHOULDER_UP, 1.63)
    @arm.perform_action(RoboticArm::BASE_LEFT, 6.2)
    @arm.perform_action(RoboticArm::ELBOW_DOWN, 1.7)
  end

  def close
    @arm.close
  end

  def artist_or_track_has_changed
    return (@artist_name != @last_artist_name) || (@track_name != @last_track_name)
  end

  def artist_and_track_are_not_nil
    return (!artist_name.nil? && !track_name.nil?)
  end

end
