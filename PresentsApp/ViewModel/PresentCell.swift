//
//  PresentCell.swift
//  PresentsApp
//
//  Created by orpan on 16.04.2021.
//

import Foundation
import UIKit

class PresentCell: UITableViewCell{
    
    //MARK: - Outlets
    
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellDescriptionLabel: UILabel!
    
    //MARK: - Public Methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
            initViews()
    }
    
    func initViews() {
        selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView?.backgroundColor = UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 0.8)
    }
    
    func configureCell(item: Present){
        cellTitleLabel.text = item.title
        cellDescriptionLabel.text = String(item.price)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let fontSize: CGFloat = selected ? 34.0 : 17.0
        self.textLabel?.font = self.textLabel?.font.withSize(fontSize)
    }
}
