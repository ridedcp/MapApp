//
//  NSUserDefaultsManager.swift
//  MapApp
//
//  Created by Lina on 5/2/19.
//  Copyright © 2019 danicano. All rights reserved.
//

import UIKit

class NSUserDefaultManager{
    
    //MARK: - EXIST KEY
    func existKeyInUserDefaults(key: String) -> Bool{
        
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    //MARK: - DELETE VALUES IN DEFAULTS
    func deleteValueInUserDefaultsWith(key: String){
        
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func deleteAllValuesInUserDefaults(){
        
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }
    
    //MARK: - SINGLETON
    static let sharedInstance: NSUserDefaultManager = {
        
        let instance = NSUserDefaultManager()
        return instance
    }()
    
}
