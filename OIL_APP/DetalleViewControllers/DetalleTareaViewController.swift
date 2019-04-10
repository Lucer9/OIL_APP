//
//  DetalleTareaViewController.swift
//  OIL_APP
//
//  Created by Miguel on 4/10/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//
import UIKit

class DetalleTareaViewController: UIViewController {
    
    var tarea: [String: Any] = [:]
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var tiempo: UILabel!
    @IBOutlet var detalle: UITextView!
    @IBOutlet weak var asignadaA: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titulo.text = tarea["titulo"] as? String
        let asignadoA = tarea["asignadoA"] as? [String: Any]
        asignadaA.text = asignadoA!["nombreIntegrante"] as? String
        detalle.text = tarea["descripcion"] as? String
        imagen.setImageFromURL(imageURLString: asignadoA!["imagen"] as! String)
        imagen.roundedImage()
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
