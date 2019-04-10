//
//  DetalleReunionViewController.swift
//  OIL_APP
//
//  Created by Miguel on 4/10/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//
import UIKit
import MapKit

class DetalleReunionViewController: UIViewController {
    var reunion = [String:Any]()

    @IBOutlet var imagen: UIImageView!
    @IBOutlet var titulo: UILabel!
    @IBOutlet var dia: UILabel!
    @IBOutlet var horario: UILabel!
    @IBOutlet var salon: UILabel!
    @IBOutlet var mapa: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagen.setImageFromURL(imageURLString: "https://via.placeholder.com/70")
        imagen.roundedImage()
        titulo.text = reunion["titulo"] as! String
        salon.text = String(reunion["salon"] as! Int)
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
