//
//  AgendarReunionUIViewController.swift
//  OIL_APP
//
//  Created by L9 on 3/17/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit
class AgendarReunionViewController: UIViewController {
    
    @IBOutlet var nombreEquipoLabel: UILabel!
    
    var nombreEquipo:String!
    var idEquipo:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nombreEquipoLabel.text = nombreEquipo
    }

}
