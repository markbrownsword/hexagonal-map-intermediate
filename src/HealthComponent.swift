//
//  HealthComponent.swift
//
//  Created by MARK BROWNSWORD on 16/10/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

class HealthComponent: GKComponent, Component {
    
    // MARK: Private Properties
    
    private var updateRequired: Bool = false
    private var node: SKSpriteNode!
    private lazy var circle: SKShapeNode = {
        [unowned self] in let circle = SKShapeNode(circleOfRadius: 10)
        circle.position = CGPoint(x: self.node.size.width / 2, y: self.node.size.height / 2)
        circle.strokeColor = SKColor.black
        circle.glowWidth = 1.0
        circle.zPosition = CGFloat(self.node.children.count + 1)
        
        return circle
    }()
    
    
    // MARK: Public Properties
    
    var health: Int = 100 {
        didSet {
            self.updateRequired = true
        }
    }
    
    
    // MARK: Initialization Functions
    
    required init(node: SKSpriteNode) {
        super.init()
        
        self.updateRequired = true
        self.node = node
        self.node.addChild(self.circle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Override Functions
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if !updateRequired {
            return
        }
        
        // print("Updating Health: \(health)")
        
        self.circle.fillColor = GetCircleColour(health: health)
        updateRequired = false
    }
    
    
    // MARK: Private Functions
    
    private func GetCircleColour(health: Int) -> SKColor {
        var result: SKColor
        switch health {
            case 50...100:
                result = SKColor.green
            case 25..<50:
                result = SKColor.orange
            default:
                result = SKColor.red
        }
        
        return result
    }
}
