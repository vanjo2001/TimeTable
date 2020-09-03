//
//  RequestKBP.swift
//  NewSchedule
//
//  Created by Тимофей Лукашевич on 2/23/20.
//  Copyright © 2020 IvanLyuhtikov. All rights reserved.
//
import UIKit


//typealias CurriculumPare = (pairName: String, teacher: String, room: String, group: String, numberPare: String)?
typealias CurriculumDay = [CurriculumPare]
typealias CurriculumWeek = [CurriculumDay]
typealias CurriculumBothWeeks = (currentWeek: CurriculumWeek, nextWeek: CurriculumWeek)


fileprivate class DayFilling {
    
    var isPairExistByNumber: [Bool] = Array(repeating: true, count: 7)
    var pairAtNumber: [CurriculumPare] = [] //Array(repeating: CurriculumDay("", "", "", "", ""), count: 7)
    
    init() {
        for _ in 1...7 {
            let el:CurriculumPare = CurriculumPare()
            pairAtNumber.append(el)
        }
    }
}


class RequestKBP {
    
    static private let dispGroup = DispatchGroup()
    static private var curriculum: [CurriculumPare]? = nil
    static var preparedCurriculum: CurriculumBothWeeks = (currentWeek: [], nextWeek: [])
    static var pointsOfChanges: [String]? = nil
    
    
    private init() {}
    
    
    class private func preparingCurriculum() {
        var oneWeek: CurriculumWeek = []
        var oneDay: CurriculumDay = []
        
        var index = 0
        
        for pare in RequestKBP.curriculum ?? [] {
            
            index += 1
            oneDay.append(pare)
            
            if index == 7 {
                oneWeek.append(oneDay)
                oneDay = []
                index = 0
            }
            
            if oneWeek.count == 6 {
                if (preparedCurriculum.currentWeek.isEmpty) {
                    preparedCurriculum.currentWeek = oneWeek
                } else {
                    preparedCurriculum.nextWeek = oneWeek
                }
                oneWeek = []
            }
            
        }
        
        
    }
    
    
    class func getData(stringURL: String, closure: @escaping (_ input: CurriculumBothWeeks?) -> ()) {
 
        RequestKBP.curriculum = []
        dispGroup.enter()
        guard let url = URL(string: stringURL) else { return }
        
        _ = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            var htmlContext = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            let curiculum = RequestKBP.parseEmptyPair(htmlData: htmlContext)
            
            htmlContext = htmlContext?.replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
            RequestKBP.pointsOfChanges = RequestKBP.getChangeOfPairSwitcher(htmlContext: htmlContext)
            htmlContext = searchByRegularExpresion(regularEx: #"<table\s+style=\"padding-top:10px;\">.+<\/table>"#, str: htmlContext ?? "")[0]
            
            
            var dayCarricullum: [String] = []
            var pairsArray: [CurriculumPare] = []
            for weekNuber in 1...2 {
                
                let weekLater = weekNuber == 1 ? "l":"r"
                for dayNumber in 1...6 {
                    
                    let reg = "class=\"pair \(weekLater)w_\(dayNumber)( added)?" + #"((\s)week week\d)?\">.{1,1000}<!"#
                    dayCarricullum = searchByRegularExpresion(regularEx: reg, str: htmlContext ?? "")
                    
                    dayCarricullum = dayCarricullum.map({str in str
                                .replacingOccurrences(of: #"class=\"pair (l|r)w_\d(\s*added)?\">"#, with: "  ", options: .regularExpression)
                                .replacingOccurrences(of: #"<div class=\"((left-column)|(right-column))\">"#, with: "  ", options: .regularExpression)
                                .replacingOccurrences(of: #"<div class=\"((subject)|(teacher)|(group)|(place))\">"#, with: "  ", options: .regularExpression)
                                .replacingOccurrences(of: #"<a href=\"\?cat=((subject)|(teacher)|(group)|(place))&amp;id=(\d{1,4})?\">"#, with: "  ", options: .regularExpression)
                                .replacingOccurrences(of: #"((</a>)|(</div>)|(</span>)|(</td>)|(<td>)|(\">)|(<div class=\" )|(<!)|(</tr>)|(<tr>))"#, with: "", options: .regularExpression)
                                .replacingOccurrences(of: #"(<span )?class=\"((group-span)|(extra)|(group-span))(\")?>"#, with: "  ", options: .regularExpression)
                                .replacingOccurrences(of: #"((<div class=\"extra)|(<span class=\"group-span)|(-- pair-number=\"\d\" day=\"\d\" --> <div class=\"empty-pair))"#, with: "", options: .regularExpression)
                                .replacingOccurrences(of: #"(<td class=\"number\d)|(class=\"pair (l|r)w_\d week week\d)|(class=\"pair lw_1 added )"#, with: "", options: .regularExpression)
                        })
                    
                    for dayString in dayCarricullum {
                        
                        var copy = dayString
                        var el: CurriculumPare = CurriculumPare()
                        el.room = copy.replacingOccurrences(of: #"^\s*.+\s*\w-\d+\s*"#, with:"" , options : .regularExpression)
                                       .replacingOccurrences(of: #"\s+"#, with:"" , options : .regularExpression).replacingOccurrences(of: #"\d\s*неделя"#, with:"" , options : .regularExpression)
                        
                        copy = copy.replacingOccurrences(of: el.room, with:"" , options : .regularExpression)
                                   .replacingOccurrences(of: #"\d\s*неделя"#, with:"" , options : .regularExpression)
                        
                        el.group = searchByRegularExpresion(regularEx: #"\w-\d+"#, str: copy)[0]
                            .replacingOccurrences(of: #"\s+"#, with:"" , options : .regularExpression)
                        
                        
                        copy = copy.replacingOccurrences(of: el.group, with:"" , options : .regularExpression)
                        
                        el.pairName = searchByRegularExpresion(regularEx: #"^\s*\S+"#, str: copy)[0].replacingOccurrences(of: #"\s{2,}"#, with: " ", options: .regularExpression).replacingOccurrences(of: #"\d\s*неделя"#, with:"" , options : .regularExpression)
                        
                        copy = copy.replacingOccurrences(of: #"^\s*\S+"#, with:"" , options : .regularExpression)
                        
                        el.teacher = copy.replacingOccurrences(of: #"\s{2,}"#, with: " ", options: .regularExpression).replacingOccurrences(of: #"\d\s*неделя"#, with:"" , options : .regularExpression)
                        
                        pairsArray.append(el)
                        
                    }
                     
                }
               
            }
            
            var count = 0
            for (ind, _) in curiculum.enumerated() {
                for (pairIndex, pairExist) in curiculum[ind].isPairExistByNumber.enumerated() {
                    if pairExist {
                        
                        curiculum[ind].pairAtNumber[pairIndex] = pairsArray[count]
                        count += 1
                    }
                }
            }
            
            for el in curiculum {
                RequestKBP.curriculum?.append(contentsOf: el.pairAtNumber)
            }
            
            var pairNumberToPust = 1
            for (index, _) in RequestKBP.curriculum!.enumerated() {
                pairNumberToPust = pairNumberToPust > 7 ? 1 : pairNumberToPust
                RequestKBP.curriculum![index].numberPare = String(pairNumberToPust)
                pairNumberToPust += 1
            }
            
            preparingCurriculum()
            
            closure(RequestKBP.preparedCurriculum);
            
            dispGroup.leave()
            
        }.resume()
        
    }
    
    
    fileprivate class func parseEmptyPair(htmlData: String?) -> [DayFilling] {
        
        var dataArr = searchByRegularExpresion(regularEx:#"(<td class=\"number\">\d</td>)|(\s+<td>\s+<!-- pair-number=\"\d\" day=\"\d\" -->\s+<div class=\"empty-pair\"></div>\s+</td>)|(<div class=\"pair (r|l)w_\d week week\d removed\">)"# , str: htmlData ?? "")

        dataArr = dataArr.map({ $0
            .replacingOccurrences(of: #"<td>\s+<!-- pair-number=\"\d"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"(\" day=\")|(\" -->\s+)"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"<div class="empty-pair"></div>\s+</td>"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"(<div class=\"pair (r|l)w_)|( week week\d removed\">)"#, with: "         ", options: .regularExpression)
            .replacingOccurrences(of: #"(<td class=\"number\">)|(</td>)"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"\s+"#, with: "          ", options: .regularExpression)
        })
        
        var pairNumber = 0
        var CR: [DayFilling] = []
        for _ in 1...12 {
            CR.append(DayFilling())
        }
        var predNumber:String = ""
        
        for (elIndex, _) in dataArr.enumerated() {
            if let _ = dataArr[elIndex].range(of: #"^\d"#, options: .regularExpression) {
                
                if predNumber != dataArr[elIndex]{
                    pairNumber += 1
                    predNumber = dataArr[elIndex]
                }
                
            } else {
                
                var dayNumber = Int(dataArr[elIndex].replacingOccurrences(of: #"\s+"#, with: "", options: .regularExpression)) ?? 0
                dayNumber -= 1
                var tempPairNumber = pairNumber
                if pairNumber > 7 {
                    
                    dayNumber += 6
                    tempPairNumber -= 7
                }
                    tempPairNumber -= 1
                    CR[dayNumber].isPairExistByNumber[tempPairNumber] = false
                }
            
        }
        return CR;
    }
    
    
    private class func getChangeOfPairSwitcher(htmlContext: String? ) -> [String] {
        
        var result = [String]()
        var htmlDataOfChanges = searchByRegularExpresion(regularEx: #"<tr class=\"zamena\">(\s*<th>.{1,200}</th>){7}\s*</tr>"# , str: htmlContext ?? "")
            
        htmlDataOfChanges = htmlDataOfChanges.map({ (str) in str
                .replacingOccurrences(of: #"<tr class=\"zamena\">\s*<th>&nbsp;</th>"#, with: "", options: .regularExpression)
                .replacingOccurrences(of: #"<th></th>\s*</tr>\s*"#, with: "", options: .regularExpression)
                .replacingOccurrences(of: #"<label><input type=\"checkbox\" class=\"ch_moves\" id=\"lw_\d\" checked=\"checked\" />"#, with: "", options: .regularExpression)
                .replacingOccurrences(of: #"</label></th>"#, with: "", options: .regularExpression)
                
        })
         
        for str in htmlDataOfChanges {
            result += searchByRegularExpresion(regularEx: #"<th>\s*(Замен нет|Показать замены)?\s*</th>"#, str: str)
        }
        
        result = result.map({ str in str
                .replacingOccurrences(of: #"<th> Замен нет </th>"#, with: "расписание установленно : замен нет", options: .regularExpression)
                .replacingOccurrences(of: #"<th>  Показать замены </th>"#, with: "расписание установленно : есть замены", options: .regularExpression)
                .replacingOccurrences(of: #"<th> </th>"#, with: "нет точного рассписания", options: .regularExpression)
                
        })
        return result
    }
    
}

