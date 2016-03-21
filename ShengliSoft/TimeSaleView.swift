//
//  TimeSaleView.swift
//  ShengliSoft
//
//  Created by Admin on 12/4/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit

class TimeSaleView: UIView {
    
    @IBOutlet weak var timeCell: UILabel!
    @IBOutlet weak var priceCell: UILabel!
    @IBOutlet weak var volCell: UILabel!
    

    var view: UIView!
    var nibName: String = "TimeSaleView"
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp()
    {
        view = loadViewNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    func loadViewNib() -> UIView{
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
}