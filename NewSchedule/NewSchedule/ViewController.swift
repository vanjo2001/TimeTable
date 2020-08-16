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
    
    var fullCurriculum: CurriculumBothWeeks?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        multiScroll = MultiDirectionOrganizedScroll(countOfPages: 6,
                                                    withFrame: CGRect(x: view.center.x,
                                                                     y: view.center.y,
                                                                     width: 100,
                                                                     height: 100),
                                                    andStyle: .default)
        
        multiScroll.translatesAutoresizingMaskIntoConstraints = false
        multiScroll.backgroundColor = .lightGray
        view.addSubview(multiScroll)
        
//        let queue = DispatchQueue(label: "vanjo_gueue")
//        queue.async {
//            RequestKBP.getData(stringURL: "https://kbp.by/rasp/timetable/view_beta_kbp/?cat=group&id=31") { (data) in
//                self.fullCurriculum = data
//
//                self.current = self.fullCurriculum?.currentWeek ?? CurriculumWeek()
//                self.current = removeEmptyPares(arr: self.current)
//
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            }
//        }
//        
//        var dictionary = getLinkDictionary()
//        print(dictionary["Т-795"])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.multiScroll.multiDelegate = self
        
        setupLayout()
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
