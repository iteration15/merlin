//
//  GameViewController.swift
//  Merlin
//
//  Created by Kuhta, Dean on 4/13/16.
//  Copyright (c) 2016 Dean Kuhta. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    
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
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
    }
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
    }
    
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func spawnShape() {
        var merlin:SCNGeometry
        var food:SCNGeometry
        
        merlin = SCNSphere(radius: 0.5)
        food = SCNCapsule(capRadius: 0.2, height: 0.7)
        
        let merlinNode = SCNNode(geometry: merlin)
        let foodNode = SCNNode(geometry: food)
        
        scnScene.rootNode.addChildNode(merlinNode)
        scnScene.rootNode.addChildNode(foodNode)
        
        merlinNode.physicsBody = SCNPhysicsBody(type: .Static, shape: nil)
        foodNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
    }
}
