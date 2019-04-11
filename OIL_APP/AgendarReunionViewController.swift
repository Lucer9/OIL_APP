//
//  AgendarReunionUIViewController.swift
//  OIL_APP
//
//  Created by L9 on 3/17/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit
import EventKit
class AgendarReunionViewController: UIViewController {
    
    @IBOutlet var nombreEquipoLabel: UILabel!
    @IBOutlet weak var fechaEvento: UIDatePicker!
    @IBOutlet weak var horaFinalEvento: UIDatePicker!
    
    var nombreEquipo:String!
    var idEquipo:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nombreEquipoLabel.text = nombreEquipo
    }
    
    @IBAction func createEvent(_ sender: UIBarButtonItem) {
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event){
        case .authorized:
            insertEvent(store: eventStore)
        case .denied:
            print("Acceso denegado")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion: {[weak self] (granted: Bool, error: Error?) -> Void in
                if granted{
                    self!.insertEvent(store: eventStore)
                }else{
                    print("Acceso denegado")
                }
            })
        default:
            print("uwu")
        }
    }
    
    func insertEvent(store: EKEventStore){
        let event = EKEvent(eventStore: store)
        
        event.title = "Junta " + self.nombreEquipo
        event.startDate = fechaEvento.date
        event.endDate = event.startDate + horaFinalEvento.countDownDuration
        event.calendar = store.defaultCalendarForNewEvents
        
        do{
            try store.save(event, span: .thisEvent)
        }catch let error as NSError{
            print("Error al guardar el evento: \(String(describing: error))")
        }
        print("Se guardó el evento con éxito")
        let alerta = UIAlertController(title: "Evento creado", message: "El evento ha sido creado con éxito", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }
}
