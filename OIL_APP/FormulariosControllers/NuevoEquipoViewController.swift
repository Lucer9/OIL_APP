//
//  NuevoEquipoViewController.swift
//  OIL_APP
//
//  Created by Miguel on 5/1/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class NuevoEquipoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let usuario = usuarios[indexPath.row] as! [String:Any]
        
        let cellIdentifier = "NuevoEquipoIntegranteCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NuevoEquipoIntegranteTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        cell.nombreLabel.text = usuario["nombre"] as! String
        cell.integranteImageView.setImageFromURL(imageURLString: usuario["imagen"] as! String)
        cell.integranteImageView.roundedImage()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usuarios.count
    }

    var integrantesSeleccionados = [String]()
    var usuarios = [[String:Any]]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nombreField: UITextField!
    
    var imagePicker = UIImagePickerController()
    var hasSelectedImage = false
    
    @IBAction func SeleccionarImagen(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        hasSelectedImage = true
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = chosenImage
        imageView.roundedImage()
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v: UIView = UIView()
        v.backgroundColor = UIColor .clear
        return v;
    }
    
    
    @IBAction func CrearEquipo(_ sender: Any) {
        let nombre = self.nombreField.text
        let integrantes = self.integrantesSeleccionados
        
        if(nombre==""){
            let alert = UIAlertController(title: "Por favor ingresa un nombre al equipo", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if(!hasSelectedImage){
            let alert = UIAlertController(title: "Por favor selecciona una imagen para el equipo \(nombre!)", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if(integrantes.count==1){
            let alert = UIAlertController(title: "Por favor selecciona al menos un integrante para el equipo \(nombre!)", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            let child = SpinnerViewController()
            self.addChild(child)
            child.view.frame = self.view.frame
            self.view.addSubview(child.view)
            child.didMove(toParent: self)
            
            let nombre = self.nombreField.text
            let integrantes = self.integrantesSeleccionados
            
            var imageURL:String = ""
            
            let timestamp = NSDate().timeIntervalSince1970
            let storageRef = Storage.storage().reference().child("images/\(timestamp).jpeg")
            
            var data = Data()
            data = (self.imageView.image?.jpegData(compressionQuality: 0.8))!
            
            storageRef.putData(data, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error)
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error)
                    }
                    
                    imageURL = (url?.absoluteString)!
                    
                    
                    let db = Firestore.firestore()
                    var ref: DocumentReference? = nil
                    ref = db.collection("equipos").addDocument(data: [
                        "nombre": nombre,
                        "integrantes": integrantes,
                        "imagen": imageURL
                    ]) { err in
                        if let err = err {
                            child.willMove(toParent: nil)
                            child.view.removeFromSuperview()
                            child.removeFromParent()
                            let alert = UIAlertController(title: "Ocurrió un error creando al equipo \(nombre!)", message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        } else {
                            child.willMove(toParent: nil)
                            child.view.removeFromSuperview()
                            child.removeFromParent()
                            
                            let alert = UIAlertController(title: "Se creó al equipo \(nombre!) con éxito", message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Gracias", style: .default, handler: self.showMisEquipos))
                            self.present(alert, animated: true)
                        }
                    }
                })
            }
            
            
        }
    }
    
    func showMisEquipos(action:UIAlertAction){
        let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "MisEquipos") as! MisEquiposViewController
        present(siguienteVista, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let child = SpinnerViewController()
            self.addChild(child)
            child.view.frame = self.view.frame
            self.view.addSubview(child.view)
            child.didMove(toParent: self)
            
            let uid = Auth.auth().currentUser?.uid
            Firestore.firestore().collection("users").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if(document.documentID != uid){
                            self.usuarios.append(document.data())
                        }else{
                            self.integrantesSeleccionados.append(document.data()["id"] as! String)
                        }
                        self.tableView.reloadData()
                        child.willMove(toParent: nil)
                        child.view.removeFromSuperview()
                        child.removeFromParent()
                    }
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let usuario = usuarios[indexPath.row] as! [String:Any]
        let id = usuario["id"] as! String
        let cell = tableView.cellForRow(at: indexPath) as! NuevoEquipoIntegranteTableViewCell
        
        cell.selectButton.isHidden = !cell.selectButton.isHidden
        cell.unselectButton.isHidden = !cell.unselectButton.isHidden
        
        if(cell.unselectButton.isHidden){
            integrantesSeleccionados = integrantesSeleccionados.filter({ (integranteID) -> Bool in
                return integranteID != id
            })
        }else{
            integrantesSeleccionados.append(id)
        }
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
