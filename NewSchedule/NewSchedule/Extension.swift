//
//  Extension.swift
//  NewSchedule
//
//  Created by IvanLyuhtikov on 2/23/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit


extension ViewController: MultiDirectionOrganizedScrollDelegate {
    
    
    
    func countOfPages() -> Int {
        return 6
    }
    
    func content() -> [[CurriculumPare]] {
        return [
                    [CurriculumPare(pName: "AAS", teach: "alsfdj", room: "wljsfd", group: "l3j3jj", nPare: "a3jl"),
                     CurriculumPare(pName: "BSS", teach: "alsfdj", room: "wljsfd", group: "l3j3jj", nPare: "a3jl"),
                     CurriculumPare(pName: "GSS", teach: "alsfdj", room: "wljsfd", group: "l3j3jj", nPare: "a3jl"),
                     CurriculumPare(pName: "FSS", teach: "alsfdj", room: "wljsfd", group: "l3j3jj", nPare: "a3jl"),
                     CurriculumPare(pName: "SHSS", teach: "alsfdj", room: "wljsfd", group: "l3j3jj", nPare: "a3jl")],
                    
                    [CurriculumPare(pName: "LPP", teach: "alsfdj", room: "wljsfd", group: "l3j3jj", nPare: "a3jl"),
                    CurriculumPare(pName: "TTT", teach: "alsfdj", room: "wljsfd", group: "l3j3jj", nPare: "a3jl"),
                    CurriculumPare(pName: "SGAL", teach: "alsfdj", room: "wljsfd", group: "l3j3jj", nPare: "a3jl")],
            
                    [CurriculumPare(pName: "LPP", teach: "alsfdj", room: "wljsfd", group: "l3j3jj", nPare: "a3jl")]
                ]
    }
    
    func edge() -> UIEdgeInsets {
        return view.layoutMargins
    }
    
    
}
