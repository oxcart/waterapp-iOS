//
//  HomeViewController.swift
//  waterapp
//
//  Created by ctslin on 20/07/2017.
//  Copyright © 2017 airfont.com. All rights reserved.
//

import UIKit
import SwiftEasyKit
import ObjectMapper

class HomeViewController: DefaultViewController {
  
  var buttons = [UIButton]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titled("Welcome", token: "HOME")
    Category.all { (items) in
      _logForUIMode(items.count)
      items.forEach({ (item) in
        self.buttons.append(UIButton(text: item.name!))
      })
      self.layoutUI()
      self.styleUI()
      self.viewDidLayoutSubviews()
    }
  }
  
  override func layoutUI() {
    super.layoutUI()
    view.layout(buttons)
  }
  
  override func styleUI() {
    super.styleUI()
    buttons.forEach { (button) in
      button.colored(UIColor.blackColor()).larger().bordered().radiused()
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
//    verticalLayout(buttons, heights: buttons.map({_ in return 30}))
    verticalLayout(buttons, heights: buttons.map({_ in return 50}), padding: 30, xPad: 100, yPad: 150, alignUnder: nil)
  }
  
}

class Category: SelectOption {
  class func all(onComplete: (categories: [SelectOption]) -> ()) {
    API.get(K.Api.Resource.categories) { (response) in
      switch response.result {
      case .Success(let value):
        var items = [SelectOption]()
        if let jsons = value as? [[String: AnyObject]] {
          jsons.forEach({ (json) in
            let item = Category(JSON: json)
            items.append(item!)
          })
          onComplete(categories: items)
        }
        
      case .Failure(let error):
        _logForUIMode(error.localizedDescription)
      }
    }
    
  }
}


class Category111: Mappable {
  
  var id: Int?
  var name: String!
  var options: String?
  var unit: String?
  
  class func all(id: Int? = nil, onComplete:(items: [Category]) -> ()) {
    var items = [Category]()
    API.get(K.Api.Resource.categories) { (response) in
      switch response.result {
      case .Success(let value):
        if let jsons = value as? [[String: AnyObject]] {
          jsons.forEach({ (json) in
            items.append(Category(JSON: json)!)
          })
          onComplete(items: items)
        }
      case .Failure(let error):
        _logForUIMode(error.localizedDescription)
      }
    }
  }
  
  func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    options <- map["options"]
    unit <- map["unit"]
  }
  
  required init?(_ map: Map) { }
}