class GameScene < SKScene
	
	def didMoveToView(view)
		center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
		NSLog("didmove center: #{NSStringFromCGPoint(center)}")
		
		create_labels
				
		@ship_scene = TDScene.ship_scene
		
		size = CGSizeMake(600, 450)
		# @td_node = SK3DNode.nodeWithViewportSize(size)
		@td_node = SK3DNode.nodeWithViewportSize(self.scene.size)
		@td_node.name = "3d node"
		@td_node.position = center
		@td_node.scnScene = @ship_scene
		@td_node.pointOfView = @ship_scene.camera
		@td_node.alpha = 0.25
		
		# warning This code is very important in iOS 8.1. Without these lines (which presumably initiate the SCNRenderer), 
		# the app crashes immediately. 
		begin
			s1 = @td_node.valueForKey('_scnRenderer')
			# s1.pointOfView = @ship_scene.camera
			NSLog("%@", s1)
		end
		
		self.addChild(@td_node)
		
		# A sprite which underlaps the SK3DNode
		sprite = SKSpriteNode.alloc.initWithColor(SKColor.colorWithRed(1, green: 0.5, blue: 0, alpha: 0.25), size: size)
		sprite.position = center
		sprite.zPosition = -100
		self.addChild(sprite)
	end
	
	def create_labels
		font_size = 24
		y = 640
		
		@toggle_rotation = SKLabelNode.labelNodeWithFontNamed('Chalkduster')
		@toggle_rotation.text = 'Toggle Rotation'
		@toggle_rotation.fontSize = font_size
		@toggle_rotation.position = CGPointMake(128, y)
		self.addChild(@toggle_rotation)
		
		@toggle_thrust = SKLabelNode.labelNodeWithFontNamed('Chalkduster')
		@toggle_thrust.text = 'Toggle Thrust'
		@toggle_thrust.fontSize = font_size
		@toggle_thrust.position = CGPointMake(384, y)
		self.addChild(@toggle_thrust)

		@toggle_toon_shader = SKLabelNode.labelNodeWithFontNamed('Chalkduster')
		@toggle_toon_shader.text = 'Toggle Toon'
		@toggle_toon_shader.fontSize = font_size
		@toggle_toon_shader.position = CGPointMake(640, y)
		self.addChild(@toggle_toon_shader)

		@toggle_geometry_shader = SKLabelNode.labelNodeWithFontNamed('Chalkduster')
		@toggle_geometry_shader.text = 'Toggle Deformation'
		@toggle_geometry_shader.fontSize = font_size
		@toggle_geometry_shader.position = CGPointMake(880, y)
		self.addChild(@toggle_geometry_shader)
	end
	
	def touchesBegan(touches, withEvent: event)
		touch = touches.anyObject
		position = touch.locationInNode(self)
		
		selected_label = nil
		
		if(@toggle_rotation.containsPoint(position))
			@ship_scene.toggle_rotation
			selected_label = @toggle_rotation
		end

		if(@toggle_thrust.containsPoint(position))
			@ship_scene.toggle_thrust
			selected_label = @toggle_thrust
		end

		if(@toggle_toon_shader.containsPoint(position))
			@ship_scene.toggle_toon_shader
			selected_label = @toggle_toon_shader
		end

		if(@toggle_geometry_shader.containsPoint(position))
			@ship_scene.toggle_geometry_shader
			selected_label = @toggle_geometry_shader
		end
		
		if selected_label
			selected_label.fontColor = UIColor.greenColor
			color_white = SKAction.customActionWithDuration(0.2, 
				actionBlock: lambda { |node, elapsed_time|
					progress = elapsed_time / 0.2
					node.fontColor = UIColor.colorWithRed(progress, green: 1, blue: progress, alpha: 1)
				}
			)
			selected_label.runAction(color_white)
		end
	end
	
end