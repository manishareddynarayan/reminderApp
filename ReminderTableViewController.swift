//
//  ReminderTableViewController.swift
//  RemainderApp
//
//  Created by N Manisha Reddy on 1/25/18.
//  Copyright © 2018 N Manisha Reddy. All rights reserved.
//

import UIKit
import Foundation

class ReminderTableViewController: UITableViewController,ReminderControllerDelegate{
    var reminders = [[String:String]]()
    let dateFormatter = DateFormatter()

    
    override func viewDidLoad() {
    super.viewDidLoad()
     if  UserDefaults.standard.value(forKey: "reminders") != nil  {
            let placesData = UserDefaults.standard.object(forKey: "reminders") as? NSData
            if let placesData = placesData {
                let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? [[String:String]]
                guard placesArray != nil else {
                    self.tableView.reloadData()
                    return
                }
                reminders = placesArray!
                self.tableView.reloadData()
            }

        }

        dateFormatter.string(from: Date())
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminders.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "remCell", for: indexPath)

        // Configure the cell...
        let reminder = reminders[indexPath.row] as? [String:String]
                cell.textLabel?.text = reminder?["reminderText"]
        cell.detailTextLabel?.text = ""
        if !(reminder?["reminderTime"]?.isEmpty)! {
            cell.detailTextLabel?.text = reminder?["reminderTime"]
        }
         return cell
    }
    
    func createReminderWith(reminder:Any) -> Void {
        reminders.append(reminder as! [String:String])
        let placesData = NSKeyedArchiver.archivedData(withRootObject: reminders)
        UserDefaults.standard.set(placesData, forKey: "reminders")
        self.tableView.reloadData()
    }

   // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            reminders.remove(at: indexPath.row)
            
            //reminders.remove()
        
            tableView.reloadData()
           UserDefaults.standard.set(reminders, forKey: "reminders")
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RemainderViewController
        destination.delegate = self
    }
    
}

class Reminder:NSObject {
    var reminderText:String = ""
    var reminderTime:String = ""
        override init() {
        super.init()
    }
}
