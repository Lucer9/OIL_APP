//
//  ViewController.swift
//  Perlas
//
//  Created by molina on 3/28/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class objetoMarcadirViewController: UIViewController, ARSCNViewDelegate {
    var escenaPath =  "https://github.com/Lucer9/OIL_APP/raw/master/perlas.scn"
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        //let configuration = ARWorldTrackingConfiguration()
        
        //Cambio 1 cambiar a trackin a través de imagen
        //let configuration = ARWorldTrackingConfiguration()
        let configuration = ARImageTrackingConfiguration()
        
        //Cambio 2, asignar la imagen marcadora
        guard let imagenesMarcador = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("No se encontró la imagen marcadora")
        }
        configuration.trackingImages = imagenesMarcador
        // Run the view's session
        sceneView.session.run(configuration)
    }
    //cambio 3, definir el método que será invocado al identificar una imágen marcador
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let anchor = anchor as? ARImageAnchor{
            let imagenReferencia = anchor.referenceImage
            agregarModelo(to: node, refImage: imagenReferencia)
        }
    }
    
    private func agregarModelo(to node:SCNNode, refImage:ARReferenceImage ){
        DispatchQueue.global().async {
            
            var escenaModelo = SCNScene()
            var escenaURL = URL(string: self.escenaPath)
            let defaultScene = SCNScene(named:"art.scnassets/ship.scn")
            do{
                
                try escenaModelo = SCNScene(url:escenaURL!)
            } catch {
                print(error)
                escenaModelo = defaultScene!
            }
            
            
            //encontrar el nodo principal
            let nodoPrincipal = escenaModelo.rootNode.childNode(withName: "lap", recursively: true)!
            node.addChildNode(nodoPrincipal)
        }
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
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
}
