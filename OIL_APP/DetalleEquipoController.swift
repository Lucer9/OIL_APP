//
//  DetalleEquipoController.swift
//  OIL_APP
//
//  Created by Miguel on 3/17/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

class DetalleEquipoController: UIViewController {
    var equipo = [String:Any]()
    @IBOutlet weak var nombreEquipo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nombreEquipo.text = equipo["nombreEquipo"] as? String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
