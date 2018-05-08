//
//  ChartSpinnerPresenterContract.swift
//  ConfusedMind
//
//  Created by Satish Birajdar on 2017-10-30.
//  Copyright © 2017 SBSoftwares. All rights reserved.
//

import Foundation
import CoreData

protocol ChartSpinnerPresenterView {
    func setChart(dataPoints: [NSManagedObject])
    func spinAction()
}

protocol ChartSpinnerPresenter {
    func attachView(view: ChartSpinnerPresenterView)
}
