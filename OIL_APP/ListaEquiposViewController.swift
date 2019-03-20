//
//  listaEquiposViewController.swift
//  OIL_APP
//
//  Created by L9 on 3/15/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

extension ListaEquiposViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class ListaEquiposViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        
        cell.mainButton.titleLabel?.text = (cellData["nombreEquipo"] as! String)
        cell.mainButton.addTarget(self, action: #selector(self.pressMainButton(_:)), for: .touchUpInside) //<- use `#selector(...)`
        cell.secondaryButton.titleLabel?.text = (cellData["nombreEquipo"] as! String)
        cell.secondaryButton.addTarget(self, action: #selector(self.pressSecButton(_:)), for: .touchUpInside) //<- use `#selector(...)`
        
        let cellNumTareasPendientes = (cellData["numTareasPendientes"] as! Int)
        let cellNumTareasPendientesText = "\(cellNumTareasPendientes) tareas"
        cell.lowerLabel.text = 	cellNumTareasPendientesText
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var equipo = [String:Any]()
        //Paso 15: crear un identificador para el controlador de vista a nivel detalle
        let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "DetalleEquipo") as! DetalleEquipoController
        
        //Verificar si la vista actual es la de búsqueda
        if (isFiltering()){
            equipo = datosFiltrados[indexPath.row] as! [String: Any]
        }else{
            equipo = datosArray![indexPath.row] as! [String: Any]
        }
        
        //siguienteVista.equipo = equipo
        self.navigationController?.pushViewController(siguienteVista, animated: true)
        
    }
    
    @objc func pressSecButton(_ sender: UIButton){ //<- needs `@objc`
        sender.backgroundColor = UIColor.lightGray
        print(sender.titleLabel!.text)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "agendarReunion") as! AgendarReunionUIViewController
        
       self.present(newViewController, animated: true, completion: nil)
        newViewController.nombreEquipo.text = sender.titleLabel!.text!
    }
    
    @objc func pressMainButton(_ sender: UIButton){ //<- needs `@objc`
        sender.backgroundColor = UIColor.lightGray
        print(sender.titleLabel!.text)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DetalleEquipo") as! DetalleEquipoController
        
        self.present(newViewController, animated: true, completion: nil)
        newViewController.nombreEquipo.text = sender.titleLabel!.text!
        
        
    }
    


}
