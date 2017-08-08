//
//  InfoViewController.swift
//  waterapp
//
//  Created by ctslin on 08/08/2017.
//  Copyright © 2017 airfont.com. All rights reserved.
//

import UIKit
import SwiftEasyKit
import ObjectMapper

class InfoViewController: DefaultViewController{
  var v = UIView()
  var label = UILabel(text: "抽風機開關")
  var fanSwitch = UISwitch()
  var browser = UIWebView()
  
  var data: Setting! { didSet {
    fanSwitch.on = data.fanStatus!
    }}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titled("廠務環控智能管理系統", token: "INFO")
  }
  
  override func layoutUI() {
    super.layoutUI()
    enableCloseBarButtonItem()
    view.layout([v.layout([label, fanSwitch]), browser])
  }
  
  override func styleUI() {
    super.styleUI()
    label.styled().larger(2)
    v.backgroundColored(UIColor.lightGrayColor().lighter(0.25))
    browser.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.jsene.com/Fooyin/IAQ/")!))
  }
  
  override func bindUI() {
    super.bindUI()
    fanSwitch.addTarget(self, action: #selector(switchChanged), forControlEvents: .ValueChanged)
    //    let jsCommand = NSString.localizedStringWithFormat("document.body.style.zoom = 1.0")
    //    browser.stringByEvaluatingJavaScriptFromString(jsCommand as String)
    browser.scalesPageToFit = true
    browser.contentMode = .ScaleAspectFill
    
    API.get("/settings") { (response) in
      switch response.result {
      case .Success(let value):
        self.data = Setting(JSON: value as! [String: AnyObject])!    
        self.fanSwitch.on = self.data.fanStatus!
      case .Failure(let error):
        _logForUIMode(error.localizedDescription)
      }
    }
  }
  
  func switchChanged() {
    data.fanStatus = fanSwitch.on
    API.request(.PUT, url: "/settings/\(data.id!)", parameters: ["setting": data.toJSON()]) { (response) in
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    v.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 50)
    label.anchorAndFillEdge(.Left, xPad: 10, yPad: 10, otherSize: view.width() - 100)
    fanSwitch.alignToTheRightOf(label, matchingCenterWithLeftPadding: 10, width: 100, height: label.height)
    
    browser.alignUnder(v, centeredFillingWidthAndHeightWithLeftAndRightPadding: 0, topAndBottomPadding: 0)
  }
}

class Setting: Mappable {
  var id: Int?
  var fanStatus: Bool?
  func mapping(map: Map) {
    id <- map["id"]
    fanStatus <- map["fan_status"]
  }
  required init?(_ map: Map) {
    
  }
}