//
//  RegistrarUsuarioViewController.swift
//  OIL_APP
//
//  Created by cdt307 on 4/29/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class RegistrarUsuarioViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var nombreField: UITextField!
    @IBOutlet var idField: UITextField!
    @IBOutlet var correoField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var repeatPasswordField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var hasPickedImage = false
    
    @IBAction func SelectImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        hasPickedImage = true
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = chosenImage
        imageView.roundedImage()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registrarButton(_ sender: Any) {
        
        if(!hasPickedImage){
            let alert = UIAlertController(title: "Por favor seleccione una imagen", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let nombre:String = nombreField.text!
        let id:String = idField.text!
        let correo:String = correoField.text!
        let password:String = passwordField.text!
        let repeatPassword:String = repeatPasswordField.text!
        
        if(nombre==""||id==""||correo==""||password==""||repeatPassword==""){
            let alert = UIAlertController(title: "Por favor llene todos los campos", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if(password != repeatPassword){
            let alert = UIAlertController(title: "Las contraseñas no coinciden", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        var imageURL:String = ""
        
        let timestamp = NSDate().timeIntervalSince1970
        let storageRef = Storage.storage().reference().child("images/\(timestamp).jpeg")
        
        var data = Data()
        data = (imageView.image?.jpegData(compressionQuality: 0.8))!
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let child = SpinnerViewController()
            self.addChild(child)
            child.view.frame = self.view.frame
            self.view.addSubview(child.view)
            child.didMove(toParent: self)
            
            storageRef.putData(data, metadata: nil) { (metadata, error) in
                if error != nil{
                    let alert = UIAlertController(title: "Ocurrió un error al momento de subir la foto", message: error.debugDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        let alert = UIAlertController(title: "Ocurrió un error al momento de subir la foto", message: error.debugDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        child.willMove(toParent: nil)
                        child.view.removeFromSuperview()
                        child.removeFromParent()
                    }
                    
                    imageURL = (url?.absoluteString)!
                    
                    Auth.auth().createUser(withEmail: correo, password: password) { (authResult, error) in
                        
                        guard let user = authResult?.user else {
                            return
                        }
                        
                        if error != nil{
                            let alert = UIAlertController(title: "Ocurrió un error al momento de crear la cuenta", message: error.debugDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                            self.present(alert, animated: true)
                            child.willMove(toParent: nil)
                            child.view.removeFromSuperview()
                            child.removeFromParent()
                        }else{
                            let db = Firestore.firestore()
                            db.collection("users").document(user.uid).setData([
                                "nombre": nombre,
                                "id": id,
                                "imagen": imageURL
                            ]) { err in
                                if let err = err {
                                    let alert = UIAlertController(title: "Ocurrió un error al momento de crear la cuenta", message: err.localizedDescription, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                                    self.present(alert, animated: true)
                                    child.willMove(toParent: nil)
                                    child.view.removeFromSuperview()
                                    child.removeFromParent()
                                } else {
                                    child.willMove(toParent: nil)
                                    child.view.removeFromSuperview()
                                    child.removeFromParent()
                                    
                                    let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "inicio") as! PantallaDeInicioViewController
                                    
                                    self.present(siguienteVista, animated: true, completion: nil)
                                }
                            }
                        }
                        
                    }
                })
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
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
