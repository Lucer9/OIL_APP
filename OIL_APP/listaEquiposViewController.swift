//
//  listaEquiposViewController.swift
//  OIL_APP
//
//  Created by L9 on 3/15/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

extension listaEquiposViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class listaEquiposViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var listaEquipos: UITableView!
    
    let urlString="https://raw.githubusercontent.com/Lucer9/OIL_APP/master/jsonFiles/equipos.json"
    
    var datosArray:[Any]?
    var datosFiltrados = [Any]()
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let url = URL(string: urlString)
        let datos = try? Data(contentsOf: url!)
        datosArray = try! JSONSerialization.jsonObject(with: datos!) as? [Any]
        
        listaEquipos.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar equipos"
        self.searchController.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
        self.searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        listaEquipos.tableHeaderView = searchController.searchBar
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        datosFiltrados = datosArray!.filter{
            let equipo=$0 as! [String:Any]
            let s:String = equipo["nombreEquipo"] as! String;
            return(s.lowercased().contains(searchController.searchBar.text!.lowercased())) }
        
        listaEquipos.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return datosFiltrados.count
        }
        return (datosArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
        
        let cellData: [String: Any]
        
        if isFiltering() {
            cellData = datosFiltrados[indexPath.row] as! [String: Any]
        } else {
            cellData = datosArray?[indexPath.row] as! [String: Any]
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
        
        cell.mainImageView.image = cellImage
        cell.mainImageView.layer.cornerRadius = cell.mainImageView.frame.size.width/2
        cell.mainImageView.clipsToBounds = true
        cell.mainLabel.text = (cellData["nombreEquipo"] as! String)
        
        let cellNumTareasPendientes = (cellData["numTareasPendientes"] as! Int)
        let cellNumTareasPendientesText = "\(cellNumTareasPendientes) tareas"
        cell.lowerLabel.text = 	cellNumTareasPendientesText
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
