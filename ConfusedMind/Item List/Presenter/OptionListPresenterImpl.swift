//
//  ItemPresenterImpl.swift
//  ConfusedMind
//
//  Created by Satish Birajdar on 2017-09-25.
//  Copyright © 2017 SBSoftwares. All rights reserved.
//

import Foundation

class OptionListPresenterImpl: OptionListPresenter {
    
    let options: [Option] = []
    var optionPresenterView: OptionListPresenterView!
    init() {
        
    }
    
    func attachView(view: OptionListPresenterView){
        optionPresenterView = view
        optionPresenterView.loadOptionList(options: self.options)
    }
}
