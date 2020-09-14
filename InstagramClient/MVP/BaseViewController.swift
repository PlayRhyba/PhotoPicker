//
//  BaseViewController.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 11.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, ViewProtocol {
    
    var presenter: ScreenPresentable? {
        didSet {
            if let presenter = presenter {
                presenter.attach(view: self)
            } else {
                presenter?.detachView()
            }
        }
    }
    
    // MARK: - Deinitialization
    
    deinit {
        presenter?.detachView()
        presenter?.deinitialization()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.attach(view: self)
        presenter?.initialization()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.viewDidDisappear()
    }
    
}
