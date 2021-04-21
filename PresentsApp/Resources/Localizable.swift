//
//  Localizable.swift
//  PresentsApp
//
//  Created by orpan on 18.04.2021.
//

import Foundation

enum PresentAlertActions {
    static let deleteAction = "Видалити"
    static let deselectAction = "Видалити з обраного"
    static let selectAction = "Обрати"
}

enum PresentAlertTitles {
    static let deleteAlert = "Справді видалити?"
    static let balanceAlert = "На жаль, рівень рахунку не дозволяє вибрати цей подарунок"
}

enum PresentAlertMessages {
    static let doneAlert = "Спробуй ще раз"
    static let  cancelAlert = "Усі дані будуть видалені"
    static let  deleteAlert = "Повернути вже не вдасться"
    static let balanceAlert = "Можливо знайдеться щось ще цікавеньке"
}

enum AddPresentAlertMessages {
    static let doneAlert = "Спробуй ще раз"
    static let  cancelAlert = "Усі дані будуть видалені"
    static let  deleteAlert = ""
}

enum AddPresentAlertTitles  {
    static let doneAlert = "Упс! Щось не так з заповненими даними"
    static let  cancelAlert = "Ти впевнений, що хочеш відмінити ввід?"
}

enum AddPresentLabel {
    static let priceIsBigger = "Ціна подарунку не може бути більшою за 100"
    static let priceIsNotDouble = "Ціна не може бути такою. Може спробуєш ще раз?"
}

enum AlertActionsText {
    static let ok = "Добре"
    static let back = "Назад"
    static let yes = "Так"
    static let no = "Ні"
}



