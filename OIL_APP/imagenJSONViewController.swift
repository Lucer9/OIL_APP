//
//  imagenJSONViewController.swift
//  OIL_APP
//
//  Created by Fernanda León on 4/11/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

class imagenJSONViewController: UIViewController {

    @IBOutlet weak var imagen: UIImageView!
    var urlImagen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagen.setImageFromURL(imageURLString: urlImagen)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
