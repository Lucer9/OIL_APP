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


class ARViewController: UIViewController,ARSCNViewDelegate {
    var salon = [String:Any]()

    @IBOutlet var sceneView: ARSCNView!
    let tierra = SCNNode()
    
    //    @IBAction func rotacion(_ sender: UIRotationGestureRecognizer) {
    //
    //        tierra.eulerAngles = SCNVector3(0,sender.rotation,0)
    //    }
    //    @IBAction func ejecucionTap(_ sender: UITapGestureRecognizer) {
    //
    //
    //        let escena = sender.view as! SCNView
    //        let location = sender.location(in: escena)
    //        let hitResults  = escena.hitTest(location, options: [:])
    //        if !hitResults.isEmpty{
    //            let nodoTocado = hitResults[0].node
    //            nodoTocado.eulerAngles = SCNVector3(0,1,0)
    //
    //        }
    
    
    //    }
    override func viewDidLoad() {
        
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            super.viewDidLoad()
            
            let nombre = self.salon["nombre"] as? String ?? nil
            let numeroSalon = self.salon["salon"] as? String ?? "Sin nombre"
            
            if(nombre != nil && nombre != ""){
                self.navigationItem.title = nombre
            }else{
                self.navigationItem.title = numeroSalon
            }
            
            self.navigationItem.prompt = "CEDETEC | \(numeroSalon)"
            
            let salonPanoramica = self.salon["panoramica"] as? String ?? "https://thenextweb.com/wp-content/blogs.dir/1/files/2015/06/Prague_Getty.jpg"
            
            
            // Set the view's delegate
            self.sceneView.delegate = self
            
            // Show statistics such as fps and timing information
            self.sceneView.showsStatistics = true
            self.sceneView.autoenablesDefaultLighting = true //necesario para que se muestre la luz especular
            
            // Create a new scene
            //let scene = SCNScene(named: "art.scnassets/ship.scn")!
            let scene = SCNScene()
            
            let esfera = SCNSphere(radius: 2.0)
            let materialTierra = SCNMaterial()
            //https://www.solarsystemscope.com/textures
            materialTierra.diffuse.contents = salonPanoramica
            materialTierra.isDoubleSided = true
            //        materialTierra.diffuse.contents = #imageLiteral(resourceName: "AddTask")
            //        materialTierra.specular.contents = #imageLiteral(resourceName: "Tierra specular")
            //        materialTierra.emission.contents =  #imageLiteral(resourceName: "Tierra emmision")
            //        materialTierra.normal.contents = #imageLiteral(resourceName: "Tierra normal")
            self.tierra.geometry = esfera
            self.tierra.geometry?.materials = [materialTierra]
            //tierra.geometry?.firstMaterial?.specular.contents = UIColor.white
            self.tierra.position = SCNVector3(x:0, y:0, z:0)
            scene.rootNode.addChildNode(self.tierra)
            
            let pinchGestureRecognizer = UIPinchGestureRecognizer (target: self, action: #selector(self.escalado))
            
            self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
            
            // Set the scene to the view
            self.sceneView.scene = scene
            
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    @objc func escalado(recognizer:UIPinchGestureRecognizer)
    {
        
        tierra.scale = SCNVector3(recognizer.scale, recognizer.scale, recognizer.scale)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="DetalleSalon"){
            let controller = segue.destination as! ListaMaterialTableViewController
            
            controller.salonSeleccionado = salon
        }
    }
    
}
