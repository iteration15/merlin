//
//  ContinuousProgressBar.swift
//  Merlin
//
//  Created by Kuhta, Dean on 4/13/16.
//  Copyright © 2016 Dean Kuhta. All rights reserved.
//

import SpriteKit
import Foundation

class ContinuousProgressBar : ProgressBar {
    var node : SKNode
    var emptyItem : SKSpriteNode
    var fullItem : SKCropNode
    var fullSprite : SKSpriteNode
    
    init(emptyImageName : String, fullImageName : String) {
        node = SKNode()
        emptyItem = SKSpriteNode(imageNamed: emptyImageName)
        emptyItem.zPosition = CGFloat(ZPosition.stockItemsBackground.rawValue)
        fullItem = SKCropNode()
        fullItem.zPosition = CGFloat(ZPosition.stockItemsForeground.rawValue)
        fullSprite = SKSpriteNode(imageNamed: fullImageName)
        fullItem.addChild(fullSprite)
        node.addChild(emptyItem)
        node.addChild(fullItem)
        setProgress(percentage: 0)
    }
    
    func setProgress(percentage percentage: Float) {
        let mask = SKShapeNode()
        mask.fillColor = mask.strokeColor
        
        let maskRect = CGRect(x: Int(-fullSprite.size.width) / 2, y: Int(-fullSprite.size.height), width: Int(fullSprite.size.width), height: Int(Float(fullSprite.size.height) * percentage))
        
        mask.path = CGPathCreateWithRect(maskRect, nil)
        let view = SKView()
        let maskTexture = view.textureFromNode(mask)
        fullItem.maskNode = SKSpriteNode(texture: maskTexture)
    }
    
}