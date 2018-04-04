//
//  ViewController.swift
//  UnkoAR
//
//  Created by Yuta Kawabe on 2018/04/04.
//  Copyright © 2018年 Yuta Kawabe. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var planeNodes:[PlaneNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        self.addCatScene()
//        self.addPoopScene()
        self.addTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                let panelNode = PlaneNode(anchor: planeAnchor)
                panelNode.isDisplay = true
                node.addChildNode(panelNode)
                self.planeNodes.append(panelNode)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor, let planeNode = node.childNodes[0] as? PlaneNode {
                planeNode.update(anchor: planeAnchor)
            }
        }
    }
}

extension ViewController {
    
    private func addTapGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addPoopScene(recognizer:)))
        self.sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    private func addCatScene() {
        let scene = SCNScene(named: "art.scnassets/cat.scn")!
        let node = scene.rootNode.childNode(withName: "Cat", recursively: true)!
        node.position = SCNVector3(0, -1, -5)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    @objc
    private func addPoopScene(recognizer: UIGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.sceneView)
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty {
            let scene = SCNScene(named: "art.scnassets/nakpoop.scn")!
            let node = scene.rootNode.childNode(withName: "Poop", recursively: true)!
            node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: node.geometry!, options: nil))
            node.physicsBody?.categoryBitMask = 1
            let hitResult = hitTestResult.first!
            node.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.5, hitResult.worldTransform.columns.3.z)
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
}
