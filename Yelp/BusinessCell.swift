//
//  BusinessCell.swift
//  Yelp
//
//  Created by MAC on 11/18/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
  
  @IBOutlet var ratingImageView: UIImageView!
  
  @IBOutlet var categoriesLabel: UILabel!
  
  @IBOutlet var addressLabel: UILabel!
  
  @IBOutlet var reviewsCountLabel: UILabel!
  
  @IBOutlet var distanceLabel: UILabel!
  
  @IBOutlet var nameLabel: UILabel!
  
  @IBOutlet var thumbImageView: UIImageView!
  
  var business: Business! {
    didSet {
      nameLabel.text = business.name
      distanceLabel.text = business.distance
      reviewsCountLabel.text = String(business.reviewCount!)
      addressLabel.text = business.address
      categoriesLabel.text = business.categories
      thumbImageView.setImageWithURL(business.imageURL!)
      ratingImageView.setImageWithURL(business.ratingImageURL!)
      
    }
    
  }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
