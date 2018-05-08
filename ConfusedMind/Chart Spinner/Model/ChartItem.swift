//
//  ChartItem.swift
//  ConfusedMind
//
//  Created by Satish Birajdar on 2018-05-06.
//  Copyright © 2018 SBSoftwares. All rights reserved.
//

import Foundation

struct ChartItem {
    let id: Int
    var visited: Bool
    var data: String
    
    init(id: Int, visited:Bool, data:String)
    {
        self.id = id
        self.visited = visited
        self.data = data
    }
}
