//
//  DiscreteProgressBar.swift
//  Merlin
//
//  Created by Kuhta, Dean on 4/13/16.
//  Copyright © 2016 Dean Kuhta. All rights reserved.
//

import SpriteKit

class DiscreteProgressBar : ProgressBar {
    
    var node : SKNode
    private var currentSprite = SKSpriteNode()
    private let sprites : [SKTexture]
    
    init(baseName: String) {
        node = SKNode()
        var spritesTemp = [SKTexture]()
        var count = 0
        var fileExists: Bool
        repeat {
            let fileName = String(format: baseName, count)
            let image : UIImage? = UIImage(named: fileName)
            if image == nil {
                fileExists = false
            } else {
                spritesTemp.append(SKTexture(image: image!))
                fileExists = true
            }
            count += 1
        } while fileExists
        sprites = spritesTemp
        currentSprite = SKSpriteNode(texture: spritesTemp[0])
        currentSprite.zPosition = CGFloat(ZPosition.stockItemsBackground.rawValue)
        node.addChild(currentSprite)
        setProgress(percentage: 0)
    }
    
    func setProgress(percentage percentage: Float) {
        let spriteNumber = min(Int(percentage * Float(sprites.count)), sprites.count - 1)
        let texture = sprites[spriteNumber]
        currentSprite.texture = texture
    }
    
}