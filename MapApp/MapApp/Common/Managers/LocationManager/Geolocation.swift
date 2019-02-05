//
//  Geolocation.swift
//  MapApp
//
//  Created by Lina on 5/2/19.
//  Copyright © 2019 danicano. All rights reserved.
//

import UIKit
import CoreLocation

class Geolocation: NSObject, CLLocationManagerDelegate { //ajusto mi clase a los protocolos que quiero
    
    //CREO UNA PROPIEDAD PARA GESTIONAR LA LOCALIZACION
    var locationManager = CLLocationManager()
    
    
    //CREO LAS PROPIEDADES PARA ALMACENAR LA LATITUD Y LA LONGITUD
    var lat: Double = 0.0
    var long: Double = 0.0
    
    
    //CREO UNA PROPIEDAD DE TIPO CLOSURE PARA RECOGER LOS DATOS DE LA LOCALIZACIÓN
    var datosLoc: ((Double, Double) -> Void)? = nil //no tiene que devolver nada (Void). Los double son los parametros de entrada de la closure.
    
    
    //CREO UNA FUNCION QUE INICIE TODO EL PROCESO DE GEOLOCALIZACIÓN.
    //Esta closure tiene "escape" y este escape, significa que va a devolver algo. Entre parentesi le digo Que va a devolver, en este caso 2 double (que serán la latitud y la longitud).
    //Escaping nos dice que lo que hay dentro del parentesi es lo que nos va a devolver la funcion a traves del closure
    func getLocation(callback: @escaping (Double, Double) -> Void) {
        
        //Geolocation es el delegado de locationManager
        locationManager.delegate = self
        
        //Pido autorizacion al usuario
        self.locationManager.requestWhenInUseAuthorization()
        
        //La precision de la localizacion
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest //hay muchas, la mejor es la de navigation
        
        //Ponemos en marcha la localizacion
        self.locationManager.requestLocation()
        
        //Necesito datosLoc para devolverlo en el escaping
        //Devuelve la geoloclizacion obtenida
        datosLoc = callback
    }
    
    
    //DECLARO E IMPLEMENTO LOS METODOS DELEGADOS
    
    //Este gestionara los errores en la localización
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        let alertView = UIAlertController(title: "Error", message: "No ha sido posible encontrar su situación", preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(alertButton)
        
        //Esta alerta la tengo que mostrar en el VC
        
        //Estamos orquestando un mecaqnismo que nos dé una vista a nivel global, a nivel de aplicacion, para mostrar este alertView
        
        let autorizacion = CLLocationManager.authorizationStatus()
        
        switch autorizacion {
            
        case .denied, .notDetermined, .restricted:
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    //Este nos dará la geolocalizacion
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //saco las coordenadas geograficas en 2 dimensiones, longitud y latitud
        let localizationValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        //Decimos una condicion de que si ya hemos obtenido la geolocalización, ya no la queremos
        if datosLoc != nil
        {
            datosLoc!(localizationValue.latitude, localizationValue.longitude) //le estoy pasando a datosLoc la longitud y la latitud
        }
        
        locationManager.stopUpdatingLocation() //Para que pare de buscar
        
    }
    
    
    //PATRÓN SINGLETON: Lo que hace es que a través de una única propiedad calculada ( = { ... }() ), te permite acceder a todas las funciones y propiedades de una clase.
    
    static let shared: Geolocation = {
        let instance = Geolocation() //inicializo la clase y la devuelvo la clase inicializada
        return instance
    }()
    
    
    
    
}

//ESTA CLASE LA PODEMOS YA USAR EN CUALQUIER PROYECTO QUE REQUIERA GEOLOCALIZACIÓN

//La geolocalización no tiene nada que ver con el mapa, van por separado.
//El mapa va con MapKit y la Geolocalización va con Core Location

