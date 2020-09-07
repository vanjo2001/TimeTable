//
//  ViewController.swift
//  NewSchedule
//
//  Created by IvanLyuhtikov on 2/23/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    
    var currentWeek: CurriculumWeek = [[CurriculumPare()]]
    var nextWeek: CurriculumWeek = [[CurriculumPare()]]
    
    var multiScroll: MultiDirectionOrganizedScroll!
    var weekControl: WeekControl!
    
    
    
    var segmentControl: UISegmentedControl!
    
    var fullCurriculum: CurriculumBothWeeks?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = UIColor(named: "WeekControlColor")
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        let titles = ["Текущая", "Следующая"]
        segmentControl = UISegmentedControl(items: titles)
        segmentControl.tintColor = UIColor.white
//        segmentControl.backgroundColor = UIColor(red: 55/255, green: 115/255, blue: 255/255, alpha: 1.0)
        segmentControl.selectedSegmentIndex = 0
        for index in 0...titles.count-1 {
            segmentControl.setWidth(120, forSegmentAt: index)
        }
        segmentControl.sizeToFit()
        segmentControl.addTarget(self, action: #selector(changeWeek(segment:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        navigationItem.titleView = segmentControl
        
        
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
        
        multiScroll.multiDelegate = self
        
        
        multiScroll.go(toPageOfScrollView: weekControl.currentDay)
        multiScroll.pageControl.currentPage = weekControl.currentDay
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        weekControl.currentDay = Date().dayOfWeek() ?? 0
    }
    
    
    func setupMultiScroll() {
        multiScroll = MultiDirectionOrganizedScroll(countOfPages: 6,
                                                    withFrame: CGRect(x: view.center.x,
                                                                     y: view.center.y,
                                                                     width: SizeEntity.kScreenWidth,
                                                                     height: SizeEntity.kScreenHeight/2),
                                                    andStyle: .default)
        multiScroll.delegate = self
        
        multiScroll.translatesAutoresizingMaskIntoConstraints = false
        multiScroll.isPageControlActive = true
        view.addSubview(multiScroll)
    }
    
    func setupWeekControl() {
        weekControl = WeekControl(frame: CGRect(x: 0, y: SizeEntity.kScreenHeight-SizeEntity.kBottomConstraint, width: SizeEntity.kScreenWidth, height: SizeEntity.kBottomConstraint))
        self.weekControl.weekDelegate = self
        
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

                self.currentWeek = self.fullCurriculum?.currentWeek ?? CurriculumWeek()
                self.currentWeek = removeEmptyPares(arr: self.currentWeek)
                
                self.nextWeek = self.fullCurriculum?.nextWeek ?? CurriculumWeek()
                self.nextWeek = removeEmptyPares(arr: self.nextWeek)

                
                self.multiScroll.data = self.currentWeek
                
                
//                self.multiScroll.reloadData()
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
    
    
    @objc func changeWeek(segment: UISegmentedControl) {
        self.multiScroll.data = segment.selectedSegmentIndex == 0 ? currentWeek : nextWeek
    }
}
