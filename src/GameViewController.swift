//
//  GameViewController.swift
//
//  Created by MARK BROWNSWORD on 24/7/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    private var sceneNode: TileMapScene!
    
    
    // MARK: Property Overrides
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // MARK: Function overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let scene = GKScene(fileNamed: "MarsGameScene") else {
            fatalError("GKScene not found")
        }

        guard let sceneNode = scene.rootNode as! TileMapScene? else {
            fatalError("SKScene not found")
        }
        
        guard let view = self.view as! SKView? else {
            fatalError("SKView not found")
        }
        
        self.sceneNode = sceneNode
        self.sceneNode.scaleMode = .aspectFill
        //self.sceneNode.startTilePosition = // TODO: set from saved data
        
        view.presentScene(self.sceneNode.gameScene)
        view.ignoresSiblingOrder = true

#if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
#endif        
    }
    
    override func viewWillLayoutSubviews() {
        let userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        let isLandscape = UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        
        let boundaryRangeXInput = (self.view?.bounds.size.width)!
        let boundaryRangeX = self.sceneNode.backgroundLayer.getBoundaryRangeX(boundaryRangeXInput)
        
        let boundaryRangeYInput = (self.view?.bounds.size.height)!
        let boundaryRangeY = self.sceneNode.backgroundLayer.getBoundaryRangeY(boundaryRangeYInput)
        
        guard let camera = self.sceneNode.camera else {
            fatalError("Camera not found")
        }
        
        // Update camera scale for device / orientation
        camera.updateScaleFor(userInterfaceIdiom: userInterfaceIdiom, isLandscape: isLandscape)
        
        // Move camera position within boundary (on device rotation)
        camera.updateBoundaryPositionX(boundaryRangeX, y: boundaryRangeY)
        
        // Set camera boundary constraints (on load and on device rotation)
        camera.updateConstraintsFor(backgroundLayer: self.sceneNode.backgroundLayer, boundaryRangeX: boundaryRangeX, boundaryRangeY: boundaryRangeY)
    }
}
