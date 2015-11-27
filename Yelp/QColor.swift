//
//  QColor.swift
//  Yelp
//
//  Created by MAC on 11/27/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class QColor: UIColor {
    struct Colors {
        static let CellSelectColor = UIColor(netHex: 0x516E3D)
        static let CellUnselectColor = UIColor(netHex: 0xE4FFD1)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}