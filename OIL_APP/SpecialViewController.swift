//
//  ViewController.swift
//  CustomCells
//
//  Created by L9 on 3/13/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

struct cellData {
    let tipoCelda : String!
    let nombreEquipo : String!
    let numTareas : String!
    let imagenEquipo : UIImage!
}

class TableViewController: UITableViewController {
    
    var arrayOfCellData = [cellData]()
    
    override func viewDidLoad() {
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        arrayOfCellData.append(cellData(tipoCelda:"gris",nombreEquipo:"Pumas",numTareas:"0 Tareas",imagenEquipo: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")))
        
        arrayOfCellData.append(cellData(tipoCelda:"gris",nombreEquipo:"Pumas",numTareas:"0 Tareas",imagenEquipo: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")))
        
        arrayOfCellData.append(cellData(tipoCelda:"gris",nombreEquipo:"Pumas",numTareas:"0 Tareas",imagenEquipo: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")))
        
        arrayOfCellData.append(cellData(tipoCelda:"gris",nombreEquipo:"Pumas",numTareas:"0 Tareas",imagenEquipo: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")))
        /*
         arrayOfCellData = [cellData(cell: 2, text: "Miguel AKA el de la MAC", image: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")),
         cellData(cell: 2, text: "Chorlie está enojado con MAC", image: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")),
         cellData(cell: 2, text: "Yo sin MAC unu", image: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM"))]*/
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayOfCellData[indexPath.row].tipoCelda == "gris"{
            let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
            cell.mainImageView.image = arrayOfCellData[indexPath.row].imagenEquipo
            cell.mainLabel.text = arrayOfCellData[indexPath.row].nombreEquipo
            cell.lowerLabel.text = arrayOfCellData[indexPath.row].numTareas
            
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
            cell.mainImageView.image = arrayOfCellData[indexPath.row].imagenEquipo
            cell.mainLabel.text = arrayOfCellData[indexPath.row].nombreEquipo
            cell.lowerLabel.text = arrayOfCellData[indexPath.row].numTareas
            
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayOfCellData[indexPath.row].tipoCelda == "gris"{
            //Table view cell 2 row height
            return 120
        }
        else{
            return 200
        }
    }
}

