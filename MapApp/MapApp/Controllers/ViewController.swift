//
//  ViewController.swift
//  MapApp
//
//  Created by Lina on 5/2/19.
//  Copyright © 2019 danicano. All rights reserved.
//

import UIKit
import MapKit
import MessageUI //para poder enviar un mail

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var mapita: MKMapView!
    @IBOutlet weak var enviarLocalizacionBoton: UIButton! //He creado un outlet del botón para mostrarlo activado o desactivado dependiendo de si he encontrado la localización del usuario o no
    
    //Estas variables solo seran accesibles desde mi controlador
    private var latitud: Double = 0.0
    private var longitud: Double = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.enviarLocalizacionBoton.isEnabled = false
        
        //Vamos a obtener la geolocalización. La closure nos devuelve 2 Double (lat y long), IN indica el inicio de la closure.
        //Estamos llamando a GetLocation (es una funcion que devuelve una closure), y vamos a imprimir latitud y longitud en pantalla
        
        Geolocation.shared.getLocation { (lat, long) in
            
            print("La latitud es \(lat) y la longitud es \(long)")
            
            //Voy a pintar mi ubicación en el mapa
            self.showLocationInMap(latitud: lat, longitud: long) //Los parámetros son los que me llegan de la closure
            
            self.enviarLocalizacionBoton.isEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cambiarModoVista(_ sender: UISegmentedControl)
    {
        //Dependiendo del segmented control que tengamos mostremos la vista satelite, hybrida y standard
        switch sender.selectedSegmentIndex {
        case 0:
            mapita.mapType = .standard
        case 1:
            mapita.mapType = .satellite
        case 2:
            mapita.mapType = .hybrid
        default:
            mapita.mapType = .standard
        }
    }
    
    //Defino como se va a mostrar el mapa encuanto a dimensiones, espacio en pantalla, las coordenadas...
    func showLocationInMap(latitud: Double, longitud: Double)
    {
        self.latitud = latitud
        self.longitud = longitud
        
        //Me pide la latitud y la longitud y las tengo en el closure
        let location = CLLocationCoordinate2DMake(latitud, longitud)
        
        //El trozo de mapa que se va a ver. Se puede jugar con estos valores
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        
        //Declaro la region donde quiero que se vea
        let region = MKCoordinateRegion(center: location, span: span)
        
        //Le pasamos la region a mapita
        mapita.setRegion(region, animated: true)
        
        
        //Poner una anotacion en el mapa (pin)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Estás aquí"
        
        //Muestro la anotacion en el mapa
        mapita.addAnnotation(annotation)
    }
    
    
    @IBAction func compartirLocalizacion(_ sender: Any)
    {
        //Compruebo que el usuario tiene una cuenta de mail configurada en el dispositivo
        if MFMailComposeViewController.canSendMail()
        {
            //Llamamos a la geolocalizacion inversa
            GeolocationInverse.shared.getAdressFromCoordinate(latitud: self.latitud, longitud: self.longitud) { completeCloruse in //completeClosure contiene el dato que nos devuelve el escape
                
                print("La localización inversa es: \(completeCloruse)")
                
                //lo meto en el hilo principal
                DispatchQueue.main.async {
                    
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    
                    //mail.setCcRecipients()//a quien quiero enviar el email
                    mail.setSubject("Mira donde estoy")//el asunto del mail
                    mail.setMessageBody("<p>Hola,</p> <p>Estoy en:</p>  <p>\(completeCloruse) </p> ", isHTML: true)//Lo que quiero que ponga el mail. Pongo <p> que es una etiqueta de html para decir que es un párrafo
                    
                    self.present(mail, animated: true, completion: nil) //presento la vista
                }
            }
        }
        else
        {
            let alertView = UIAlertController(title: "Error", message: "No tienes ninguna cuenta configurada en este dispositivo", preferredStyle: .alert)
            let alertButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertView.addAction(alertButton)
            self.present(alertView, animated: true, completion: nil)
        }
        
    }
    
    
    //Metodo delegado para el error del email. Es para cuando el usuario le da a enviar email o cancelar. Para que la vista se oculte.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
}


