//
//  TileMapScene.swift
//
//  Created by MARK BROWNSWORD on 5/9/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol TileMapScene {
    var backgroundLayer: SKTileMapNode! { get set }
    var gridLayer: SKTileMapNode! { get set }
    var selectionLayer: SKTileMapNode! { get set }
    var buildingsLayer: SKTileMapNode! { get set }
    var startTilePosition: CGPoint? { get set }
    var gameScene: SKScene! { get }
    
    var camera: SKCameraNode? { get }
    var scaleMode: SKSceneScaleMode { get set }
}
