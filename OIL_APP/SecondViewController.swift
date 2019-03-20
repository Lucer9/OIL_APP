//
//  SecondViewController.swift
//  OIL_APP
//
//  Created by L9 on 2/25/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit
class ViewController: UITableViewController {
    
    let cellId = "cellId"
    var equipos : [Equipo] = [Equipo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        createEquipoArray()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let currentLastItem = equipos[indexPath.row]
        cell.textLabel?.text = currentLastItem.nombreEquipo
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return equipos.count
    }
    func createEquipoArray() {
        //#imageLiteral(resourceName: "glasses") para imagen
        equipos.append(Equipo(imagen: #imageLiteral(resourceName: "Image"), nombreEquipo: "Moik" , numTareasPendientes : 5, liderId : "E0001"))
        equipos.append(Equipo(imagen: #imageLiteral(resourceName: "first"), nombreEquipo: "loko" , numTareasPendientes : 7, liderId : "E0002"))
        equipos.append(Equipo(imagen: #imageLiteral(resourceName: "Logo"), nombreEquipo: "chorlo" , numTareasPendientes : 3, liderId : "E0003"))
    }
}

