//
//  GameViewController.swift
//  Merlin
//
//  Created by Kuhta, Dean on 4/13/16.
//  Copyright (c) 2016 Dean Kuhta. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var spawnTime:NSTimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        spawnShape()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupView() {
        scnView = self.view as! SCNView
        scnView.showsStatistics = true
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = true
        scnView.delegate = self
    }
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
    }
    
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 10)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func spawnShape() {
        var merlin:SCNGeometry
        var torus:SCNGeometry
        var pyramid:SCNGeometry
        
        merlin = SCNCone(topRadius: 0, bottomRadius: 0.5, height: 2.0)
        torus = SCNTorus(ringRadius: 0.8, pipeRadius: 0.2)
        pyramid = SCNPyramid(width: 0.8, height: 0.8, length: 0.8)
        
        merlin.materials.first?.diffuse.contents = UIColor.purpleColor()
        torus.materials.first?.diffuse.contents = UIColor.random()
        pyramid.materials.first?.diffuse.contents = UIColor.random()
        
        let merlinNode = SCNNode(geometry: merlin)
        let torusNode = SCNNode(geometry: torus)
        let pyramidNode = SCNNode(geometry: pyramid)
        
        merlinNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
        torusNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
        pyramidNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
        
        let randomX = Float.random(min: -2, max: 0)
        let randomY = Float.random(min: 10, max: 18)
        let force = SCNVector3(x: randomX, y: randomY , z: 0)
        let position = SCNVector3(x: 0.01, y: 0.05, z: 0.05)
        torusNode.physicsBody?.applyForce(force, atPosition: position, impulse: true)
        pyramidNode.physicsBody?.applyForce(force, atPosition: position, impulse: true)
        
        let color = UIColor.random()
        torus.materials.first?.diffuse.contents = color
        
        let trailEmitter = createTrail(color, geometry: torus)
        torusNode.addParticleSystem(trailEmitter)
        
        if color == UIColor.redColor() {
            pyramidNode.name = "BAD"
        } else {
            pyramidNode.name = "GOOD"
        }
        
        scnScene.rootNode.addChildNode(merlinNode)
        scnScene.rootNode.addChildNode(torusNode)
        //scnScene.rootNode.addChildNode(pyramidNode)
        
        
        
        
    }
    
    func createTrail(color: UIColor, geometry: SCNGeometry) -> SCNParticleSystem {
        let trail = SCNParticleSystem(named: "Trail.scnp", inDirectory: nil)!
        trail.particleColor = color
        trail.emitterShape = geometry
        return trail
    }

    
    func cleanScene() {
        for node in scnScene.rootNode.childNodes {
            if node.presentationNode.position.y < -6 {
                node.removeFromParentNode()
            }
        }
    }
    
    func handleTouchFor(node: SCNNode) {
        if node.name == "GOOD" {
            //game.score += 1
            node.removeFromParentNode()
        } else if node.name == "BAD" {
            //game.lives -= 1
            node.removeFromParentNode()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let location = touch.locationInView(scnView)
        let hitResults = scnView.hitTest(location, options: nil)
        if hitResults.count > 0 {
            let result = hitResults.first!
            handleTouchFor(result.node)
        }
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(renderer: SCNSceneRenderer, updateAtTime time:
        NSTimeInterval) {
        if time > spawnTime {
            spawnShape()
            spawnTime = time + NSTimeInterval(Float.random(min: 0.5, max: 1.5))
        }
        cleanScene()
        //game.updateHUD()
    }
    
}
