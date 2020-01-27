//
//  AppointmentDetailViewController.swift
//  Med-Alert
//
//  Created by Dhruvil on 12/15/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class AppointmentDetailViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var appointmentName: UITextField!
    @IBOutlet weak var doctorName: UITextField!
    @IBOutlet weak var note: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var alarm: String?
    
    override func viewDidLoad()
    {
         super.viewDidLoad()
        self.title = "Appointments"
        appointmentName.delegate = self
        doctorName.delegate = self
        note.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButton))
        if let _ = globalAppointmentName
        {
            retrieveData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag)
        {
            nextResponder.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func configureTapGesture()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(AppointmentDetailViewController.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap()
    {
        view.endEditing(true)
    }
    
    func retrieveData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Appointment")
        fetchRequest.predicate = NSPredicate(format: "aName = %@", globalAppointmentName!)
        let users = try! managedContext.fetch(fetchRequest)
        for data in users as! [NSManagedObject]
        {
            appointmentName.text = data.value(forKey: "aName") as? String ?? ""
            doctorName.text = data.value(forKey: "dName") as? String ?? ""
            note.text = data.value(forKey: "notes") as? String ?? ""
        }
    }
    
    func updateData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Appointment")
        fetchRequest.predicate = NSPredicate(format: "aName = %@", globalAppointmentName!)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let object = test[0] as! NSManagedObject
            object.setValue(appointmentName.text, forKey: "aName")
            object.setValue(doctorName.text, forKey: "dName")
            object.setValue(note.text, forKey: "notes")
            object.setValue(alarm, forKey: "alarm")
            do
            {
                try managedContext.save()
                print("update successfully")
                performSegue(withIdentifier: "unwindAppointment", sender: self)
            } catch
            {
                print(error)
            }
        } catch
        {
            print(error)
        }
    }
    
    @objc func doneButton()
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: datePicker.date)
        let date = dateFormatter.date(from: strDate)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date!)
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Appointment Reminder"
        content.body = "You have an Appointment on \(strDate) with \(doctorName.text!)"
        content.sound = .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
        alarm = strDate
        if globalAppointmentName != nil
        {
            updateData()
        }else
        {
            saveData()
        }
    }
    
    func saveData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        if appointmentName.text != "" && doctorName != nil
        {
            let detail = Appointment(context: managedContext)
            detail.aName = appointmentName.text
            detail.dName = doctorName.text
            detail.notes = note.text
            detail.alarm = alarm
            do
            {
                try managedContext.save()
                print("Save Successfully")
                performSegue(withIdentifier: "unwindAppointment", sender: self)
            }catch
            {
                print("Error at save")
            }
        }else
        {
            let alert = UIAlertController(title: "Error", message: "Please enter all the details", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true,completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let DestVC = segue.destination as! AddAppointmentViewController
        DestVC.viewDidLoad()
    }
}
