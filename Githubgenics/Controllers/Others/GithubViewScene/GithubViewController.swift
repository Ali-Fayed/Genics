//
//  GithubViewController.swift
//  Githubgenics
//
//  Created by Ali Fayed on 16/03/2021.
//
import UIKit
import WebKit

class GithubViewController : UIViewController, WKNavigationDelegate {

    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    public var completetionHandler: ((Bool) -> Void)?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(webView)
         let url = "https://github.com/"
        let fileUrl = URL(string: url)
        webView.load(URLRequest(url: fileUrl!))
        
        navigationItem.rightBarButtonItems =
            [ UIBarButtonItem(title: ">", style: .plain, target: self, action: #selector(goForward)),
             UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(goBack))]
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(goForward(recognizer:)))
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(goBack(recognizer:)))
        swipeLeftRecognizer.direction = .left
        swipeRightRecognizer.direction = .right

        webView.addGestureRecognizer(swipeLeftRecognizer)
        webView.addGestureRecognizer(swipeRightRecognizer)

    }
    
    @objc func goForward (recognizer: UISwipeGestureRecognizer) {
        if (recognizer.direction == .left) {
              if webView.canGoForward {
                  webView.goForward()
              }
        }
        HapticsManger.shared.selectionVibrate(for: .light)
    }
    
    @objc func goBack (recognizer: UISwipeGestureRecognizer) {
        if (recognizer.direction == .right) {
               if webView.canGoBack {
                   webView.goBack()
               }
           }
        HapticsManger.shared.selectionVibrate(for: .light)
    }
    
    @objc func refresh () {
        webView.reload()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    
}
