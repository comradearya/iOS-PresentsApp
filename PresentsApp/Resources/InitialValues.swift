//
//  InitialValues.swift
//  PresentsApp
//
//  Created by orpan on 20.04.2021.
//

import Foundation

class InitController {
    static func initFirstLaunch() {
        var list = [Present]()
        let present = Present()
        present.price = 7
        present.title = "ball"
        list.append(present)
        
        let bicyclePresent = Present()
        bicyclePresent.price = 15
        bicyclePresent.title = "bicycle"
        list.append(bicyclePresent)

        let housePresent = Present()
        housePresent.price = 100
        housePresent.title = "house"
        list.append(housePresent)

        RealmHelper.saveObjects(objects: list)
    }
}
