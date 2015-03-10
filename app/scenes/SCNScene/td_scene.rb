# /Applications/Xcode.app/Contents/Developer/usr/bin/copySceneKitAssets art.scnassets/ -o art-optimized.scnassets

class TDScene < SCNScene
	attr_accessor :ship, :thrust1, :thrust2, :camera
	
	def self.ship_scene
		scene = self.sceneNamed('art-optimized.scnassets/ship.dae')
	
		# remember the ship
		scene.ship = scene.rootNode.childNodeWithName('ship', recursively: true)
		
		# create and add a camera to the scene
		scene.camera = SCNNode.node
		scene.camera.camera = SCNCamera.camera
		scene.camera.position = [0, 0, 15]
		scene.camera.camera.xFov = 40 # so we can see more of our center of frame: the harrier
		scene.camera.camera.yFov = 40
		scene.rootNode.addChildNode(scene.camera)
		
		# create and add a light to the scene
		light_node = SCNNode.node
		light_node.light = SCNLight.light
		light_node.light.type = SCNLightTypeDirectional
		light_node.position = [0, 10, 10]
		light_node.rotation = [1, 1, 0, Math::PI / 4 * -1]
		light_node.light.color = UIColor.colorWithRed(0.7, green: 0.7, blue: 7, alpha: 1)
		scene.rootNode.addChildNode(light_node)
		
		# create and add an ambient light to the scene
		ambient_light_node = SCNNode.node
		ambient_light_node.light = SCNLight.light
		ambient_light_node.light.type = SCNLightTypeAmbient
		ambient_light_node.light.color = UIColor.darkGrayColor
		scene.rootNode.addChildNode(ambient_light_node)
		
		# Emitters
		# warning: These emitters appear to have a big impact on initial loading time.
		# Comment these lines and see the difference
		begin
			scene.thrust1 = scene.rootNode.childNodeWithName('emitter', recursively: true)
			particle_system = SCNParticleSystem.particleSystemNamed('Smoke', inDirectory: nil)
			scene.thrust1.addParticleSystem(particle_system)
		
			scene.thrust2 = scene.thrust1.clone
			begin
				v = scene.thrust2.position
				v.x *= -1
				scene.thrust2.position = v
			end
			particle_system_2 = SCNParticleSystem.particleSystemNamed('Smoke', inDirectory: nil)
			scene.thrust2.addParticleSystem(particle_system_2)
			scene.thrust1.parentNode.addChildNode(scene.thrust2)
			
			scene.thrust1.removeFromParentNode
			scene.thrust2.removeFromParentNode
		end
		
		scene
	end
	
	# CONTROLS
	
	def toggle_rotation
		# animate the 3d object
		if @ship.actionForKey('rotation')
			@ship.removeAllActions
		else
			@ship.runAction(
				SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 5)), forKey: 'rotation'
			)
		end
	end
	
	def toggle_thrust
		if @thrust1.parentNode
			@thrust1.removeFromParentNode
			@thrust2.removeFromParentNode
		else
			mesh = @ship.childNodes.firstObject
			
			mesh.addChildNode(@thrust1)
			mesh.addChildNode(@thrust2)
		end
	end
	
	def toggle_toon_shader
		# retrieve the ship node
		mesh = @ship.childNodes.firstObject
		g = mesh.geometry
		
		# shader_modifiers = g.shaderModifiers.mutableCopy
		shader_modifiers = g.shaderModifiers.nil? ? NSMutableDictionary.new : g.shaderModifiers.mutableCopy
		
		# shader_modifiers = NSMutableDictionary.new if not shader_modifiers
		
		if not shader_modifiers.objectForKey(SCNShaderModifierEntryPointLightingModel)
			shader_modifiers.setObject(light_cel_shading_modifier, forKey: SCNShaderModifierEntryPointLightingModel)
			g.setValue(1.0, forKey: 'lightIntensity')
		else
			shader_modifiers.removeObjectForKey(SCNShaderModifierEntryPointLightingModel)
		end
		
		g.shaderModifiers = shader_modifiers.copy
	end
	
	def toggle_geometry_shader
		# retrieve the ship node
		mesh = @ship.childNodes.firstObject
		g = mesh.geometry
		
		# shader_modifiers = g.shaderModifiers.mutableCopy
		shader_modifiers = g.shaderModifiers.nil? ? NSMutableDictionary.new : g.shaderModifiers.mutableCopy

		# shader_modifiers = NSMutableDictionary.new if not shader_modifiers
		
		if not shader_modifiers.objectForKey(SCNShaderModifierEntryPointGeometry)
			shader_modifiers.setObject(geom_modifier, forKey: SCNShaderModifierEntryPointGeometry)
			tgt_factor = 0.3
		else
			shader_modifiers.removeObjectForKey(SCNShaderModifierEntryPointGeometry)
			tgt_factor = 0.0
		end
		
		SCNTransaction.begin
		SCNTransaction.setAnimationDuration(2.0)
		g.shaderModifiers = shader_modifiers.copy
		g.setValue(NSNumber.numberWithFloat(tgt_factor), forKey: 'twistFactor')
		SCNTransaction.commit
	end
	
	# SHADER MODIFIERS	
	def frag_modifier
		@frag_modifier ||= NSString.stringWithContentsOfFile(NSBundle.mainBundle.pathForResource('shaders/sm_frag', ofType: 'shader'), encoding: NSUTF8StringEncoding, error: nil)
	end
	
	
	def light_cel_shading_modifier
		@light_cel_shading_modifier ||= NSString.stringWithContentsOfFile(NSBundle.mainBundle.pathForResource('shaders/sm_light_cel_shading', ofType: 'shader'), encoding: NSUTF8StringEncoding, error: nil)
	end
	
	def geom_modifier
		@geom_modifier ||= NSString.stringWithContentsOfFile(NSBundle.mainBundle.pathForResource('shaders/sm_geom', ofType: 'shader'), encoding: NSUTF8StringEncoding, error: nil)
	end

end