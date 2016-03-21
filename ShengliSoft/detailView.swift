//
//  detailView.swift
//  ShengliSoft
//
//  Created by Admin on 11/10/15.
//  Copyright © 2015 iCloudTest. All rights reserved.
//

import UIKit

@IBDesignable class detailView: UIView {

    //MARK: - Parameters Initialization
    @IBOutlet weak var ymdwLbl: UILabel!
    @IBOutlet weak var kaipanLbl: UILabel!
    @IBOutlet weak var zuigaoLbl: UILabel!
    @IBOutlet weak var zuidiLbl: UILabel!
    @IBOutlet weak var shoupanLbl: UILabel!
    @IBOutlet weak var shengdieELbl: UILabel!
    @IBOutlet weak var shengdiefuLbl: UILabel!
    @IBOutlet weak var chengjiaoliangLbl: UILabel!
    @IBOutlet weak var chengjiaoELbl: UILabel!
    
    var view: UIView!
    var nibName: String = "detailView"
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        // Set anything that uses the view or visible bounds
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Set up
        setUp()
    }
    func setUp()
    {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    func loadViewFromNib() -> UIView
    {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
