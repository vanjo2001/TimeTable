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
    
    func edge() -> UIEdgeInsets {
        return view.layoutMargins
    }
    
    
}
