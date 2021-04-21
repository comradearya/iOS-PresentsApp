//
//  PointsController.swift
//  PresentsApp
//
//  Created by orpan on 20.04.2021.
//

import Foundation

class PointsController{
    private var maxPoints : Double = 100
    var balance = Double()
    
    func balanceLabel(afterSelecting presents:[Present]) -> String{
        let price = presents.map{ $0.price}.reduce(0, +)
        updateBalance(with: price)
        return ("\(self.balance)/\(self.maxPoints)")
    }
    
    private func updateBalance(with wholePrice: Double) {
        self.balance = maxPoints - wholePrice
    }
}
