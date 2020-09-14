//
//  ViewPresenter.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

protocol ViewPresentable: class {
    
    func initialization()
    func deinitialization()
    func attach(view: ViewProtocol)
    func viewDidAttach()
    func detachView()
    func viewDidDetach()
    
}

// MARK: - Default implementations

extension ViewPresentable {
    
    func initialization() {}
    
    func deinitialization() {}
    
    func attach(view: ViewProtocol) {}
    
    func viewDidAttach() {}
    
    func detachView() {}
    
    func viewDidDetach() {}
    
}

class ViewPresenter: ViewPresentable {
    
    weak var view: ViewProtocol?
    
    // MARK: - PresenterProtocol
    
    func initialization() {
        Logger.log(sender: self, message: "Presenter attached")
    }
    
    func deinitialization() {
        Logger.log(sender: self, message: "Presenter detached")
    }
    
    func attach(view: ViewProtocol) {
        self.view = view
        viewDidAttach()
        Logger.log(sender: self, message: "View \(type(of: view)) attached")
    }
    
    func viewDidAttach() {}
    
    func detachView() {
        view = nil
        viewDidDetach()
        Logger.log(sender: self, message: "View detached")
    }
    
    func viewDidDetach() {}
    
}

