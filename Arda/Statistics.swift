//
//  Stats.swift
//  Arda
//
//  Created by Jordan on 2/15/20.
//  Copyright © 2020 Jordan. All rights reserved.
//

import Foundation

let CHANGE_LIMIT=10

class StatisticItem: ObservableObject {
    let name: String
    @Published var startValue: Int
    @Published var modifier: Int

    init(name: String, startValue: Int, modifier: Int) {
        self.name = name
        self.startValue = startValue
        self.modifier = modifier
    }
        
    func increasable() -> Bool {
        return self.modifier < CHANGE_LIMIT
    }

    func decreasable() -> Bool {
        return abs(self.modifier) < CHANGE_LIMIT
    }

}

class Statistics: ObservableObject, CustomStringConvertible {
    let statisticsNames = ["Strength", "Agility", "Constitution", "Intelligence", "Intuition", "Presence", "Appearance"]

    @Published var statList: [StatisticItem] {
        didSet {
            // let encoder = JSONEncoder()
            // if let encoded = try? encoder.encode(statList) {
            //    UserDefaults.standard.set(encoded, forKey: "statList")
            // }
        }
    }

    var description: String {
        var stringOutput = ""
        for statisticItem in statList {
            stringOutput.append("\(statisticItem.name): \(statisticItem.startValue + statisticItem.modifier)\n")
        }
        return stringOutput
    }
    
    init() {
        self.statList = [];
        for statisticsName in statisticsNames {
            self.statList.append(StatisticItem(name: statisticsName, startValue:  Int.random(in: 20 ... 100), modifier: 0))
        }
    }
    
    func reroll() -> Void {
        for statisticItem in statList {
            statisticItem.startValue = Int.random(in: 20 ... 100)
            statisticItem.modifier = 0
        }
    }
}
