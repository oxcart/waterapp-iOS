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


class HomeViewController: TableViewController {
  
  let refresh = UIRefreshControl()
  
  var button = UIButton(text: "開始新的巡檢")
  var collectionData = [Task]() { didSet { tableView.reloadData() } }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.layout([refresh])
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    refreshData()
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! TaskCell
    (cell as! TaskCell).data = collectionData[indexPath.row]
    cell.layoutIfNeeded()
    cell.whenTapped(self, action: #selector(cellTapped(_:)))
    cell.accessoryView = UIImageView(image: getIcon(.AngleRight))
    return cell
  }
  
  override func cellTapped(sender: UITapGestureRecognizer) {
    let index = tableView.indexOfTapped(sender)
    let task = collectionData[index.row]
    self.pushViewController(CategoriesViewController(task: task, url: K.Api.Resource.categories))
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return collectionData.count
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    let deleteAction = UITableViewRowAction(style: .Default, title: "刪除") { (action, indexPath) in
      let index = indexPath.row
      self.collectionData[index].delete({ (success) in
        delayedJob({ 
          tableView.beginUpdates()
          self.collectionData.removeAtIndex(index)
          self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
          tableView.endUpdates()
        })
        
      })
    }
    return [deleteAction]
  }
  
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func layoutUI() {
    super.layoutUI()
    tableView = tableView(TaskCell.self, identifier: CellIdentifier)
    view.layout([tableView, button])
  }
  
  override func styleUI() {
    super.styleUI()
    button.larger().colored(UIColor.blackColor()).bordered(1, color: K.Color.buttonBg.darker().CGColor).radiused().backgroundColored(K.Color.buttonBg)
    tableView.separatorStyle = .SingleLine
  }
  
  override func bindUI() {
    super.bindUI()
    button.whenTapped {
      Task.new({ (item) in
        self.pushViewController(CategoriesViewController(task: item, url: K.Api.Resource.categories))
      })
    }
    refresh.addTarget(self, action: #selector(refreshData), forControlEvents: .ValueChanged)
  }
  
  func refreshData() {
    Task.list { (items) in
      self.collectionData = items
      self.refresh.endRefreshing()
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let h = 60.cgFloat
    let p = 20.cgFloat
    tableView.fillSuperview(left: 0, right: 0, top: 0, bottom: h + 2 * p)
    button.anchorToEdge(.Bottom, padding: p, width: 3 * h, height: h)
  }
  
  class TaskCell: TableViewCell {
    
    var data: Task! {
      didSet {
        title.text(data.title)
      }
    }
    var title = UILabel()
    override func layoutUI() {
      super.layoutUI()
      layout([title])
    }
    override func styleUI() {
      super.styleUI()
      backgroundColored(UIColor.whiteColor())
    }
    override func layoutSubviews() {
      super.layoutSubviews()
      title.fillSuperview(left: 10, right: 10, top: 10, bottom: 10)
    }
    
  }
  
}

class Task: Mappable {
  var id: Int?
  var title: String?
  
  func mapping(map: Map) {
    id <- map["id"]
    title <- map["title"]
  }
  
  func delete(onComplete: (success: Bool) -> ()) {
    API.delete(K.Api.Resource.tasks + "/\(id!)") { (response) in
      onComplete(success: true)
    }
  }
  
  class func list(onComplete: (items: [Task]) -> ()) {
    let url = K.Api.Resource.tasks
    print(url)
    API.get(url) { (response) in
      var items = [Task]()
      switch response.result {
      case .Success(let value):
        if let jsons = value as? [[String: AnyObject]] {
          jsons.forEach({ (json) in
            let item = Task(JSON: json)!
            items.append(item)
          })
          onComplete(items: items)
        }
      case .Failure(let error):
        _logForUIMode(error.localizedDescription)
      }
    }
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