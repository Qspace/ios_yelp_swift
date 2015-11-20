//
//  SwitchCell.swift
//  Yelp
//
//  Created by MAC on 11/19/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCell(switchCell: SwitchCell, didChangeVaue value: Bool)
}

class SwitchCell: UITableViewCell {
    
    weak var delegate: SwitchCellDelegate?

    @IBOutlet weak var switchLabel: UILabel!
    
    @IBOutlet weak var onSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchValueChanged(sender: AnyObject) {
        delegate?.switchCell?(self, didChangeVaue: onSwitch.on)
    }
    

}
