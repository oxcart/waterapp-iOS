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
      titled((collectionData.first?.breadcrumb)!, token: "CF")
    }
  }
  
  var task: Task! { didSet { }}
  var url: String! { didSet {
    Category.list (url, task: task) { (items) in
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
  
  override func layoutUI() {
    super.layoutUI()
    tableView = tableView(CategoryCell.self, identifier: CellIdentifier)
    view.layout([tableView])
  }
  
  override func styleUI() {
    super.styleUI()
    tableView.separatorStyle = .SingleLine
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! CategoryCell
    (cell as! CategoryCell).data = collectionData[indexPath.row]
    cell.delegate = self
//    cell.layoutIfNeeded()
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 80
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return collectionData.count
  }
  
  func updateCollectionData(data: Category, value: String?) {
    let index = collectionData.map({$0.id!}).indexOf(data.id!)
    collectionData[index!].value = value
  }
  
  class CategoryCell: TableViewCell, UITextFieldDelegate {
    
    var data: Category! {
      didSet {
        question.text(data.name)
        unit.text(data.unit)
        input.text(data.value ?? "")
      }
    }
    
    var question = UILabel()
    var input = UITextField()//(placeholder: "", bordered: true)
    var unit = UILabel()
    override func layoutUI() {
      super.layoutUI()
      layout([input, unit, question])
    }
    
    func save() {
      let inspection = Inspection(JSON: [String: AnyObject]())!
      inspection.value = input.text
      (delegate as! CategoryFormViewController).updateCollectionData(data, value: input.text)
      inspection.categoryId = data.id
      inspection.taskId = (delegate as! CategoryFormViewController).task.id
      API.post(K.Api.Resource.inspections, parameters: ["inspection": inspection.toJSON()]) { (response) in
        self.input.endEditing(true)
      }
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
      save()
      return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
      _logForUIMode()
      if data.options == nil {
        return true
      } else {
        let vc = UIAlertController(title: data.parent!.name, message: data.name, preferredStyle: .ActionSheet)
        data.options?.split("|").forEach({ (option) in
          let action = UIAlertAction(title: option, style: .Default, handler: { (action) in
            self.input.text(option)
            self.save()
          })
          vc.addAction(action)
        })
        let cancel = UIAlertAction(title: "取消", style: .Default, handler: { (action) in
          self.delegate?.dismissViewControllerAnimated(true, completion: { })
        })
        vc.addAction(cancel)
        if let presenter = vc.popoverPresentationController {
          presenter.sourceView = textField
          presenter.sourceRect = textField.bounds
        }
        delegate!.presentViewController(vc, animated: true, completion: {
        })
        return false
      }
    }
    
    override func styleUI() {
      super.styleUI()
      backgroundColored(UIColor.lightGrayColor().lighter(0.3))
      unit.lighter().smaller(3)
      input.textAlignment = .Center
      input.radiused(3).backgroundColored(UIColor.whiteColor()).bordered(1, color: UIColor.lightGrayColor().CGColor)
      question.multilinized()
      input.keyboardType = .DecimalPad
//      input.addButton("Done", target: self, action: #selector(save))
      SetDoneToolbar(input)
    }
    
    func SetDoneToolbar(field: UITextField) {
      let doneToolbar:UIToolbar = UIToolbar()
      
      doneToolbar.items=[
        UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil),
        UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(save))
      ]
      
      doneToolbar.sizeToFit()
      field.inputAccessoryView = doneToolbar
    }
    
    override func bindUI() {
      super.bindUI()
      input.delegate = self
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      unit.anchorToEdge(.Right, padding: 10, width: unit.textWidth(), height: unit.textHeight())
      input.alignToTheLeftOf(unit, matchingCenterWithRightPadding: 10, width: 120, height: unit.height * 2)
      question.alignToTheLeftOf(input, matchingCenterAndFillingWidthWithLeftAndRightPadding: 10, height: [question.getHeightBySizeThatFitsWithWidth(width - input.leftEdge() - 10), unit.height].maxElement()!)
    }
  }
  
}