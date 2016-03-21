//
//  WodeGuTVC.swift
//  ShengLiJinRong
//
//  Created by Admin on 10/25/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit

class WodeGuTVC: UITableViewCell {
    
    
    @IBOutlet weak var wodeguNameLbl: UILabel!
    @IBOutlet weak var wodeguPriceLbl: UILabel!
    @IBOutlet weak var wodeguPercentLbl: UILabel!
    @IBOutlet weak var wodeguIndex: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
