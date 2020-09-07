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


        
        layer.shadowColor = UIColor(named: "ShadowyColor")?.cgColor
        layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
        frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height:
                                                                                    SizeEntity.sizeForCell * SizeEntity.coefFont > SizeEntity.minSizeForCell
                                                                                    ? SizeEntity.sizeForCell * SizeEntity.coefFont
                                                                                    : SizeEntity.minSizeForCell)
        
        subject.font = subject.font.withSize(subject.font.pointSize * SizeEntity.coefFont).pointSize > SizeEntity.minSubject
                                                        ? subject.font.withSize(subject.font.pointSize * SizeEntity.coefFont)
                                                        : subject.font.withSize(SizeEntity.minSubject)
        
        numberOfPare.font = numberOfPare.font.withSize(numberOfPare.font.pointSize * SizeEntity.coefFont).pointSize > SizeEntity.minNumOfPare
                                                        ? numberOfPare.font.withSize(numberOfPare.font.pointSize * SizeEntity.coefFont)
                                                        : numberOfPare.font.withSize(SizeEntity.minNumOfPare)
        
        numberOfRoom.font = numberOfRoom.font.withSize(numberOfRoom.font.pointSize * SizeEntity.coefFont).pointSize > SizeEntity.room
                                                        ? numberOfRoom.font.withSize(numberOfRoom.font.pointSize * SizeEntity.coefFont)
                                                        : numberOfRoom.font.withSize(SizeEntity.minRoom)
        
        teacher.font = teacher.font.withSize(teacher.font.pointSize * SizeEntity.coefFont).pointSize > SizeEntity.minTeacher
                                                        ? teacher.font.withSize(teacher.font.pointSize * SizeEntity.coefFont)
                                                        : teacher.font.withSize(SizeEntity.minTeacher)
        
        
        time.font = time.font.withSize(time.font.pointSize * SizeEntity.coefFont).pointSize > SizeEntity.minTime
                                                        ? time.font.withSize(time.font.pointSize * SizeEntity.coefFont)
                                                        : time.font.withSize(SizeEntity.minTime)
        
//        layer.backgroundColor = UIColor.clear.cgColor
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ContentView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height * SizeEntity.coefFont)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        return view
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        layer.shadowColor = UIColor(named: "ShadowyColor")?.cgColor
        
    }
    
    
}
