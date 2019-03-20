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
    
    let urlString="https://raw.githubusercontent.com/Lucer9/OIL_APP/vistas_carlos/jsonFiles/tareas.json"
    
    var idEquipo: String = "1"
    var datosArray:[Any]?
    var datosFiltrados = [Any]()
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

        let url = URL(string: urlString)
        let datos = try? Data(contentsOf: url!)
        datosArray = try! JSONSerialization.jsonObject(with: datos!) as? [Any]
        datosArray = datosArray!.filter {
            let tarea=$0 as! [String:Any]
            let s:String = tarea["equipo"] as! String
            let asignadoA:String = tarea["asignadoA"] as! String
            return s == idEquipo && asignadoA == "l01556728"
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
        
        let integrantesUrlString="https://raw.githubusercontent.com/Lucer9/OIL_APP/vistas_carlos/jsonFiles/integrantes.json"
        var asignadoA = [String:Any]()
        var usuariosArray:[Any]?
        
        let url = URL(string: integrantesUrlString)
        let datos = try? Data(contentsOf: url!)
        
        let idAsignadoA = cellData["asignadoA"] as? String
        usuariosArray = try! JSONSerialization.jsonObject(with: datos!) as? [Any]
        usuariosArray = usuariosArray!.filter {
            let usuario=$0 as! [String:Any]
            let s:String = usuario["id"] as! String;
            return s == idAsignadoA
        }
        
        asignadoA = usuariosArray?[0] as! [String : Any]
        
        print(asignadoA)
        
        let cellImageURLString = asignadoA["imagen"] as! String
        let cellImageURL = URL(string: cellImageURLString)
        var cellImage: UIImage
        if let imageData = try? Data(contentsOf: cellImageURL!)
        {
            cellImage = UIImage(data: imageData)!
        }else{
            cellImage = #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")
        }
        
        cell.imagen.image = cellImage
        cell.imagen.roundedImage()
        cell.cellButton.roundCorners()
        let hexColor = cellData["color"] as? String
        cell.cellButton.backgroundColor =  UIColor(hexString: hexColor!)
        cell.tituloLabel.text = cellData["titulo"] as! String

        return cell
    }
}
