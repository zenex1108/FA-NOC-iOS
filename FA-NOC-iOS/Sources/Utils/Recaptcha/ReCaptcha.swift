//
//  ReCaptcha.swift
//  FA-NOC-iOS
//
//  Created by joowon on 11/11/18.
//  Copyright © 2018 zenex. All rights reserved.
//

import Foundation
import SnapKit
import WebKit
import PKHUD

@objc protocol ReCaptchaDelegate {
    func reCaptchaDidLoad(_ view: UIView)
    func reCaptchaDidSolved(_ view: UIView, _ token: String)
    func reCaptchaWillTest(_ view: UIView)
    func reCaptchaError(_ view: UIView)
}

class ReCaptcha: UIView {
    
    weak var delegate: ReCaptchaDelegate?

    var webView: WKWebView!
    
    var tapRecognizer: UITapGestureRecognizer?
    
    var readyState: String = "loading"

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initWebView() {

        let wkController = WKUserContentController()
        wkController.add(self, name: "reCaptcha")
        wkController.addUserScript(readScript())

        let wkConfig = WKWebViewConfiguration()
        wkConfig.userContentController = wkController

        webView = WKWebView(frame: frame, configuration: wkConfig)

        guard let webView = webView else {
            return
        }

        webView.navigationDelegate = self;
        webView.isHidden = false
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        webView.clipsToBounds = false
        webView.scrollView.isScrollEnabled = false

        webView.load(URLRequest(url: FaUrl.login))
    }

    func readScript() -> WKUserScript {
        let scriptSource = try! String(contentsOfFile: Bundle.main.path(forResource: "reCaptcha", ofType: "js")!)
        return WKUserScript(source: scriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
    }
}


extension ReCaptcha: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if let args = message.body as? [String] {
            
            switch args[0] {
            case "reCaptchaDidLoad":
                reCaptchaDidLoad()

            case "reCaptchaDidSolved":
                reCaptchaDidSolved(response: args[1])

            case "reCaptchaDidExpired":
                reCaptchaDidExpired()

            case "reCaptchaError":
                reCaptchaError()
                
            case "readyState":
                readyState = args[1]
                
            default:
                print("args[0]: \(args[0])")
            }
        }
    }

    func reCaptchaDidLoad() {
        guard let webView = webView else {
            return
        }
        
        addSubview(webView)
        webView.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        registerTapGesture()
        
        print("ReCaptcha loaded")
        
        delegate?.reCaptchaDidLoad(self)
        
        webView.isHidden = false
    }

    func reCaptchaDidSolved(response: String) {
        
        print("ReCaptcha solved")
        
        unRegisterTapGesture()
        
        delegate?.reCaptchaDidSolved(self, response)
    }

    func reCaptchaDidExpired() {
        
        print("ReCaptcha expired")
        
        registerTapGesture()
    }
    
    func reCaptchaError() {
        
        print("ReCaptcha error")
        
        unRegisterTapGesture()
        
        delegate?.reCaptchaError(self)
    }

    func registerTapGesture(){
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        tapRecognizer?.delegate = self
        tapRecognizer?.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(tapRecognizer!)
    }
    
    func unRegisterTapGesture(_ allowInteraction: Bool = false){
        
        isUserInteractionEnabled = allowInteraction
        if let gesture = tapRecognizer {
            removeGestureRecognizer(gesture)
        }
    }
    
    @objc func handleSingleTap() {
        
        unRegisterTapGesture(true)

        let when = DispatchTime.now() + 1.2
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.delegate?.reCaptchaWillTest(self)
        }
    }
}


extension ReCaptcha: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ReCaptcha: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        HUD.show(.progress)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if readyState != "complete" {
            Thread.sleep(forTimeInterval: 2.5)
        }
        HUD.hide(afterDelay: 0.25)
    }
}
