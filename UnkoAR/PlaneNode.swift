//
//  PlaneNode.swift
//  UnkoAR
//
//  Created by Yuta Kawabe on 2018/04/04.
//  Copyright © 2018年 Yuta Kawabe. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PlaneNode: SCNNode {
    
    private override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        
        geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        SCNVector3Make(anchor.extent.x, 0, anchor.extent.z)
        transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry!, options: nil))
        setPhysicsBody()
    }
    
    func update(anchor: ARPlaneAnchor) {
        (geometry as! SCNPlane).width = CGFloat(anchor.extent.x)
        (geometry as! SCNPlane).height = CGFloat(anchor.extent.z)
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry!, options: nil))
        setPhysicsBody()
    }
    
    func setPhysicsBody() {
        physicsBody?.categoryBitMask = 2
        physicsBody?.friction = 1
        physicsBody?.restitution = 0
    }
    
    var isDisplay: Bool = false {
        didSet {
            let planeMaterial = SCNMaterial()
            if isDisplay {
                planeMaterial.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            }
            else {
                planeMaterial.diffuse.contents = UIColor.white.withAlphaComponent(0.0)
            }
            geometry?.materials = [planeMaterial]
        }
    }
}
