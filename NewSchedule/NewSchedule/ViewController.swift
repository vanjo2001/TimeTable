//
//  ViewController.swift
//  NewSchedule
//
//  Created by IvanLyuhtikov on 2/23/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    
    var current: CurriculumWeek = [[CurriculumPare()]]
    var multiScroll: MultiDirectionOrganizedScroll!
    var weekControl: WeekControl!
    
    var fullCurriculum: CurriculumBothWeeks?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
        
        setupMultiScroll()
        
        setupWeekControl()
        
        setupSyncLoad()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.multiScroll.multiDelegate = self
        
        self.weekControl.weekDelegate = self
        
        setupLayout()
    }
    
    
    func setupMultiScroll() {
        multiScroll = MultiDirectionOrganizedScroll(countOfPages: 6,
                                                    withFrame: CGRect(x: view.center.x,
                                                                     y: view.center.y,
                                                                     width: SizeEntity.kScreenWidth,
                                                                     height: SizeEntity.kScreenHeight/2),
                                                    andStyle: .default)
        
        multiScroll.translatesAutoresizingMaskIntoConstraints = false
        multiScroll.backgroundColor = .white
        multiScroll.isPageControlActive = true
        view.addSubview(multiScroll)
    }
    
    func setupWeekControl() {
        weekControl = WeekControl(frame: CGRect(x: 0, y: SizeEntity.kScreenHeight-SizeEntity.kBottomConstraint, width: SizeEntity.kScreenWidth, height: SizeEntity.kBottomConstraint))
        weekControl.backgroundColor = UIColor(red: 240/255, green: 230/255, blue: 230/255, alpha: 1)
        
        view.addSubview(weekControl)
    }
    
    func setupSyncLoad() {
        let queue = DispatchQueue(label: "vanjo_gueue")
        
        
        var dictionary: [String: String] = [:]
        
        queue.async {
            dictionary = getLinkDictionary()
            print(dictionary)
        }
        
        queue.async {
            RequestKBP.getData(stringURL: dictionary["Т-75"] ?? "https://kbp.by/rasp/timetable/view_beta_kbp/?cat=group&id=42") { (data) in
                self.fullCurriculum = data

                self.current = self.fullCurriculum?.currentWeek ?? CurriculumWeek()
                self.current = removeEmptyPares(arr: self.current)

                
                self.multiScroll.data = self.current
                
                
                self.multiScroll.reloadData()
//                DispatchQueue.main.async {
//
//                }
            }
        }
    }
    
    func setupLayout() {
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            multiScroll.topAnchor.constraint(equalTo: margins.topAnchor),
            multiScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            multiScroll.rightAnchor.constraint(equalTo: view.rightAnchor),
            multiScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -SizeEntity.kBottomConstraint)
        ])
    }
}
