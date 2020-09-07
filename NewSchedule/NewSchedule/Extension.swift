//
//  Extension.swift
//  NewSchedule
//
//  Created by IvanLyuhtikov on 2/23/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit


extension ViewController: MultiDirectionOrganizedScrollDelegate, WeekControlDelegate, UIScrollViewDelegate {
    
    
    
    
    //MARK: - WeekControlDelegate
    
    func data(forDays weekControl: WeekControl) -> [String] {
        return ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
    }
    
    
    func convenientPage(_ sender: UIButton) {
        multiScroll.go(toPageOfScrollView: sender.tag)
        weekControl.currentDay = sender.tag
        multiScroll.pageControl.currentPage = sender.tag
    }
    
    
    
    //MARK: - MultiDirectionOrganizedScrollDelegate
    
    func countOfPages() -> Int {
        return 6
    }
    
    func edge() -> UIEdgeInsets {
        return view.layoutMargins
    }
    
    //MARK: - ScrollView Delegate
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = round(targetContentOffset.pointee.x / SizeEntity.kScreenWidth)
        multiScroll.pageControl.currentPage = Int(page)
        
        weekControl.currentDay = Int(page)
    }
    
    
}

extension Date {
    func dayOfWeek() -> Int? {
        let res = Calendar.current.dateComponents([.weekday], from: self).weekday!
        return res > 1 ? res-2 : 5
    }
}
