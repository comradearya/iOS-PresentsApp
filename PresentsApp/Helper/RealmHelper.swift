//
//  RealmHelper.swift
//  PresentsApp
//
//  Created by orpan on 18.04.2021.
//

import Foundation
import RealmSwift

class RealmHelper {
    
    //MARK:- Properties
    
    static var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            }
            catch let error as NSError {
                NSLog("Could not access database: ", error)
            }
            return self.realm
        }
    }
    
    //MARK:- Static Methods
    
    static func saveObjects(objects: [Present]) {
        do {
            try realm.write {
                realm.add(objects)
            }
        } catch let error as NSError {
            NSLog("Could not write to database: ", error)
        }
    }
    
    static func getObjects()->[Present] {
        do {
            let realmResults = realm.objects(Present.self)
            return Array(realmResults)
        } catch let error as NSError {
            NSLog("Could not read database: ", error)
        }
    }
    
    static func getObjects(filter:String)->[Present] {
        let realmResults = realm.objects(Present.self).filter(filter)
        return Array(realmResults)
    }
    
    static func realmDeleteObject(with title: String, price: Double) {
        
        do {
            let realm = try Realm()
            
            let object = realm.objects(Present.self).filter("title = %@ AND price == %@", title, price).first
            
            try! realm.write {
                if let obj = object {
                    realm.delete(obj)
                }
            }
        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }
    }
    
    static func update(present: Present, isSelected: Bool){
        do {
            let presentToUpdate = realm.objects(Present.self).filter("title = %@ AND price == %@", present.title, present.price)
            let realm = try Realm()
            if let present = presentToUpdate.first {
                try! realm.write {
                    present.selected = isSelected
                }
            }
        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }
    }
}
