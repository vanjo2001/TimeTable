//
//  Constants.swift
//  NewSchedule
//
//  Created by IvanLyuhtikov on 3.08.20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit


struct SizeEntity {
    static let cell: CGFloat = 0.2
    static let inset: CGFloat = 25
    
    static let kScreenWidth = UIScreen.main.bounds.width
    static let kScreenHeight = UIScreen.main.bounds.height
    
    static let kBottomConstraint = SizeEntity.kScreenHeight / 9
    
    
    static let room: CGFloat = 38
    static let subject: CGFloat = 22
    static let teacher: CGFloat = 22
    static let numOfPare: CGFloat = 38
    static let time: CGFloat = 18
    
    static let sizeForCell: CGFloat = 140
    
    static let coefFont: CGFloat = SizeEntity.kScreenHeight/812    //812 is a screen iPhone 11 Pro, because design have created with his resolution, therefore - 1x
}


class CurriculumPare: NSObject {
    
    @objc var pairName: String
    @objc var teacher: String
    @objc var room: String
    @objc var group: String
    @objc var numberPare: String
    
    @objc init(pName: String, teach: String, room: String, group: String, nPare: String) {
        
        pairName = pName
        teacher = teach
        self.room = room
        self.group = group
        numberPare = nPare
        
        super.init()
    }
    
    @objc override init() {
        pairName = ""
        teacher = ""
        room = ""
        group = ""
        numberPare = ""
        
        super.init()
        
    }
    
}


class SizeEntityObjC: NSObject {
    private override init() {}
    
    @objc class func screenWidth() -> CGFloat { return SizeEntity.kScreenWidth }
    @objc class func screenHeight() -> CGFloat { return SizeEntity.kScreenHeight }
    @objc class func bottomConstraint() -> CGFloat { return SizeEntity.kBottomConstraint }
    
}
