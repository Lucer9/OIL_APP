//
//  ListaEquipoTableViewController.swift
//  OIL_APP
//
//  Created by L9 on 3/18/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit

class ListaMaterialTableViewController: UITableViewController {
    
    var datosArray:[Any]?
    var salonSeleccionado: [String:Any]!
    var myIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 14
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Número del salón"
        case 1: return "Nombre del salón"
        case 2: return "Horario"
        case 3: return "Equipamiento"
        case 4: return "Contacto"
        case 5: return "Descripción"
        case 6: return "Fotografía"
        case 7: return "Fotografía AR"
        case 8: return "Panorámica"
        case 9: return "Video"
        case 10: return "Video AR"
        case 11: return "Video 360"
        case 12: return "Objeto 3D"
        case 13: return "Marcador 3D"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numMateriales = (salonSeleccionado["equipamiento"] as? [String])?.count ?? 0
        let numFotos = (salonSeleccionado["imagen"] as? [String])?.count ?? 0
        let numVideos = (salonSeleccionado["video"] as? [String])?.count ?? 0
        let numVideos360 = (salonSeleccionado["video360"] as? [String])?.count ?? 0
        let objetos3D = (salonSeleccionado["objeto3D"] as? [String])?.count ?? 0
        
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return (numMateriales)
        case 4: return 1
        case 5: return 1
        case 6: return (numFotos)
        case 7: return (numFotos)
        case 8: return 1
        case 9: return (numVideos)
        case 10: return (numVideos)
        case 11: return (numVideos360)
        case 12: return 1
        case 13: return 1
        default: return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "salonCell", for: indexPath) as! SalonCell
        
        switch indexPath.section {
        case 0:
            if let salon = salonSeleccionado["salon"] as? String{
                cell.label.text = salon
            }else{
                cell.label.text = salonSeleccionado["salon"] as? String
            }
        case 1: cell.label.text = salonSeleccionado["nombre"] as? String
        case 2: cell.label.text = salonSeleccionado["horario"] as? String
        case 3: cell.label.text = (salonSeleccionado["equipamiento"] as! [String])[indexPath.row]
        case 4: cell.label.text = salonSeleccionado["correoResponsable"] as? String
        case 5: cell.label.text = salonSeleccionado["descripcion"] as? String
        case 6: cell.label.text = "Foto de prueba"
        case 7: cell.label.text = "Foto de prueba (AR)"
        case 8: cell.label.text = "Imagen Panoramica del salón: \(salonSeleccionado["nombre"] ?? "nil")"
        case 9: cell.label.text = "Video de Lego"
        case 10: cell.label.text = "Video de Lego (AR)"
        case 11: cell.label.text = "Video de un puente (360)"
        case 12: cell.label.text = "Eevee"
        case 13: cell.label.text = "Laptop sobre marcador"
            
        default: 0
        }
        
        cell.label.numberOfLines = 0
        cell.label.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.label.sizeToFit()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 6{
            performSegue(withIdentifier: "imagePlayer", sender: indexPath)
        }
        if indexPath.section == 9{
            performSegue(withIdentifier: "videoPlayer", sender: indexPath)
        }
        if indexPath.section == 10{
            performSegue(withIdentifier: "videoARPlayer", sender: indexPath)
        }
        if indexPath.section == 11{
            performSegue(withIdentifier: "quickscopePlayer", sender: indexPath)
        }
        if indexPath.section == 12{
            performSegue(withIdentifier: "objectViewer", sender: indexPath)
        }
        if indexPath.section == 13{
            performSegue(withIdentifier: "marcadorSegue", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="imagePlayer"){
            let controller = segue.destination as! imagenJSONViewController
            let row = (sender as! NSIndexPath).row
            let imagenString = (salonSeleccionado["imagen"] as! [String])[row]
            
            controller.urlImagen = imagenString
        }
        
        if(segue.identifier=="videoPlayer"){
            let controller = segue.destination as! MultimediaViewController
            let row = (sender as! NSIndexPath).row
            let imagenString = (salonSeleccionado["video"] as! [String])[row]
            
            controller.moviePath = imagenString
        }
        if(segue.identifier=="videoARPlayer"){
            let controller = segue.destination as! ViewController
            let row = (sender as! NSIndexPath).row
            let imagenString = (salonSeleccionado["video"] as! [String])[row]
            
            controller.moviePath = imagenString
        }
        if(segue.identifier=="quickscopePlayer"){
            let controller = segue.destination as! QuickscopeViewController
            let row = (sender as! NSIndexPath).row
            let imagenString = (salonSeleccionado["video360"] as! [String])[row]
            
            controller.moviePath = imagenString
        }
        if(segue.identifier=="objectViewer"){
            let controller = segue.destination as! ObjectViewController
            let row = (sender as! NSIndexPath).row
            
            controller.escenaPath = (((salonSeleccionado["objeto3D"] as! [Any])[row]) as! [String:Any])["objeto"] as! String
            controller.texturasPath = ((((salonSeleccionado["objeto3D"] as! [Any])[row]) as! [String:Any])["texturas"] as! [String])[1] as! String
        }
        if(segue.identifier=="marcadorSegue"){
            let controller = segue.destination as! objetoMarcadirViewController
            let row = (sender as! NSIndexPath).row
            
            controller.escenaPath = salonSeleccionado["marcador3D"] as? String ?? "hi"
          
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
