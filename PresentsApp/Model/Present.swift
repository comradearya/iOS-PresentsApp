//
//  Present.swift
//  PresentsApp
//
//  Created by orpan on 16.04.2021.
//

import RealmSwift
import ObjectMapper

@objcMembers class Present: Object  {
    dynamic var title: String = ""
    dynamic var price: Double = 0.0
    dynamic var selected: Bool = false
}
