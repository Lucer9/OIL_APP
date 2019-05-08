//
//  MisEquiposTableViewController.swift
//  OIL_APP
//
//  Created by Miguel Gallardo on 3/19/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

extension MisEquiposViewController: EquipoCellDelegate{
    func didTapAgendarReunion(idEquipo: String, nombreEquipo: String) {
        let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "agendarReunion") as! AgendarReunionViewController
        
        siguienteVista.idEquipo = idEquipo
        siguienteVista.nombreEquipo = nombreEquipo
        
        present(siguienteVista, animated: true, completion: nil)
    }
}

extension MisEquiposViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class MisEquiposViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBAction func CerrarSesion(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    var id:String = ""
    var datosArray = [[String:Any]]()
    var datosFiltrados = [[String:Any]]()
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        datosFiltrados = datosArray.filter{
            let equipo=$0 as! [String:Any]
            let s:String = equipo["nombreEquipo"] as! String;
            return(s.lowercased().contains(searchController.searchBar.text!.lowercased())) }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            let child = SpinnerViewController()
            self.addChild(child)
            child.view.frame = self.view.frame
            self.view.addSubview(child.view)
            child.didMove(toParent: self)
            
            
            let uid = Auth.auth().currentUser!.uid
            let userRef = Firestore.firestore().collection("users").document(uid)
            
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.id = document.data()!["id"] as! String
                    
                    Firestore.firestore().collection("equipos").whereField("integrantes", arrayContains: self.id).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                let equipo = document.data()
                                let equipoAInsertar = [
                                    "idEquipo": document.documentID,
                                    "nombreEquipo": equipo["nombre"],
                                    "imagen": equipo["imagen"],
                                    "integrantes": equipo["integrantes"],
                                    "numTareasPendientes": 2
                                ]
                                
                                self.datosArray.append(equipoAInsertar as [String : Any])
                            }
                            
                            self.tableView.reloadData()
                            child.willMove(toParent: nil)
                            child.view.removeFromSuperview()
                            child.removeFromParent()
                        }
                    }
                }else{
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                }
            }
            
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            
            self.searchController.searchResultsUpdater = self
            self.searchController.obscuresBackgroundDuringPresentation = false
            self.searchController.searchBar.placeholder = "Buscar equipos"
            self.searchController.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
            self.searchController.searchBar.barTintColor = .white
            self.navigationItem.searchController = self.searchController
            self.definesPresentationContext = true
            self.tableView.tableHeaderView = self.searchController.searchBar
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            return datosFiltrados.count
        }
        return (datosArray.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v: UIView = UIView()
        v.backgroundColor = UIColor .clear
        return v;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "equipoCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EquipoCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        var cellData: [String: Any]
        
        if isFiltering() {
            cellData = datosFiltrados[indexPath.section] as! [String: Any]
        } else {
            cellData = datosArray[indexPath.section] as! [String: Any]
        }
        
        let cellImageURLString = cellData["imagen"] as! String
        let cellImageURL = URL(string: cellImageURLString)
        var cellImage: UIImage
        if let imageData = try? Data(contentsOf: cellImageURL!)
        {
            cellImage = UIImage(data: imageData)!
        }else{
            cellImage = #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")
        }
        
        cell.idEquipo = cellData["idEquipo"] as? String
        cell.nombreEquipo = cellData["nombreEquipo"] as? String
        
        cell.imagen.image = cellImage
        cell.imagen.roundedImage()
        cell.button.roundCorners()
        
        cell.nombreLabel.text = cellData["nombreEquipo"] as? String
        
        //Pendiente
        /*
        let cellNumTareasPendientes = (cellData["numTareasPendientes"] as! Int)
        let cellNumTareasPendientesText = "\(cellNumTareasPendientes) tareas pendientes"
        cell.tareasLabel.text = cellNumTareasPendientesText
        */
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var equipo = [String:Any]()
        
        //Verificar si la vista actual es la de búsqueda
        if (isFiltering()){
            equipo = datosFiltrados[indexPath.section] as! [String: Any]
        }else{
            equipo = datosArray[indexPath.section] as! [String: Any]
        }
        
        let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "miEquipo") as! MiEquipoTabBarController
        
        siguienteVista.idEquipo = equipo["idEquipo"] as! String
        siguienteVista.nombreEquipo = equipo["nombreEquipo"] as! String
        siguienteVista.id = self.id
        
        self.present(siguienteVista, animated: true, completion: nil)
        
    }
}
