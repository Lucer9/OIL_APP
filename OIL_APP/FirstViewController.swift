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
        
        tableView.register(EquipoCell.self, forCellReuseIdentifier: cellId)
        createEquipoArray()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EquipoCell
        let currentLastItem = equipos[indexPath.row]
        //cell.textLabel?.text = currentLastItem.nombreEquipo
        cell.equipos = currentLastItem

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return equipos.count
    }
    func createEquipoArray() {
        //#imageLiteral(resourceName: "glasses") para imagen
        //self.img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: self.imagen!]]];
        
        equipos.append(Equipo(imagen: #imageLiteral(resourceName: "Logo"), nombreEquipo: "Moik" , numTareasPendientes : 5, liderId : "E0001"))
        equipos.append(Equipo(imagen: #imageLiteral(resourceName: "first"), nombreEquipo: "loko" , numTareasPendientes : 7, liderId : "E0002"))
        equipos.append(Equipo(imagen: #imageLiteral(resourceName: "Logo"), nombreEquipo: "chorlo" , numTareasPendientes : 3, liderId : "E0003"))
    }
}

