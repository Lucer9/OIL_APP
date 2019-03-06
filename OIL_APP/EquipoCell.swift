//
//  EquipoCell.swift
//  OIL_APP
//
//  Created by L9 on 3/6/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit
class EquipoCell : UITableViewCell {
    
    var equipos : Equipo! {
        didSet {
            equiposImage.image = equipos!.imagen
            nombreEquipoLabel.text = equipos!.nombreEquipo
            numTareasPendientesLabel.text = String(equipos!.numTareasPendientes)
        }
    }
    
    
    private let nombreEquipoLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let numTareasPendientesLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    /*
    private let increaseButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: “addTb”), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }()
    */

    private let equiposImage : UIImageView = {
        let imgView = UIImageView(image:#imageLiteral(resourceName: "first"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(equiposImage)
        addSubview(nombreEquipoLabel)
        addSubview(numTareasPendientesLabel)
        
        equiposImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        nombreEquipoLabel.anchor(top: topAnchor, left: equiposImage.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        numTareasPendientesLabel.anchor(top: nombreEquipoLabel.bottomAnchor, left: equiposImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        
    /*
        let stackView = UIStackView(arrangedSubviews: [decreaseButton,equiposQuantity,increaseButton])
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 5
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: nombreEquipoLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 15, paddingRight: 10, width: 0, height: 70, enableInsets: false)
        
    */
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
