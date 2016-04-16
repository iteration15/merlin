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
        var capsule:SCNGeometry
        var pyramid:SCNGeometry
        
        merlin = SCNSphere(radius: 0.5)
        capsule = SCNCapsule(capRadius: 0.2, height: 0.7)
        pyramid = SCNPyramid(width: 0.2, height: 0.2, length: 0.2)
        
        merlin.materials.first?.diffuse.contents = UIColor.purpleColor()
        capsule.materials.first?.diffuse.contents = UIColor.greenColor()
        pyramid.materials.first?.diffuse.contents = UIColor.random()
        
        let merlinNode = SCNNode(geometry: merlin)
        let capsuleNode = SCNNode(geometry: capsule)
        let pyramidNode = SCNNode(geometry: pyramid)
        
        merlinNode.physicsBody = SCNPhysicsBody(type: .Static, shape: nil)
        capsuleNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
        pyramidNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
        
        let randomX = Float.random(min: -2, max: 0)
        let randomY = Float.random(min: 10, max: 18)
        let force = SCNVector3(x: randomX, y: randomY , z: 0)
        let position = SCNVector3(x: 0.01, y: 0.05, z: 0.05)
        capsuleNode.physicsBody?.applyForce(force, atPosition: position, impulse: true)
        pyramidNode.physicsBody?.applyForce(force, atPosition: position, impulse: true)
        
        let color = UIColor.random()
        pyramid.materials.first?.diffuse.contents = color
        
        let trailEmitter = createTrail(color, geometry: pyramid)
        pyramidNode.addParticleSystem(trailEmitter)
        
        if color == UIColor.redColor() {
            pyramidNode.name = "BAD"
        } else {
            pyramidNode.name = "GOOD"
        }
        
        scnScene.rootNode.addChildNode(merlinNode)
        //scnScene.rootNode.addChildNode(capsuleNode)
        scnScene.rootNode.addChildNode(pyramidNode)
        
        
        
        
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
