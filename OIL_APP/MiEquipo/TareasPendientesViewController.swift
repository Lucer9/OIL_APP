//
//  TareasPendientesViewController.swift
//  OIL_APP
//
//  Created by Miguel Gallardo on 3/19/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit
import FirebaseFirestore

extension TareasPendientesViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class TareasPendientesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var listaTareas: UITableView!
    
    var idEquipo: String = ""
    var id: String = ""
    var datosArray = [[String: Any]]()
    var datosFiltrados = [[String: Any]]()
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        datosFiltrados = datosArray.filter{
            let tarea=$0 as! [String:Any]
            let s:String = tarea["titulo"] as! String;
            return(s.lowercased().contains(searchController.searchBar.text!.lowercased())) }
        
        self.listaTareas.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = self.tabBarController as! MiEquipoTabBarController
        self.nombreLabel.text = controller.nombreEquipo
        self.idEquipo = controller.idEquipo
        self.id = controller.id
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let child = SpinnerViewController()
            self.addChild(child)
            child.view.frame = self.view.frame
            self.view.addSubview(child.view)
            child.didMove(toParent: self)
            
            Firestore.firestore().collection("tareas").whereField("equipo", isEqualTo: self.idEquipo).whereField("realizada", isEqualTo: false).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    self.listaTareas.separatorStyle = UITableViewCell.SeparatorStyle.none
                    self.listaTareas.delegate = self
                    self.listaTareas.dataSource = self
                    self.searchController.searchResultsUpdater = self
                    self.searchController.obscuresBackgroundDuringPresentation = false
                    self.searchController.searchBar.placeholder = "Buscar tareas"
                    self.searchController.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
                    self.searchController.searchBar.barTintColor = .white
                    self.navigationItem.searchController = self.searchController
                    self.definesPresentationContext = true
                    self.listaTareas.tableHeaderView = self.searchController.searchBar
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                    let alert = UIAlertController(title: "Ocurrió un error obteniendo las tareas", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                } else {
                    if(querySnapshot!.documents.count==0){
                        self.listaTareas.separatorStyle = UITableViewCell.SeparatorStyle.none
                        self.listaTareas.delegate = self
                        self.listaTareas.dataSource = self
                        self.searchController.searchResultsUpdater = self
                        self.searchController.obscuresBackgroundDuringPresentation = false
                        self.searchController.searchBar.placeholder = "Buscar tareas"
                        self.searchController.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
                        self.searchController.searchBar.barTintColor = .white
                        self.navigationItem.searchController = self.searchController
                        self.definesPresentationContext = true
                        self.listaTareas.tableHeaderView = self.searchController.searchBar
                        child.willMove(toParent: nil)
                        child.view.removeFromSuperview()
                        child.removeFromParent()
                        return
                    }
                    for document in querySnapshot!.documents {
                        let tarea = document.data()
                        let idTarea = document.documentID
                        let idAsignadoA:String = tarea["asignadoA"]! as! String
                        
                        if(idAsignadoA != self.id){
                            Firestore.firestore().collection("users").whereField("id", isEqualTo: idAsignadoA).getDocuments() { (querySnapshot, err) in
                                
                                if let err = err{
                                    self.listaTareas.separatorStyle = UITableViewCell.SeparatorStyle.none
                                    self.listaTareas.delegate = self
                                    self.listaTareas.dataSource = self
                                    self.searchController.searchResultsUpdater = self
                                    self.searchController.obscuresBackgroundDuringPresentation = false
                                    self.searchController.searchBar.placeholder = "Buscar tareas"
                                    self.searchController.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
                                    self.searchController.searchBar.barTintColor = .white
                                    self.navigationItem.searchController = self.searchController
                                    self.definesPresentationContext = true
                                    self.listaTareas.tableHeaderView = self.searchController.searchBar
                                    child.willMove(toParent: nil)
                                    child.view.removeFromSuperview()
                                    child.removeFromParent()
                                    let alert = UIAlertController(title: "Ocurrió un error obteniendo las tareas", message: err.localizedDescription, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "De acuerdo", style: .default, handler: nil))
                                    self.present(alert, animated: true)
                                    return
                                }else{
                                    for document in querySnapshot!.documents{
                                        let asignadoA = document.data()
                                        let timestamp = tarea["fecha"] as! Timestamp
                                        let date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
                                        
                                        let tareaAInsertar = [
                                            "id": idTarea,
                                            "color": tarea["color"]! as! String,
                                            "descripcion": tarea["descripcion"]! as! String,
                                            "equipo": tarea["equipo"]! as! String,
                                            "fecha": date as! Date,
                                            "reunion": false,
                                            "realizada": tarea["realizada"]! as! Bool,
                                            "titulo": tarea["titulo"]! as! String,
                                            "asignadoA": asignadoA
                                            ] as [String : Any]
                                        
                                        self.datosArray.append(tareaAInsertar as [String : Any])
                                    }
                                    self.listaTareas.reloadData()
                                    self.listaTareas.separatorStyle = UITableViewCell.SeparatorStyle.none
                                    self.listaTareas.delegate = self
                                    self.listaTareas.dataSource = self
                                    self.searchController.searchResultsUpdater = self
                                    self.searchController.obscuresBackgroundDuringPresentation = false
                                    self.searchController.searchBar.placeholder = "Buscar tareas"
                                    self.searchController.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
                                    self.searchController.searchBar.barTintColor = .white
                                    self.navigationItem.searchController = self.searchController
                                    self.definesPresentationContext = true
                                    self.listaTareas.tableHeaderView = self.searchController.searchBar
                                    child.willMove(toParent: nil)
                                    child.view.removeFromSuperview()
                                    child.removeFromParent()
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            return datosFiltrados.count
        }
        return datosArray.count
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
        let cellIdentifier = "tareaCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TareaCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        var cellData: [String: Any]
        
        if isFiltering() {
            cellData = datosFiltrados[indexPath.section] as! [String: Any]
        } else {
            cellData = datosArray[indexPath.section] as! [String: Any]
        }
        
        var titulo = cellData["titulo"] as? String
        if(cellData["reunion"] as? Bool ?? false){
            //Aqui falta hacer que se carge la imagen del equipo
            cell.imagen.setImageFromURL(imageURLString: "https://via.placeholder.com/70")
            titulo = "Reunion"
        }else{
            let asignadoA = cellData["asignadoA"] as! [String: Any]
            cell.imagen.setImageFromURL(imageURLString: asignadoA["imagen"] as! String)
        }
        cell.imagen.roundedImage()
        cell.cellButton.roundCorners()
        let hexColor = cellData["color"] as? String
        cell.cellButton.backgroundColor =  UIColor(hexString: "\(hexColor!)1A")
        cell.cellButton.layer.borderWidth = 1
        cell.cellButton.layer.borderColor = UIColor(hexString: "\(hexColor!)FF")?.cgColor
        cell.tituloLabel.text = titulo
        cell.tiempoLabel.text = Helper.timeAgoStringFromDate(date: cellData["fecha"] as! Date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cellData: [String: Any]
        if isFiltering() {
            cellData = datosFiltrados[indexPath.section] as! [String: Any]
        } else {
            cellData = datosArray[indexPath.section] as! [String: Any]
        }
        
        if(cellData["reunion"] as? Bool ?? false){
            self.performSegue(withIdentifier: "DetalleReunion", sender: indexPath)
        }else{
            self.performSegue(withIdentifier: "DetalleTarea", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="DetalleTarea"){
            let controller = segue.destination as! DetalleTareaViewController
            let section = (sender as! NSIndexPath).section;
            var cellData: [String: Any]
            if isFiltering() {
                cellData = datosFiltrados[section] as! [String: Any]
            } else {
                cellData = datosArray[section] as! [String: Any]
            }
            controller.tarea = cellData
            //controller.tiempo.text = timeAgoStringFromDate(date: cellData["fecha"] as? Date ?? Date())
        }
        
        if(segue.identifier=="DetalleReunion"){
            let controller = segue.destination as! DetalleReunionViewController
            let section = (sender as! NSIndexPath).section;
            var cellData: [String: Any]
            if isFiltering() {
                cellData = datosFiltrados[section] as! [String: Any]
            }
        }
        
        if(segue.identifier=="nuevaTarea") {
            let controller = segue.destination as! NuevaTareaViewController
            controller.equipo = nombreLabel.text!
            controller.idEquipo = self.idEquipo
        }
        
    }
    
    @IBAction func nuevaTareaBoton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "nuevaTarea", sender: self)
    }
}
