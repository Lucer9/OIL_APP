//
//  SettingsViewController.swift
//  OIL_APP
//
//  Created by periodismo on 4/30/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SettingsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nombreField: UITextField!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var correoField: UITextField!
    
    var imagePicker = UIImagePickerController()
    var chosenImage:NSURL? = nil
    
    @IBAction func SelectImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        editImage = true
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.chosenImage = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
        imageView.image = chosenImage
        imageView.roundedImage()
        dismiss(animated: true, completion: nil)
    }
    
    var nombre:String = ""
    var id:String = ""
    var correo:String = ""
    var imagenURL:String = ""
    var editImage:Bool = false
    var uid:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let child = SpinnerViewController()
            self.addChild(child)
            child.view.frame = self.view.frame
            self.view.addSubview(child.view)
            child.didMove(toParent: self)
            
            self.uid = Auth.auth().currentUser!.uid
            self.correo = Auth.auth().currentUser!.email!
            let userRef = Firestore.firestore().collection("users").document(self.uid)
            var userInfo = [String:Any]()
            
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    userInfo = dataDescription!
                    print(userInfo)
                    self.nombre = userInfo["nombre"] as! String
                    self.id = userInfo["id"] as! String
                        self.imagenURL = userInfo["imagen"] as! String
                    
                    self.imageView.setImageFromURL(imageURLString: self.imagenURL)
                    self.imageView.roundedImage()
                    self.nombreField.text = self.nombre
                    self.idField.text = self.id
                    self.correoField.text = self.correo
                    
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                } else {
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                    print("Document does not exist")
                }
            }
        }
    }

    @IBAction func editarUsuario(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let child = SpinnerViewController()
            self.addChild(child)
            child.view.frame = self.view.frame
            self.view.addSubview(child.view)
            child.didMove(toParent: self)
            
            if(self.editImage){
                let timestamp = NSDate().timeIntervalSince1970
                let storageRef = Storage.storage().reference().child("images/\(timestamp).jpeg")
                
                var data = Data()
                data = (self.imageView.image?.jpegData(compressionQuality: 0.8))!
                
                storageRef.putData(data, metadata: nil) { (metadata, error) in
                    if error != nil{
                        child.willMove(toParent: nil)
                        child.view.removeFromSuperview()
                        child.removeFromParent()
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil{
                            child.willMove(toParent: nil)
                            child.view.removeFromSuperview()
                            child.removeFromParent()
                        }
                        
                        let imageURL = (url?.absoluteString)!
                        let editedNombre = self.nombreField.text
                        let editedId = self.idField.text
                        let editedCorreo = self.correoField.text
                        
                        let db = Firestore.firestore()
                        db.collection("users").document(self.uid).setData([
                            "nombre": editedNombre,
                            "id": editedId,
                            "imagen": imageURL
                        ]) { err in
                            if let err = err {
                                //Mostrar error
                                child.willMove(toParent: nil)
                                child.view.removeFromSuperview()
                                child.removeFromParent()
                            } else {
                                
                                child.willMove(toParent: nil)
                                child.view.removeFromSuperview()
                                child.removeFromParent()
                            }
                        }
                    })
                }
            }else{
                let editedNombre = self.nombreField.text
                let editedId = self.idField.text
                let editedCorreo = self.correoField.text
                
                let db = Firestore.firestore()
                db.collection("users").document(self.uid).setData([
                    "nombre": editedNombre,
                    "id": editedId,
                    "imagen": self.imagenURL
                ]) { err in
                    if let err = err {
                        //Mostrar error
                        child.willMove(toParent: nil)
                        child.view.removeFromSuperview()
                        child.removeFromParent()
                    } else {
                        child.willMove(toParent: nil)
                        child.view.removeFromSuperview()
                        child.removeFromParent()
                    }
                }
            }
        }
    }
}
