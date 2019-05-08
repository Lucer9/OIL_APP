//
//  AsignarTareaIntegrantesTableViewController.swift
//  OIL_APP
//
//  Created by Miguel on 02/05/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit
import FirebaseFirestore

protocol AsignarTareaIntegrantesTableViewControllerDelegate : NSObjectProtocol{
    func getSelectedUser(imageURL: String, id: String)
}

class AsignarTareaIntegrantesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate : AsignarTareaIntegrantesTableViewControllerDelegate?
    var integranteSeleccionado:String = ""
    var usuarios = [[String:Any]]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let usuario = usuarios[indexPath.row] as! [String:Any]
        
        let cellIdentifier = "AsignarTareaIntegranteCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AsignarTareaIntegranteTableViewCell  else {
            fatalError("The dequeued cell is not an instance of AsignarTareaIntegranteTableViewCell.")
        }
        
        cell.nombreLabel.text = usuario["nombre"] as! String
        cell.integranteImageView.setImageFromURL(imageURLString: usuario["imagen"] as! String)
        cell.integranteImageView.roundedImage()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuario = usuarios[indexPath.row] as! [String:Any]
        let id = usuario["id"] as! String
        let imageURL = usuario["imagen"] as! String
        let cell = tableView.cellForRow(at: indexPath) as! AsignarTareaIntegranteTableViewCell
        
        cell.selectButton.isHidden = !cell.selectButton.isHidden
        cell.unselectButton.isHidden = !cell.unselectButton.isHidden
        
        if let delegate = delegate{
            delegate.getSelectedUser(imageURL: imageURL, id: id)
            _ = navigationController?.popViewController(animated: true)
        }
        
    }
    

    
    @IBOutlet weak var tableView: UITableView!
    
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
            
            Firestore.firestore().collection("users").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.usuarios.append(document.data())
                    }
                    self.tableView.reloadData()
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                }
            }
            
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destination = segue.destination as! NuevaTareaViewController
    }
    

}
