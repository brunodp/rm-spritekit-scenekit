# rake device_name="iPad Retina"

# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'spritekit-scenekit'
  app.frameworks += ["SpriteKit", "SceneKit", 'QuartzCore', 'GLKit', 'AVFoundation']

	# app.device_family = [:ipad]
	app.interface_orientations = [:landscape_left, :landscape_right]
	
	app.info_plist['UILaunchStoryboardName'] = 'Launch Screen'
end
