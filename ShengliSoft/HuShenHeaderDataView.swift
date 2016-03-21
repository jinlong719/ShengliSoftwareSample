//
//  HuShenHeaderDataView.swift
//  ShengliSoft
//
//  Created by EagleWind on 1/26/16.
//  Copyright © 2016 iCloudTest. All rights reserved.
//

import UIKit

class HuShenHeaderDataView: UIView {

    @IBOutlet weak var mainPriceLbl: UILabel!
    @IBOutlet weak var rateValLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    var view: UIView!
    var nibName: String = "HuShenHeaderDataView"
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewSetUp()
//        fatalError("init(coder:) has not been implemented")
    }
    func viewSetUp(){
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    
}
