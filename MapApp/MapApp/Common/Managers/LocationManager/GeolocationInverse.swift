//
//  GeolocationInverse.swift
//  MapApp
//
//  Created by Lina on 5/2/19.
//  Copyright © 2019 danicano. All rights reserved.
//

import UIKit
import CoreLocation

class GeolocationInverse: NSObject {
    
    var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    
    
    func getAdressFromCoordinate(latitud: Double, longitud: Double, completeCloruse: @escaping (String) -> Void)
    {
        let geo = CLGeocoder()
        center.latitude = latitud
        center.longitude = longitud
        
        let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        //Le paso a geo la localizacion inversa
        geo.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
            
            //Si hay un error lo saco por pantalla
            if (error != nil)
            {
                print("Hay un error")
            }
            
            let pm = placemarks! as [CLPlacemark]
            
            //Compongo el string que voy a devolver
            var adressString: String = ""
            
            
            if pm.count > 0
            {
                let placemark = placemarks![0]
                
                if placemark.subLocality != nil
                {
                    adressString = adressString + placemark.subLocality! + ", "
                }
                
                if placemark.thoroughfare != nil
                {
                    adressString = adressString + placemark.thoroughfare! + ", "
                }
                
                if placemark.locality != nil
                {
                    adressString = adressString + placemark.locality! + ", "
                }
                
                if placemark.country != nil
                {
                    adressString = adressString + placemark.country! + ", "
                }
                
                if placemark.postalCode != nil
                {
                    adressString = adressString + placemark.postalCode! + ", "
                }
            }
            
            completeCloruse(adressString)
        })
    }
    
    
    //PATRÓN SINGLETON: Lo que hace es que a través de una única propiedad calculada ( = { ... }() ), te permite acceder a todas las funciones y propiedades de una clase.
    
    static let shared: GeolocationInverse = {
        let instance = GeolocationInverse() //inicializo la clase y la devuelvo la clase inicializada
        return instance
    }()
    
}




//En esta clase vamos a convertir los datos de latitud y longitud en una calle real, para que no sean todo números

