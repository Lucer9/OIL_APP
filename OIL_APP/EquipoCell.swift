//
//  EquipoCell.swift
//  OIL_APP
//
//  Created by Miguel Gallardo on 3/19/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

protocol EquipoCellDelegate {
    func didTapAgendarReunion(idEquipo: String, nombreEquipo: String)
}

class EquipoCell: UITableViewCell{
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var tareasLabel: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    
    var nombreEquipo:String!
    var idEquipo:String!
    
    var delegate: EquipoCellDelegate!
    
    @IBAction func agendarReunion(_ sender: Any) {
        delegate?.didTapAgendarReunion(idEquipo: idEquipo, nombreEquipo: nombreEquipo)
    }
}
