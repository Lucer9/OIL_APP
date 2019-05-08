//
//  ARViewController.swift
//  OIL_APP
//
//  Created by L9 on 4/10/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//
import SceneKit
import ARKit
import UIKit

class ObjectViewController: UIViewController,ARSCNViewDelegate {
    var escenaPath = ""
    var texturasPath = ""
    var isVisible = true
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if(sender.state == .ended){
           
            if (isVisible){
//                tierra.isHidden=true;
//                tierraOther.isHidden=true;
                tierra.removeFromParentNode()
                tierraOther.removeFromParentNode()
                isVisible=false;
            }else{
//                tierra.isHidden=false;
//                tierraOther.isHidden=false;
                scene.rootNode.addChildNode(tierra)
                scene.rootNode.addChildNode(tierraOther)
                isVisible=true;
            }
            print(isVisible)
        }
        

    }
    @IBOutlet var sceneView: ARSCNView!
    var tierra = SCNNode()
    var tierraOther = SCNNode()
    var scene = SCNScene()

    
    @IBAction func rotacion(_ sender: UIRotationGestureRecognizer) {
        
        tierra.eulerAngles = SCNVector3(90,sender.rotation*2,0)
    }
    @IBAction func ejecucionTap(_ sender: UITapGestureRecognizer) {
        
        
        let escena = sender.view as! SCNView
        let location = sender.location(in: escena)
        let hitResults  = escena.hitTest(location, options: [:])
        if !hitResults.isEmpty{
            let nodoTocado = hitResults[0].node
            nodoTocado.eulerAngles = SCNVector3(0,1,0)
            
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        var escenaURL = URL(string: escenaPath)
        let defaultScene = SCNScene(named:"art.scnassets/ship.scn")
        do{
            
            try scene = SCNScene(url:escenaURL!)
        } catch {
            print(error)
            scene = defaultScene!
        }
        
        self.sceneView.scene = scene
        self.tierra = scene.rootNode.childNode(withName: "pm0133_00", recursively: true)!
        self.tierraOther = scene.rootNode.childNode(withName: "Eevee", recursively: true)!
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true //necesario para que se muestre la luz especular
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let materialTierra = SCNMaterial()
        //https://www.solarsystemscope.com/textures
        materialTierra.diffuse.contents = texturasPath
        materialTierra.isDoubleSided = true
        
        tierraOther.geometry?.materials = [materialTierra]
        tierra.position = SCNVector3(x:0, y:0, z:0)
        tierra.scale = SCNVector3(x:0.003, y:0.003, z:0.003)
        scene.rootNode.addChildNode(tierra)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer (target: self, action: #selector(escalado))
        
        sceneView.addGestureRecognizer(pinchGestureRecognizer)
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    @objc func escalado(recognizer:UIPinchGestureRecognizer)
    {
        
        tierra.scale = SCNVector3(recognizer.scale/100, recognizer.scale/100, recognizer.scale/100)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
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
    
    @IBAction func cerrarView(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
