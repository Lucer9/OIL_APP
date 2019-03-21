//
//  MisEquiposTableViewController.swift
//  OIL_APP
//
//  Created by Miguel Gallardo on 3/19/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

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
    
    let urlString="https://raw.githubusercontent.com/Lucer9/OIL_APP/master/jsonFiles/equipos.json"
    
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
            let equipo=$0 as! [String:Any]
            let s:String = equipo["nombreEquipo"] as! String;
            return(s.lowercased().contains(searchController.searchBar.text!.lowercased())) }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let url = URL(string: urlString)
        let datos = try? Data(contentsOf: url!)
        datosArray = try! JSONSerialization.jsonObject(with: datos!) as? [Any]
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar equipos"
        self.searchController.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
        self.searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
    }

    // MARK: - Table view data source

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
        let cellIdentifier = "equipoCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EquipoCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }

        var cellData: [String: Any]
        
        if isFiltering() {
            cellData = datosFiltrados[indexPath.section] as! [String: Any]
        } else {
            cellData = datosArray?[indexPath.section] as! [String: Any]
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
        let cellNumTareasPendientes = (cellData["numTareasPendientes"] as! Int)
        let cellNumTareasPendientesText = "\(cellNumTareasPendientes) tareas pendientes"
        cell.tareasLabel.text =     cellNumTareasPendientesText
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var equipo = [String:Any]()
        
        //Verificar si la vista actual es la de búsqueda
        if (isFiltering()){
            equipo = datosFiltrados[indexPath.section] as! [String: Any]
        }else{
            equipo = datosArray![indexPath.section] as! [String: Any]
        }
        
        let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "miEquipo") as! MiEquipoTabBarController
        
        siguienteVista.idEquipo = equipo["idEquipo"] as! String
        siguienteVista.nombreEquipo = equipo["nombreEquipo"] as! String
        
        self.present(siguienteVista, animated: true, completion: nil)
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
 

}
