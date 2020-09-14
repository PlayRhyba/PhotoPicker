//
//  InstagramAuthorizationWindow.swift
//  InstagramClient
//
//  Created by Oleksandr Snigurskyi on 08.09.20.
//  Copyright © 2020 Oleksandr Snigursky. All rights reserved.
//

import WebKit
import SnapKit

protocol InstagramAuthorizationWindowDelegate: class {
    
    func authorizationWindow(_ window: InstagramAuthorizationWindow,
                             didRedirect request: URLRequest,
                             decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    
    func authorizationWindow(_ window: InstagramAuthorizationWindow,
                             didFail error: Error)
    
    func didCancelAuthorizationWindow(_ window: InstagramAuthorizationWindow)
    
}

final class InstagramAuthorizationWindow: UIViewController {
    
    weak var delegate: InstagramAuthorizationWindowDelegate?
    private let requestURL: URL
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: webConfiguration)
        view.navigationDelegate = self
        view.backgroundColor = .white
        view.scrollView.contentInsetAdjustmentBehavior = .always
        
        return view
    }()
    
    private lazy var cancelButton = UIButton.makeBarButton(title: "Cancel",
                                                           titleColor: .black,
                                                           target: self,
                                                           action: #selector(cancel))
    
    // MARK: - Initialization
    
    init(requestURL: URL) {
        self.requestURL = requestURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("will never happen")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.load(URLRequest(url: requestURL))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.stopLoading()
    }
    
}

// MARK: - WKNavigationDelegate

extension InstagramAuthorizationWindow: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error) {
        guard !(error as NSError).isCancelledActionError else { return }
        
        delegate?.authorizationWindow(self, didFail: error)
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        delegate?.authorizationWindow(self,
                                      didRedirect: navigationAction.request,
                                      decisionHandler: decisionHandler)
    }
    
}

// MARK: - Actions

@objc
private extension InstagramAuthorizationWindow {
    
    func cancel() {
        delegate?.didCancelAuthorizationWindow(self)
    }
    
}

// MARK: - Private

private extension InstagramAuthorizationWindow {
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    func setupWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
}

private extension NSError {
    
    var isCancelledActionError: Bool {
        return domain == "NSURLErrorDomain" && code == -999
    }
    
}

