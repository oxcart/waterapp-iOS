//
//  AppDelegate.swift
//  waterapp
//
//  Created by ctslin on 20/07/2017.
//  Copyright © 2017 airfont.com. All rights reserved.
//

import UIKit
import SwiftEasyKit

@UIApplicationMain
class AppDelegate: DefaultAppDelegate {

  override func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    _ = Configure()
    print(K.App.mode)
    print(K.Api.host)
    let nv = UINavigationController(rootViewController: HomeViewController())
    window = bootFrom(nv)
    return true
  }

}

