//
//  ProgressBar.swift
//  Merlin
//
//  Created by Kuhta, Dean on 4/13/16.
//  Copyright © 2016 Dean Kuhta. All rights reserved.
//

import SpriteKit

protocol ProgressBar {
    var node : SKNode {get}
    func setProgress(percentage percentage: Float)
}