#!/usr/bin/env ruby

require File.expand_path('../../lib/hipster_robot', __FILE__)

SPOTIFY_BROADCASTER = "http://192.168.2.71:4567/"

robot = HipsterRobot.new
robot.listen(SPOTIFY_BROADCASTER)
