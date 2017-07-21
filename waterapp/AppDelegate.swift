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
    let nv = UINavigationController()
//    nv.pushViewController(CategoriesViewController(url: K.Api.Resource.categories))
    nv.pushViewController(CategoriesViewController(url: K.Api.Resource.categories), animated: true)
    window = bootFrom(nv)
    return true
  }

}

