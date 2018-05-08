//
//  OptionPresenterContract.swift
//  ConfusedMind
//
//  Created by Satish Birajdar on 2017-09-25.
//  Copyright © 2017 SBSoftwares. All rights reserved.
//

import Foundation

protocol OptionListPresenterView{
    func loadOptionList(options: [Option])
    func addNewOption()
    func deleteOption(index: Int)
}

protocol OptionListPresenter {
    func attachView(view: OptionListPresenterView)
}
