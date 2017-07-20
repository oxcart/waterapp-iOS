//
//  ViewController.swift
//  waterapp
//
//  Created by ctslin on 20/07/2017.
//  Copyright © 2017 airfont.com. All rights reserved.
//

import UIKit
import SwiftEasyKit

class ViewController: UIViewController {
  
  var label = UILabel(text: "WaterApp")

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    view.addSubview(label)
    label.centered().larger()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    label.anchorInCenter(width: 200, height: 100)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

