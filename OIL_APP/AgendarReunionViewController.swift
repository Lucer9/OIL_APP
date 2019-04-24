//
//  AgendarReunionUIViewController.swift
//  OIL_APP
//
//  Created by L9 on 3/17/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit
import EventKit

extension AgendarReunionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class AgendarReunionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var nombreEquipoLabel: UILabel!
    @IBOutlet weak var fechaEvento: UIDatePicker!
    @IBOutlet weak var horaFinalEvento: UIDatePicker!
    
    @IBOutlet weak var tableView: UITableView!
    var nombreEquipo:String!
    var idEquipo:String!
    
    let urlString="https://raw.githubusercontent.com/Lucer9/OIL_APP/master/jsonFiles/salones.json"
    var datosArray:[Any]?
    var datosFiltrados = [Any]()
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    var salonSeleccionado = [String:Any]()
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        datosFiltrados = datosArray!.filter{
            let salon=$0 as! [String:Any]
            let s:String = salon["nombre"] as? String ?? ""
            let n:String = salon["salon"] as? String ?? ""
            
            return s.lowercased().contains(searchController.searchBar.text!.lowercased()) || n.lowercased().contains(searchController.searchBar.text!.lowercased())
            
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            super.viewDidLoad()
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.nombreEquipoLabel.text = self.nombreEquipo
            
            let url = URL(string: self.urlString)
            let datos = try? Data(contentsOf: url!)
            self.datosArray = try! JSONSerialization.jsonObject(with: datos!) as? [Any]
            
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            
            self.searchController.searchResultsUpdater = self
            self.searchController.obscuresBackgroundDuringPresentation = false
            self.searchController.searchBar.placeholder = "Buscar salones"
            self.searchController.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
            self.searchController.searchBar.barTintColor = .white
            self.navigationItem.searchController = self.searchController
            self.definesPresentationContext = true
            self.tableView.tableHeaderView = self.searchController.searchBar
            
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return datosFiltrados.count
        }
        return (datosArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "salonSearchCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SalonSearchCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        var cellData: [String: Any]
        
        if isFiltering() {
            cellData = datosFiltrados[indexPath.row] as! [String: Any]
        } else {
            cellData = datosArray?[indexPath.row] as! [String: Any]
        }
        
        let cellNombre = cellData["nombre"] as? String ?? nil
        
        if(cellNombre != nil && cellNombre != ""){
            cell.name.text = cellNombre
        }else{
            let cellSalon = cellData["salon"] as? String ?? "Sin nombre"
            cell.name.text = cellSalon
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            salonSeleccionado = datosFiltrados[indexPath.row] as! [String: Any]
        } else {
            salonSeleccionado = datosArray?[indexPath.row] as! [String: Any]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="DetalleARSalon"){
            let navigationController = segue.destination as! ARNavigationViewController
            
            let viewController = navigationController.viewControllers.first as! ARViewController
            
            viewController.salon = salonSeleccionado
        }
    }
    
    @IBAction func createEvent(_ sender: UIBarButtonItem) {
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event){
        case .authorized:
            insertEvent(store: eventStore)
        case .denied:
            print("Acceso denegado")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion: {[weak self] (granted: Bool, error: Error?) -> Void in
                if granted{
                    self!.insertEvent(store: eventStore)
                }else{
                    print("Acceso denegado")
                }
            })
        default:
            print("uwu")
        }
    }
    
    @IBAction func cerrarView(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    func insertEvent(store: EKEventStore){
        let event = EKEvent(eventStore: store)
        
        event.title = "Junta " + self.nombreEquipo
        event.startDate = fechaEvento.date
        event.endDate = event.startDate + horaFinalEvento.countDownDuration
        event.calendar = store.defaultCalendarForNewEvents
        
        do{
            try store.save(event, span: .thisEvent)
        }catch let error as NSError{
            print("Error al guardar el evento: \(String(describing: error))")
        }
        print("Se guardó el evento con éxito")
        let alerta = UIAlertController(title: "Evento creado", message: "El evento ha sido creado con éxito", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }
    
}
