//
//  ScreenPresenter.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import Combine

protocol ScreenPresentable: ViewPresentable {
    
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
    
}

class ScreenPresenter: ViewPresenter, ScreenPresentable {
    
    var cancelBag = Set<AnyCancellable>()
    
    // MARK: - ScreenPresentable
    
    func viewDidLoad() {}
    
    func viewWillAppear() {}
    
    func viewDidAppear() {}
    
    func viewWillDisappear() {}
    
    func viewDidDisappear() {}
    
}
