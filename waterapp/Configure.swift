//
//  Configure.swift
//  waterapp
//
//  Created by ctslin on 20/07/2017.
//  Copyright © 2017 airfont.com. All rights reserved.
//

import Foundation
import SwiftEasyKit

class Configure {
  init() {
    
    if _isSimulator() {
      K.App.mode = "local"
    } else {
      K.App.mode = "production"
      Development.setDeviceAsSimulator = true
    }
    
    
    K.App.name = "巡檢高手"
    
    K.Api.production = "http://172.104.79.212"
    K.Api.local = "http://waterapp.dev"
    //    K.Api.local = "http://172.104.79.212"
    
    K.Color.buttonBg = UIColor.fromRGB(89, green: 188, blue: 254).lighter(0.1)
    
    
    
    switch K.App.mode {
    case "production":
      K.Api.host = K.Api.production + K.Api.prefix
    case "stage":
      K.Api.host = K.Api.stage + K.Api.prefix
    default:
      K.Api.host = K.Api.local + K.Api.prefix
    }
  }
}

extension K {
  struct Api {
    struct Resource {
      static var tasks = "/tasks"
      static var categories = "/categories"
      static var inspections = "/inspections"
    }    
  }
}
