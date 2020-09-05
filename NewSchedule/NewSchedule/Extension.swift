//
//  Extension.swift
//  NewSchedule
//
//  Created by IvanLyuhtikov on 2/23/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit


extension ViewController: MultiDirectionOrganizedScrollDelegate, WeekControlDelegate {
    
    
    func data(forDays weekControl: WeekControl) -> [String] {
        return ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
    }
    
    
    
    
    func countOfPages() -> Int {
        return 6
    }
    
    func edge() -> UIEdgeInsets {
        return view.layoutMargins
    }
    
    
}
