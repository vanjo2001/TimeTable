//
//  ParsingMethods.swift
//  NewSchedule
//
//  Created by Тимофей Лукашевич on 2/23/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import Foundation

func searchByRegularExpresion(regularEx: String, str: String) -> [String] {
    var arr = [String]()
    
    var copy = str
    while copy != "" {
        if let mess = copy.range(of: regularEx, options: .regularExpression) {
            arr.append(String(copy[mess]))
            let range = Range(uncheckedBounds: (lower: copy.startIndex, upper: mess.upperBound))
            
            copy.removeSubrange(range)
        } else {
            copy = ""
        }
    }
    return arr
}

func removeEmptyPares(arr: CurriculumWeek) -> CurriculumWeek {
    var copy = arr
    
    for (i, day) in copy.enumerated() {
        copy[i] = day.filter { (pare: CurriculumPare) -> Bool in
            
            return !(pare.teacher == "")
        }
    }
    return copy
}
