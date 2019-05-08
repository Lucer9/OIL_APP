//
//  IniciarSesionViewController.swift
//  OIL_APP
//
//  Created by cdt307 on 4/29/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit
import FirebaseAuth

class IniciarSesionViewController: UIViewController {

    @IBOutlet var correoField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func IniciarSesion(_ sender: Any) {
        let correo:String = correoField.text!
        let password:String = passwordField.text!
        
        if(correo==""||password==""){
            let alert = UIAlertController(title: "Necesita ingresar ambos datos", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        passwordField.text = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let child = SpinnerViewController()
            self.addChild(child)
            child.view.frame = self.view.frame
            self.view.addSubview(child.view)
            child.didMove(toParent: self)
            
            Auth.auth().signIn(withEmail: correo, password: password){
                (user, error) in
                if error != nil{
                    print(error!)
                    let alert = UIAlertController(title: "¡Ooops! ocurrió un error", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                }else{
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                    let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "inicio") as! PantallaDeInicioViewController
                    
                    self.present(siguienteVista, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if Auth.auth().currentUser != nil {
            let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "inicio") as! PantallaDeInicioViewController
            
            self.present(siguienteVista, animated: true, completion: nil)
        }
    }
}
