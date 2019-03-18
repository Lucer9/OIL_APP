//
//  listaEquiposViewController.swift
//  OIL_APP
//
//  Created by L9 on 3/15/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

class ListaEquiposViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet var listaEquipos: UITableView!
    var arrayOfCellData = [cellData]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayOfCellData[indexPath.row].tipoCelda == "gris"{
            
            
            let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
            cell.mainImageView.image = arrayOfCellData[indexPath.row].imagenEquipo
            cell.mainImageView.layer.cornerRadius = cell.mainImageView.frame.size.width/2
            cell.mainImageView.clipsToBounds = true
            cell.mainLabel.text = arrayOfCellData[indexPath.row].nombreEquipo
            cell.lowerLabel.text = arrayOfCellData[indexPath.row].numTareas
            cell.mainButton.titleLabel?.text=cell.mainLabel.text
            cell.mainButton.addTarget(self, action: #selector(self.pressButton(_:)), for: .touchUpInside) //<- use `#selector(...)`

            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
            cell.mainImageView.image = arrayOfCellData[indexPath.row].imagenEquipo
            cell.mainLabel.text = arrayOfCellData[indexPath.row].nombreEquipo
            cell.lowerLabel.text = arrayOfCellData[indexPath.row].numTareas
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayOfCellData[indexPath.row].tipoCelda == "gris"{
            //Table view cell 2 row height
            return 90
        }
        else{
            return 200
        }
    }
    
    override func viewDidLoad() {
        listaEquipos.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let url = URL(string:"https://cdn.pixabay.com/photo/2017/05/09/21/49/gecko-2299365__480.jpg")
        
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data)!
            arrayOfCellData.append(cellData(tipoCelda:"gris",nombreEquipo:"Pumas",numTareas:"0 Tareas",imagenEquipo: image))
        }
        
        arrayOfCellData.append(cellData(tipoCelda:"gris",nombreEquipo:"Pumas",numTareas:"0 Tareas",imagenEquipo: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")))
        
        arrayOfCellData.append(cellData(tipoCelda:"gris",nombreEquipo:"Pumas",numTareas:"0 Tareas",imagenEquipo: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")))
        
        arrayOfCellData.append(cellData(tipoCelda:"gris",nombreEquipo:"Pumas",numTareas:"0 Tareas",imagenEquipo: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")))
        
        arrayOfCellData.append(cellData(tipoCelda:"gris",nombreEquipo:"Pumas",numTareas:"0 Tareas",imagenEquipo: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")))
        
           arrayOfCellData.append(cellData(tipoCelda:"gris",nombreEquipo:"Pumas",numTareas:"0 Tareas",imagenEquipo: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")))
        /*
         arrayOfCellData = [cellData(cell: 2, text: "Miguel AKA el de la MAC", image: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")),
         cellData(cell: 2, text: "Chorlie está enojado con MAC", image: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM")),
         cellData(cell: 2, text: "Yo sin MAC unu", image: #imageLiteral(resourceName: "Screen Shot 2019-03-13 at 12.37.03 PM"))]*/
    }
    
    @objc func pressButton(_ sender: UIButton){ //<- needs `@objc`
        sender.backgroundColor = UIColor.lightGray
        print(sender.titleLabel!.text)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "agendarReunion") as! AgendarReunionUIViewController
        
       self.present(newViewController, animated: true, completion: nil)
        newViewController.nombreEquipo.text = sender.titleLabel!.text!

        
    }
    


}
