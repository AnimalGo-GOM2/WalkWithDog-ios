//
//  WebViewController.swift
//  animalgo
//
//  Created by 이승아 on 2021/11/02.
//  Copyright © 2021 rocateer. All rights reserved.
//


import UIKit
import WebKit
import Defaults
import DropDown

enum WebType: String {
  case Terms0 = "terms_web_view_v_1_0_0/terms_detail?type=1" // 이용약관
  case Terms1 = "terms_web_view_v_1_0_0/terms_detail?type=0" // 개인정보
  case Terms2 = "terms_web_view_v_1_0_0/terms_detail?type=4" // 위치 서비스
  case Terms3 = "terms_web_view_v_1_0_0/terms_detail?type=3" // 마케팅
}


@objc protocol ResultProtocol {
  @objc optional func authProtocol(member_name: String, member_phone: String, member_gender: String, member_birth: String, auth_code: String)
}


class WebViewController: RocateerViewController {
  //-------------------------------------------------------------------------------------------
  // MARK: - IBOutlets
  //-------------------------------------------------------------------------------------------
  @IBOutlet weak var webWrapView: UIView!
  @IBOutlet weak var titleWrapView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local Variables
  //-------------------------------------------------------------------------------------------
  var webView = WKWebView()
  var webType = WebType.Terms0
  let dropDown = DropDown()
  let termsList = ["이용약관", "개인정보 취급방침", "위치정보 이용약관"]

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
    self.titleWrapView.addBorderBottom(size: 1, color: UIColor(named: "EAE8E5")!)

    switch self.webType {
    case .Terms0:
      self.navigationItem.title = "이용약관"
      self.titleLabel.text = "이용약관"
    case .Terms1:
      self.navigationItem.title = "개인정보 취급방침"
      self.titleLabel.text = "개인정보 취급방침"
    case .Terms2:
      self.navigationItem.title = "위치정보 이용약관"
      self.titleLabel.text = "위치정보 이용약관"
    case .Terms3:
      break
    }
    self.titleWrapView.addTapGesture { recognizer in
      self.dropDown.show()
      self.dropDown.dataSource = self.termsList
      self.customizeDropDown(self)
      self.dropDown.reloadAllComponents()
    }
  }
  
  override func initRequest() {
    super.initRequest()
  }
  
  //-------------------------------------------------------------------------------------------
  // MARK: - Local method
  //-------------------------------------------------------------------------------------------
  /// 드롭다운 세팅
  /// - Parameter sender: self
  func customizeDropDown(_ sender: AnyObject) {
    DropDown.appearance().cornerRadius = 4
    DropDown.appearance().direction = .bottom
    DropDown.appearance().shadowColor = UIColor(named: "707070")!
    DropDown.appearance().cellHeight = 44
    dropDown.width = self.titleWrapView.frame.width

    self.dropDown.anchorView = self.titleWrapView
    self.dropDown.bottomOffset = CGPoint(x: 0, y: 50)
    self.dropDown.shadowOpacity = 1
    self.dropDown.shadowOffset = CGSize(width: 0, height: 0)
    
    self.dropDown.backgroundColor = .white
    self.dropDown.dataSource = self.termsList
    self.dropDown.cellNib = UINib(nibName: "TextDropDownCell", bundle: nil)
    
    self.dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
      guard let cell = cell as? TextDropDownCell else { return }
      cell.titleLabel.text = item
      cell.optionLabel.isHidden = true
    }
    
    self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
      self.titleLabel.text = self.termsList[index]
      self.navigationItem.title = self.termsList[index]
      
      if index == 0 {
        self.webType = .Terms0
      }else if index == 1 {
        self.webType = .Terms1
      }else if index == 2 {
        self.webType = .Terms2
      }else if index == 3 {
        self.webType = .Terms3
      }
      
      let urlstring = "\(baseURL)\(self.webType.rawValue)"

      let url = URL(string: urlstring)!
      
      let request = URLRequest(url: url)
      self.webView.load(request)
      
    }
  }
  
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
    
    let urlstring = "\(baseURL)\(self.webType.rawValue)"

    let url = URL(string: urlstring)!
    
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
extension WebViewController: WKScriptMessageHandler {
  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    log.debug(message.body)
   
  }
}

//-------------------------------------------------------------------------------------------
// MARK: - WKNavigationDelegate
//-------------------------------------------------------------------------------------------
extension WebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
    let reqUrl = navigationAction.request.url?.absoluteString ?? ""
    log.debug("reqUrl : \(String(describing: reqUrl))")
    
    
    decisionHandler(.allow)
  }
  
}


//-------------------------------------------------------------------------------------------
// MARK: - WKUIDelegate
//-------------------------------------------------------------------------------------------
extension WebViewController: WKUIDelegate {
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

