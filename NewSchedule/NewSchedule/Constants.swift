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
    
    private static let minConstant: CGFloat = 1.3
    
    static let room: CGFloat = 38
    static let subject: CGFloat = 22
    static let teacher: CGFloat = 22
    static let numOfPare: CGFloat = 38
    static let time: CGFloat = 18
    
    static let wd: CGFloat = 32
    
    
    static let minRoom: CGFloat = SizeEntity.room/minConstant
    static let minSubject: CGFloat = SizeEntity.subject/minConstant
    static let minTeacher: CGFloat = SizeEntity.teacher/minConstant
    static let minNumOfPare: CGFloat = SizeEntity.numOfPare/minConstant
    static let minTime: CGFloat = SizeEntity.time/minConstant
    
    static let minWD: CGFloat = SizeEntity.wd/minConstant
    
    
    static let sizeForCell: CGFloat = 128
    
    static let minSizeForCell = SizeEntity.sizeForCell/minConstant
    
    
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


//Version for Objective C

class SizeEntityObjC: NSObject {
    
    private override init() {}
    
    @objc class func screenWidth() -> CGFloat { return SizeEntity.kScreenWidth }
    @objc class func screenHeight() -> CGFloat { return SizeEntity.kScreenHeight }
    @objc class func bottomConstraint() -> CGFloat { return SizeEntity.kBottomConstraint }
    @objc class func wd() -> CGFloat { return SizeEntity.wd }
    @objc class func minWD() -> CGFloat { return SizeEntity.minWD }
    @objc class func coefFont() -> CGFloat { return SizeEntity.coefFont }
    
}
