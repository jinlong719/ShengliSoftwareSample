//
//  TimeSaleCell.swift
//  ShengliSoft
//
//  Created by Admin on 11/27/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit

class TimeSaleCell: UITableViewCell {
    
    @IBOutlet weak var timeCell: UILabel!
    @IBOutlet weak var timePriceCell: UILabel!
    @IBOutlet weak var timeVolCell: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
