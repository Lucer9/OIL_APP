//
//  AcercaDeViewController.swift
//  OIL_APP
//
//  Created by L9 on 3/20/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

class AcercaDeViewController: UIViewController {
    @IBOutlet var carlos: UIImageView!
    @IBOutlet var loko: UIImageView!
    
    @IBOutlet var Mike: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carlos.roundedImage()
        Mike.roundedImage()
        loko.roundedImage()

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
