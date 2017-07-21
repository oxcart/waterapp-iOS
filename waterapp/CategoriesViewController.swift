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

class CategoriesViewController: Scrollable2ViewController {
  
  init(url: String!) {
    super.init(nibName: nil, bundle: nil)
    ({ self.url = url })()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var url: String! { didSet {
    SelectOption.list (url) { (items) in
      self.collectionData = items
    }
    }}
  
  class CategoryButton: DefaultView {
    var button = UIButton()
    var data: SelectOption! { didSet {
      button.text(data.name)
      }
    }
    
    init(data: SelectOption!) {
      super.init(frame: CGRectZero)
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
          let vc = CategoriesViewController(url: url)
          self.pushViewController(vc)
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
  
  var collectionData = [SelectOption]() {
    didSet {
      collectionData.forEach({ (item) in
        self.buttons.append(CategoryButton(data: item))
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
  
}


