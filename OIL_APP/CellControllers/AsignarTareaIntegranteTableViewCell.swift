//
//  AsignarTareaIntegranteTableViewCell.swift
//  OIL_APP
//
//  Created by Miguel on 02/05/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

class AsignarTareaIntegranteTableViewCell: UITableViewCell {

    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var integranteImageView: UIImageView!
    @IBOutlet weak var unselectButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var backgroundButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectButton.roundCorners()
        unselectButton.roundCorners()
        backgroundButton.roundCorners()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
