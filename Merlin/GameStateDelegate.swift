//
//  GameStateDelegate.swift
//  Merlin
//
//  Created by Kuhta, Dean on 4/13/16.
//  Copyright © 2016 Dean Kuhta. All rights reserved.
//

protocol GameStateDelegate {
    func gameStateDelegateChangeMoneyBy(delta delta: Int) -> Bool
}
