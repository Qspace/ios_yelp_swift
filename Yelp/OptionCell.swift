//
//  DropCell.swift
//  Yelp
//
//  Created by MAC on 11/22/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol OptionCellDelegate {
    optional func optionCell(optionCell : OptionCell, onRowSelect selected : Bool)
}

class OptionCell: UITableViewCell {
    
    @IBOutlet weak var fieldLabel: UILabel!
    
    
    @IBOutlet weak var iconImgView: UIImageView!
    
    weak var delegate: OptionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true {
            showSelectedView()
        }
        else {
            showInitView()
        }
        delegate?.optionCell?(self, onRowSelect: selected)
        // Configure the view for the selected state
    }
    
    func showSelectedView() {
        iconImgView.image = UIImage(named: "Checked.png")
    }
    
    func showInitView() {
        iconImgView.image = nil
    }
}
