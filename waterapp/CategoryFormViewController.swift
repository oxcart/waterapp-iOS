//
//  CategoryFormViewController.swift
//  waterapp
//
//  Created by ctslin on 22/07/2017.
//  Copyright © 2017 airfont.com. All rights reserved.
//
import UIKit
import SwiftEasyKit

class CategoryFormViewController: TableViewController {
  
  var collectionData = [Category]() {
    didSet {
      tableView.reloadData()
    }
  }
  
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
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func layoutUI() {
    super.layoutUI()
    tableView = tableView(CategoryCell.self, identifier: CellIdentifier)
    view.layout([tableView])
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! CategoryCell
    (cell as! CategoryCell).data = collectionData[indexPath.row]
    return cell
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return collectionData.count
  }
  
  class CategoryCell: TableViewCell {
    
    var data: Category! {
      didSet {
        question.text(data.name)
        input.text("abc")
      }
    }
    
    var question = UILabel(text: "abc")
    var input = TextField(placeholder: "abc", bordered: true)
    override func layoutUI() {
      super.layoutUI()
      layout([question, input])
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      input.anchorAndFillEdge(.Right, xPad: 10, yPad: 10, otherSize: 50)
      question.alignToTheLeftOf(input, matchingTopAndFillingWidthWithLeftAndRightPadding: 10, height: input.height)
    }
  }
  
}