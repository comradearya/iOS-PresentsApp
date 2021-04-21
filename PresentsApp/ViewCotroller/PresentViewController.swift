//
//  ViewController.swift
//  PresentsApp
//
//  Created by orpan on 16.04.2021.
//

import UIKit

class PresentViewController: UIViewController {
    
   //MARK: - Constants
    
    private let identifier = "presentCell"
    
    //MARK: - Properties
    
    private var presentsList = [Present]()
    private var actionablePresent = Present()
    private var pointsController = PointsController()
    
    private var refreshControl = UIRefreshControl()
    private var observer: NSObjectProtocol?
    private var deletePresentIndexPath: IndexPath? = nil
    var checked: [Bool]!
    //MARK: - Outlets
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var presentsTableView: UITableView!
    @IBOutlet weak var addPresentButton: UIBarButtonItem!
    
    //MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitController.initFirstLaunch()
        checked = [Bool](repeating: false, count: presentsList.count)
        presentsTableView.delegate = self
        presentsTableView.dataSource = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Оновлюємо")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        presentsTableView.addSubview(refreshControl)
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [unowned self] notification in
            loadData()
        }
        loadData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let addViewController = storyBoard.instantiateViewController(withIdentifier: "AddPresentIdentifier") as? AddPresentViewController {
            self.present(addViewController, animated: true, completion: nil)
        }
    }
}


extension PresentViewController: UITableViewDelegate, UITableViewDataSource {

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presentsList.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? PresentCell {
            cell.configureCell(item: presentsList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: PresentAlertActions.deleteAction) { [self] (action:UIContextualAction, sourceView:UIView, actionPerformed:(Bool) -> Void) in
            self.actionablePresent.title = self.presentsList[indexPath.row].title
            self.actionablePresent.price = self.presentsList[indexPath.row].price
            self.confirmDelete(present: self.actionablePresent)
            tableView.reloadData()
            self.loadData()
            actionPerformed(true)
        }
        
        var selectActionTitle = String()
        if self.presentsList[indexPath.row].selected {
            selectActionTitle = PresentAlertActions.deselectAction
            let selectAction = UIContextualAction(style: .normal, title: selectActionTitle) { [self] (action:UIContextualAction, sourceView:UIView, actionPerformed:(Bool) -> Void) in
                self.actionablePresent.title = self.presentsList[indexPath.row].title
                self.actionablePresent.price = self.presentsList[indexPath.row].price
                RealmHelper.update(present: self.actionablePresent, isSelected: false)
                loadData()
                actionPerformed(true)
            }
            return UISwipeActionsConfiguration(actions: [deleteAction,selectAction])
        }
        else {
            selectActionTitle = PresentAlertActions.selectAction
            let selectAction = UIContextualAction(style: .normal, title: selectActionTitle) { [self] (action:UIContextualAction, sourceView:UIView, actionPerformed:(Bool) -> Void) in
                if self.presentsList[indexPath.row].price <= pointsController.balance {
                    self.actionablePresent.title = self.presentsList[indexPath.row].title
                    self.actionablePresent.price = self.presentsList[indexPath.row].price
                    self.actionablePresent.selected = true
                    RealmHelper.update(present: self.actionablePresent, isSelected: true)
                    loadData()
                    actionPerformed(true)
                }
                else {
                    showBalanceAlert()
                }
            }
            return UISwipeActionsConfiguration(actions: [deleteAction,selectAction])
        }
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //MARK:- Private Methods
    
    @objc private func refresh(_ sender: AnyObject) {
        loadData()
        refreshControl.endRefreshing()
        self.presentsTableView.reloadData()
    }
    
    private func loadData(){
        self.presentsList = RealmHelper.getObjects()
        print(presentsList.description)
        self.pointsLabel.text = self.pointsController.balanceLabel(afterSelecting: presentsList.filter({$0.selected}))
        print( presentsList.filter({$0.selected}).count)
    }
    
    private func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .delete {
            deletePresentIndexPath = indexPath as IndexPath
            let toDelete = presentsList[indexPath.row]
            confirmDelete(present: toDelete)
        }
    }
    
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    private func confirmDelete(present: Present) {
        let alert = UIAlertController(title:PresentAlertTitles.deleteAlert, message: PresentAlertMessages.deleteAlert, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: AlertActionsText.yes, style: .destructive, handler: handleDeletePresent)
        let cancelAction = UIAlertAction(title: AlertActionsText.no, style: .cancel, handler: handleCancelDelete)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func handleDeletePresent(alertAction: UIAlertAction!) -> Void {
        RealmHelper.realmDeleteObject(with: actionablePresent.title, price: actionablePresent.price)
        if actionablePresent.selected {
            self.pointsLabel.text = ""
        }
        loadData()
    }
    
    private func handleCancelDelete(alertAction: UIAlertAction!) -> Void {
        deletePresentIndexPath = nil
    }
    
    private func showBalanceAlert(){
        let alert = UIAlertController(title:  PresentAlertTitles.balanceAlert, message: PresentAlertMessages.balanceAlert, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AlertActionsText.ok, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension PresentViewController {    
    @IBAction func donePressed(segue:UIStoryboardSegue) {
        let vc = segue.source as! AddPresentViewController
        
        if (addNewPresent(title: vc.titlePresentInput.text!, price: vc.pricePresentInput.text!)) {
            self.presentsTableView.performBatchUpdates({
                self.presentsTableView.insertRows(at: [IndexPath(row: self.presentsList.count - 1, section: 0)], with: .automatic)
            }, completion: nil)
        } else {
            vc.labelOutput.text = AddPresentLabel.priceIsNotDouble
        }
    }
    
    @IBAction func cancelPressed(segue:UIStoryboardSegue) {
        
    }
    
     func addNewPresent(title: String, price: String) -> Bool {
        let newPresent = Present()
        newPresent.title = String(title)
        if let price = Double(price){
            newPresent.price = price
            presentsList.append(newPresent)
            RealmHelper.saveObjects(objects: self.presentsList)
            return true
        }
        else {
            return false
        }
    }
}
