//
//  DoubleInsideCollectionViewCell.swift
//  NewSchedule
//
//  Created by IvanLyuhtikov on 6.08.20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit

class ContentView: UIView {
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var numberOfPare: UILabel!
    @IBOutlet weak var numberOfRoom: UILabel!
    @IBOutlet weak var teacher: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.clear.cgColor
        layer.masksToBounds = true


        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
//        layer.backgroundColor = UIColor.clear.cgColor
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ContentView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        return view
    }
    
    
}
