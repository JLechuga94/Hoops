//
//  ViewController.swift
//  AR_Hoops
//
//  Created by Julian Lechuga Lopez on 26/6/18.
//  Copyright © 2018 Julian Lechuga Lopez. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var planeDetected: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.delegate = self
        self.configuration.planeDetection = .horizontal
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        guard let sceneView = sender.view as? ARSCNView else {return}
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty{
            self.addItem(hitTestResult: hitTest.first!)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        DispatchQueue.main.async{
            self.planeDetected.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.planeDetected.isHidden = true
            }
        }
        
    }
    
    func addItem(hitTestResult: ARHitTestResult){
        let scene = SCNScene(named: "Basketball.scnassets/Basketball.scn")
        let basketballNode = scene!.rootNode.childNode(withName: "Basket", recursively: false)!
        let transform = hitTestResult.worldTransform
        let planePosition = transform.columns.3
        basketballNode.position = SCNVector3(planePosition.x,planePosition.y,planePosition.z)
        self.sceneView.scene.rootNode.addChildNode(basketballNode)
        
    }

}

