//
//  DetailViewController.swift
//  NadavBaruch-pset5
//
//  Created by Nadav Baruch on 28-11-16.
//  Copyright © 2016 Nadav Baruch. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData(_:)), name: .reload, object: nil)
        
        self.title = detailItem

    }
    
    func reloadTableData(_ notification: Notification) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(_ sender: Any) {
        if(self.detailItem != nil) {
        let alert = UIAlertController(title: "Make a note", message: "Enter a text", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Note"
        }
        alert.addAction(UIAlertAction(title: "Add!", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
    
            ToDoManager.sharedInstance.write(toDoItem: (textField?.text!)!, title: self.detailItem!, tableName: "notes")
            self.tableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
        }
     else {
        let alert = UIAlertController(title: "Select a list", message: "Or create a new list.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    
        }}
    

    @IBAction func checkSwitch(_ sender: Any) {
        // source: http://stackoverflow.com/questions/39603922/getting-row-of-uitableview-cell-on-button-press-swift-3
        let switchPos = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: switchPos)
        ToDoManager.sharedInstance.checkSwitch(index: (indexPath?.row)!, title: detailItem!)
    }
    
    func configureView() {
        if let detail = detailItem {
            print(detail)
        }
    }
    
    var detailItem: String? {
        didSet {
            configureView()
        }
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        if(detailItem != nil) {
            rows = ToDoManager.sharedInstance.count(title: detailItem!, tableName: "notes")
        }
        
        return rows

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        
        cell.todoNote.text = ToDoManager.sharedInstance.read(index: indexPath.row, title: detailItem!, tableName: "notes").0
        let completedState = ToDoManager.sharedInstance.read(index: indexPath.row, title: detailItem!, tableName: "notes").1
        
        cell.checkSwitch.setOn(completedState, animated: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ToDoManager.sharedInstance.delete(index: indexPath.row, title: self.detailItem!, tableName: "notes")
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
}

// MARK: - State Restoration

override func encodeRestorableState(with coder: NSCoder) {
    if let selectedList = detailItem {
        coder.encode(selectedList, forKey: "selectedList")
    }
    
    encodeRestorableState(with: coder)
}

override func decodeRestorableState(with coder: NSCoder) {
    
    if let selectedList = coder.decodeObject(forKey: "selectedList") as? String {
        detailItem = selectedList
    }
    
    decodeRestorableState(with: coder)
    }}
