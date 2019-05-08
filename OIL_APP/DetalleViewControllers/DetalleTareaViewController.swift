//
//  DetalleTareaViewController.swift
//  OIL_APP
//
//  Created by Miguel on 4/10/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//
import UIKit
import FirebaseFirestore

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
    
    @IBAction func TareaRealizada(_ sender: Any) {
        let id = tarea["id"] as! String

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            let child = SpinnerViewController()
            self.addChild(child)
            child.view.frame = self.view.frame
            self.view.addSubview(child.view)
            child.didMove(toParent: self)
            
            let db = Firestore.firestore()
            db.collection("tareas").document(id).setData(["realizada": true], merge: true) { err in
                if let err = err {
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                    let alert = UIAlertController(title: "Ocurrió un error", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                    
                    let alert = UIAlertController(title: "Se marcó la tarea \(self.tarea["titulo"]!) como realizada", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Gracias", style: .default, handler: self.showPrevious))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func showPrevious(action:UIAlertAction){
        _ = navigationController?.popViewController(animated: true)
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
