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

class Inspection: Mappable {
  var id: Int?
  var taskId: Int?
  var categoryId: Int?
  var value: Float?
  
  func mapping(map: Map) {
    id <- map["id"]
    taskId <- map["task_id"]
    categoryId <- map["category_id"]
    value <- map["value"]
  }
  
  required init?(_ map: Map) { }
}

class Category: SelectOption {
  
  var formNode: Bool?
  override func mapping(map: Map) {
    super.mapping(map)
    formNode <- map["form_node"]
  }
  
  class func list(url: String!, onComplete: (categories: [Category]) -> ()) {
    API.get(url) { (response) in
      switch response.result {
      case .Success(let value):
        var items = [Category]()
        if let jsons = value as? [[String: AnyObject]] {
          jsons.forEach({ json in
            let item = Category(JSON: json)!
            items.append(item)
          })
          onComplete(categories: items)
        }
      case .Failure(let error):
        _logForUIMode(error.localizedDescription)
      }
    }
  }
}

class CategoriesViewController: Scrollable2ViewController {
  
  var task: Task! { didSet { }}
  
  var url: String! { didSet {
    Category.list (url) { (items) in
      self.collectionData = items
    }
    }
    
  }
  
  init(task: Task!, url: String!) {
    super.init(nibName: nil, bundle: nil)
    ({ self.task = task })()
    ({ self.url = url })()
  }
  
  
  class CategoryButton: DefaultView {
    
    var task: Task!
    var button = UIButton()
    
    var data: Category! { didSet {
      button.text(data.name)
      }
    }
    
    init(task: Task, data: Category!) {
      super.init(frame: CGRectZero)
      ({ self.task = task })()
      ({ self.data = data })()
    }
    
    override func layoutUI() {
      super.layoutUI()
      layout([button])
    }
    override func styleUI() {
      super.styleUI()
      button.colored(UIColor.blackColor()).bordered(1, color: UIColor.lightGrayColor().CGColor).radiused(1).backgroundColored(UIColor.whiteColor().lighter())
    }
    
    override func bindUI() {
      super.bindUI()
      button.whenTapped {
        if let url = self.data.children_url {
          if self.data.formNode == true {
            self.pushViewController(CategoryFormViewController(task: self.task, url: url))
          } else {
            let vc = CategoriesViewController(task: self.task, url: url)
            self.pushViewController(vc)
          }
        } else {
          prompt("沒有子目錄")
        }
        
      }
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      button.fillSuperview()
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  }
  
  var buttons = [CategoryButton]()
  
  var collectionData = [Category]() {
    didSet {
      collectionData.forEach({ (item) in
        self.buttons.append(CategoryButton(task: task, data: item))
      })
      layoutUI()
      styleUI()
      bindUI()
      viewDidLayoutSubviews()
      if collectionData.first?.family?.count > 1 {
        let name = collectionData.first?.breadcrumb
        titled(name!, token: "HOME")
      } else {
        titled("WaterApp", token: "HOME")
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
  }
  
  override func layoutUI() {
    super.layoutUI()
    contentView.layout(buttons)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let padding = 5.cgFloat
    let h = 50.cgFloat
    let xPad: CGFloat = padding
    //    let count = buttons.count.cgFloat
    let yPad: CGFloat = padding//(screenHeight() - (count * h) - count * padding) / 3
    verticalLayout(buttons, heights: buttons.map({_ in return h}), padding: padding, xPad: xPad, yPad: yPad, alignUnder: nil)
    if buttons.count > 0 { contentView.setLastSubiewAs(buttons.last!) }
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}


