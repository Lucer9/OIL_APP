//
//  MisTareasViewController.swift
//  OIL_APP
//
//  Created by Miguel Gallardo on 3/19/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

extension MisTareasViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class MisTareasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var listaTareas: UITableView!
    
    let urlString="https://raw.githubusercontent.com/Lucer9/OIL_APP/ImplementarNavController/jsonFiles/tareas.json"
    
    var idEquipo: String = "1"
    var datosArray:[Any]?
    var datosFiltrados = [Any]()
    var usuariosArray:[Any]?
    var usuariosFiltrados = [Any]()
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        datosFiltrados = datosArray!.filter{
            let tarea=$0 as! [String:Any]
            let s:String = tarea["titulo"] as! String;
            return(s.lowercased().contains(searchController.searchBar.text!.lowercased())) }
        
        self.listaTareas.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = tabBarController as! MiEquipoTabBarController
        nombreLabel.text = controller.nombreEquipo
        
        listaTareas.separatorStyle = UITableViewCell.SeparatorStyle.none
        listaTareas.delegate = self
        listaTareas.dataSource = self
        
        idEquipo = controller.idEquipo
        
        var url = URL(string: urlString)
        var datos = try? Data(contentsOf: url!)
        datosArray = try! JSONSerialization.jsonObject(with: datos!) as? [Any]
        datosArray = datosArray!.filter {
            let tarea=$0 as! [String:Any]
            let s:String = tarea["equipo"] as! String
            
            if(tarea["reunion"] as? Bool ?? false){
                return s == idEquipo
            }
            
            let asignadoA:String = tarea["asignadoA"] as! String
            return s == idEquipo && asignadoA == "l01556728"
        }
        
        let integrantesUrlString="https://raw.githubusercontent.com/Lucer9/OIL_APP/vistas_carlos/jsonFiles/integrantes.json"
        url = URL(string: integrantesUrlString)
        datos = try? Data(contentsOf: url!)
        usuariosArray = try! JSONSerialization.jsonObject(with: datos!) as? [Any]
        
        datosArray = datosArray!.map{
            
            var dato = $0 as! [String:Any]
            
            if(dato["reunion"] as? Bool ?? false){
                return dato;
            }
            let idAsignadoA = dato["asignadoA"] as? String
            
            usuariosFiltrados = usuariosArray!.filter {
                let usuario=$0 as! [String:Any]
                let s:String = usuario["id"] as! String;
                return s == idAsignadoA
            }
            
            let asignadoA = usuariosFiltrados[0] as! [String : Any]
            dato["asignadoA"] = asignadoA
            
            return dato
        }
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar tareas"
        self.searchController.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
        self.searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        listaTareas.tableHeaderView = searchController.searchBar
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            return datosFiltrados.count
        }
        return (datosArray?.count)!
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
            cellData = datosArray?[indexPath.section] as! [String: Any]
        }
        
        if(cellData["reunion"] as? Bool ?? false){
            //Aqui falta hacer que se carge la imagen del equipo
            cell.imagen.setImageFromURL(imageURLString: "https://via.placeholder.com/70")
        }else{
            let asignadoA = cellData["asignadoA"] as! [String: Any]
            cell.imagen.setImageFromURL(imageURLString: asignadoA["imagen"] as! String)
        }
        cell.imagen.roundedImage()
        cell.cellButton.roundCorners()
        let hexColor = cellData["color"] as? String
        cell.cellButton.backgroundColor =  UIColor(hexString: hexColor!)
        cell.tituloLabel.text = cellData["titulo"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cellData: [String: Any]
        if isFiltering() {
            cellData = datosFiltrados[indexPath.section] as! [String: Any]
        } else {
            cellData = datosArray?[indexPath.section] as! [String: Any]
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
                cellData = datosArray?[section] as! [String: Any]
            }
            
            controller.tarea = cellData
        }else if(segue.identifier=="DetalleReunion"){
            let controller = segue.destination as! DetalleReunionViewController
            let section = (sender as! NSIndexPath).section;
            var cellData: [String: Any]
            if isFiltering() {
                cellData = datosFiltrados[section] as! [String: Any]
            } else {
                cellData = datosArray?[section] as! [String: Any]
            }
            
            controller.reunion = cellData
        }
    }
}
