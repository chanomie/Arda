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

    let name: String
    @Published var startValue: Int
    @Published var modifier: Int
}

class Statistics: ObservableObject {
    let statisticsNames = ["Strength", "Agility", "Constitution", "Intelligence", "Intuition", "Presence", "Appearance"]
    @Published var statList: [StatisticItem]
    
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
