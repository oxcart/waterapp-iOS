//
//  HomeViewController.swift
//  waterapp
//
//  Created by ctslin on 22/07/2017.
//  Copyright © 2017 airfont.com. All rights reserved.
//

import UIKit
import SwiftEasyKit
import ObjectMapper


class HomeViewController: DefaultViewController {
  
  var button = UIButton(text: "開始巡檢")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func layoutUI() {
    super.layoutUI()
    view.layout([button])
  }
  
  override func styleUI() {
    super.styleUI()
    button.larger().colored(UIColor.blackColor()).bordered().radiused()
  }
  
  override func bindUI() {
    super.bindUI()
    button.whenTapped {
      Task.new({ (item) in
        _logForUIMode(item.toJSON())
        self.pushViewController(CategoriesViewController(task: item, url: K.Api.Resource.categories))
      })
      
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    button.anchorInCenter(width: 200, height: 60)
  }
  
}

class Task: Mappable {
  var id: Int?
  func mapping(map: Map) {
    id <- map["id"]
  }
  
  class func new(onComplete: (item: Task) -> ()) {
    let url = K.Api.Resource.tasks
    API.post(url) { (response) in
      switch response.result {
      case .Success(let value):
        onComplete(item: Task(JSON: value as! [String: AnyObject])!)
      case .Failure(let error):
        _logForUIMode(error.localizedDescription)
      }
    }
  }
  required init?(_ map: Map) { }
}