//
//  AuthViewController.swift
//  animalgo
//
//  Created by rocateer on 2021/12/01.
//  Copyright © 2021 rocateer. All rights reserved.
//


import UIKit
import WebKit
import Defaults

protocol AuthProtocol {
  func authProtocol(member_name: String, member_phone: String, member_gender: String, member_birth: String, auth_code: String)
}

class AuthViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var webWrapView: UIView!
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var webView = WKWebView()
  var delegate: AuthProtocol?
  
  //-------------------------------------------------------------------------------------------
  // MARK: - override method
  //-------------------------------------------------------------------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func initLayout() {
    super.initLayout()
    self.initWebView()
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  func initWebView() {
    self.view.layoutIfNeeded()
    self.view.setNeedsLayout()
    
    let configuration = WKWebViewConfiguration()
    configuration.userContentController.add(self, name: "native")
    
    
    let wkWebViewPreferences = WKWebViewConfiguration()
    
    
    let wkPreferences = WKPreferences()
    wkPreferences.javaScriptCanOpenWindowsAutomatically = true
    wkPreferences.javaScriptEnabled = true
    wkWebViewPreferences.preferences = wkPreferences
    
    let window = UIApplication.shared.windows.first {$0.isKeyWindow}
    let statusHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
    let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
    
    let navigationHeight = statusHeight + self.navigationController!.navigationBar.frame.height
    
    self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.webWrapView.bounds.width, height: self.webWrapView.bounds.height - bottomPadding - navigationHeight).integral, configuration: configuration)
    self.webWrapView.addSubview(self.webView)
    
    
    self.webView.scrollView.showsHorizontalScrollIndicator = false
    self.webView.scrollView.showsVerticalScrollIndicator = false
    
    let url = URL(string: "\(baseURL)nice_web_view/member_auth?member_idx=")!
    
    if UIApplication.shared.canOpenURL(url) {
      let request = URLRequest(url: url)
      self.webView.load(request)
      
    } else {
      let defaultURL = URL(string: "https://m.naver.com")!
      let request = URLRequest(url: defaultURL)
      self.webView.load(request)
      
    }
    
    
    self.webView.uiDelegate = self
    self.webView.navigationDelegate = self
    
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - IBActions
  //-------------------------------------------------------------------------------------------
  
}
//-------------------------------------------------------------------------------------------
// MARK: - WKScriptMessageHandler
//-------------------------------------------------------------------------------------------
extension AuthViewController: WKScriptMessageHandler {
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    log.debug(message.body)
    let values: [String: String] = message.body as! Dictionary
    
    log.debug(values["member_name"] ?? "")
    log.debug(values["member_phone"] ?? "")
    log.debug(values["member_gender"] ?? "")
    log.debug(values["member_birth"] ?? "")
    log.debug(values["auth_code"] ?? "")
    
    
    let member_name = values["member_name"] ?? ""
    let member_phone = values["member_phone"] ?? ""
    let member_gender = values["member_gender"] ?? ""
    let member_birth = values["member_birth"] ?? ""
    let auth_code = values["auth_code"] ?? ""
    self.navigationController?.popViewController(animated: true)
    self.delegate?.authProtocol(member_name: member_name, member_phone: member_phone, member_gender: member_gender, member_birth: member_birth, auth_code: auth_code)
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - WKNavigationDelegate
//-------------------------------------------------------------------------------------------
extension AuthViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
    let reqUrl = navigationAction.request.url?.absoluteString ?? ""
    log.debug("reqUrl : \(String(describing: reqUrl))")
  
    decisionHandler(.allow)
  }
  
}


//-------------------------------------------------------------------------------------------
// MARK: - WKUIDelegate
//-------------------------------------------------------------------------------------------
extension AuthViewController: WKUIDelegate {
  func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
      completionHandler()
    }))
    self.present(alertController, animated: true, completion: nil)
  }
  
  func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
    alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
      completionHandler(true)
    }))
    alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in
      completionHandler(false)
    }))
    self.present(alertController, animated: true, completion: nil)
  }
  
  func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
    let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .actionSheet)
    alertController.addTextField { (textField) in
      textField.text = defaultText
    }
    alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
      if let text = alertController.textFields?.first?.text {
        completionHandler(text)
      } else {
        completionHandler(defaultText)
      }
    }))
    alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in
      completionHandler(nil)
    }))
    self.present(alertController, animated: true, completion: nil)
  }
  
}

