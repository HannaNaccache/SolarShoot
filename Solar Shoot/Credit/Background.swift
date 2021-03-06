//
//  Background.swift
//  Solar Shoot
//
//  Created by Projet L2R1 on 08/04/2019.
//  Copyright © 2019 Projet L2R1. All rights reserved.
//

//Classe pour afficher un fond d'écran différents à chaque niveau

import Foundation
import SpriteKit
import GameplayKit

class Background {
        
        var background = SKSpriteNode()
        
        func AffichageBack(imageName: String, i:Int, parent:GameScene){
            let background = SKSpriteNode(imageNamed : imageName)
            background.zPosition = 0
            background.name = "Background"
            background.size = parent.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: parent.size.width / 2, y: parent.size.height * CGFloat(i))
            parent.addChild(background)
        }
}

