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
    var salonDeReunion = [String:Any]()
    
    @IBOutlet var imagen: UIImageView!
    @IBOutlet var titulo: UILabel!
    @IBOutlet var dia: UILabel!
    @IBOutlet var horario: UILabel!
    @IBOutlet var salon: UILabel!
    @IBOutlet var mapa: MKMapView!
    
    let urlString="https://raw.githubusercontent.com/Lucer9/OIL_APP/master/jsonFiles/salones.json"
    var datosArray:[Any]?
    var datosFiltrados = [Any]()
    
    override func viewDidLoad() {
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            super.viewDidLoad()
            
            let url = URL(string: self.urlString)
            let datos = try? Data(contentsOf: url!)
            self.datosArray = try! JSONSerialization.jsonObject(with: datos!) as? [Any]
            
            self.datosFiltrados = self.datosArray!.filter {
                let salon=$0 as! [String:Any]
                let s:String = salon["salon"] as? String ?? "";
                return s == self.reunion["salon"] as? String ?? ""
            }
            
            self.salonDeReunion = self.datosFiltrados[0] as! [String : Any]
            
            self.imagen.setImageFromURL(imageURLString: "https://via.placeholder.com/70")
            self.imagen.roundedImage()
            self.titulo.text = "Junta en \(self.salonDeReunion["nombre"] as? String ?? "ND")"
            self.salon.text = self.salonDeReunion["salon"] as? String ?? "ND"
            
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="DetalleARSalon"){
            let navigationController = segue.destination as! ARNavigationViewController
            
            let viewController = navigationController.viewControllers.first as! ARViewController
            
            viewController.salon = salonDeReunion
        }
    }
    
}
