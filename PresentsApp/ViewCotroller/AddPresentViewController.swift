//
//  AddPresentViewController.swift
//  PresentsApp
//
//  Created by orpan on 17.04.2021.
//

import Foundation
import UIKit

final class AddPresentViewController: UIViewController {
    
    //MARK: - Enum
    
    enum ActionType {
            case doneAction
            case cancelAction
        }
    
    //MARK: - Properties
    
    var newPresent: Present?
    var presentsList = [Present]()
    
    //MARK: - Outlets
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var titlePresentInput: UITextField!
    
    @IBOutlet weak var pricePresentInput: UITextField!
    
    @IBOutlet weak var labelOutput: UILabel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelOutput.text = ""
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        switch identifier{
        case "doneSegue":
            if inputFilled() && inputFilledRight() {
                return true
            }
            else {
                showAlert(.doneAction)
                return false
            }
        case "cancelSegue":
            if !inputFilled() {
                return true
            }
            else {
                showAlert(.cancelAction)
            }
        default: break
        }
        return true
    }
    
    //MARK: - Private Methods
    
    private func inputFilled() -> Bool {
        if (titlePresentInput.text!.isEmpty || pricePresentInput.text!.isEmpty) {
            return false
        }
        return true
    }
    
    private func inputFilledRight() -> Bool {
        if let priceInput = Double(pricePresentInput.text!) {
            if priceInput < 100 {
                return true
            } else {
                labelOutput.text = AddPresentLabel.priceIsBigger
                return false 
            }
        }
        labelOutput.text = AddPresentLabel.priceIsNotDouble
        return false
    }
    
    private func showAlert(_ action: ActionType) {
        switch action{
        case .doneAction:
            let addNewPresentAlert = UIAlertController(title: AddPresentAlertTitles.doneAlert, message: AddPresentAlertMessages.doneAlert, preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: AlertActionsText.ok, style: .default)
            addNewPresentAlert.addAction(acceptAction)
            self.present(addNewPresentAlert, animated: true, completion: nil)
        case .cancelAction :
            let addNewPresentAlert = UIAlertController(title: AddPresentAlertTitles.cancelAlert, message: AddPresentAlertMessages.cancelAlert, preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: AlertActionsText.ok, style: .default)
            let cancelAction = UIAlertAction(title: AlertActionsText.back, style: .cancel)
            addNewPresentAlert.addAction(acceptAction)
            addNewPresentAlert.addAction(cancelAction)
            
            self.present(addNewPresentAlert, animated: true, completion: nil)
        }
    }
  
    //MARK: - Actions
    
    @IBAction func doneTapped(_ sender: Any) {
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
    }
    
}
