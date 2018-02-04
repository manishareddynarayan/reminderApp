//
//  RemainderViewController.swift
//  RemainderApp
//
//  Created by N Manisha Reddy on 1/25/18.
//  Copyright © 2018 N Manisha Reddy. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

@objc protocol ReminderControllerDelegate {
    
    @objc optional func createReminderWith(reminder:Any)
    
}

class RemainderViewController: UIViewController,UITextFieldDelegate {
    
    weak var delegate: ReminderControllerDelegate!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var reminderTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reminderTxtField.delegate = self
        timePicker.minimumDate = Date() as Date        // Do any additional setup after loading the view.
    }
    func checkName() {
        let text = reminderTxtField.text ?? ""
        if text.isEmpty == false {
         // addBtn.isEnabled
            
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addAction(_: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'  'HH:mm:ss"
        let newReminder = ["reminderText": reminderTxtField.text!, "reminderTime": dateFormatter.string(from: timePicker.date)]
        
        var calendar = NSCalendar.current
        
        print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: timePicker.date as Date))
        
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let components = calendar.dateComponents(unitFlags, from: timePicker.date as Date)
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: components , repeats: true)
        let content = UNMutableNotificationContent()
        
        
        content.title = "\(String(describing: reminderTxtField.text))? "
        content.subtitle = "You have to \(String(describing: reminderTxtField.text))? remember?"
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        
        let request = UNNotificationRequest(identifier: "Reminders", content: content, trigger: calendarTrigger)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
                // Do something with error
            } else {
                print("notification added")
                self.delegate.createReminderWith!(reminder: newReminder)
                self.navigationController?.popViewController(animated: true)
                // Request was added successfully
            }
        }
       
        
    }

}
