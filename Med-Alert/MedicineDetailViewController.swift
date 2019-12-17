//
//  MedicineDetailViewController.swift
//  Med-Alert
//
//  Created by Dhruvil on 12/4/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class MedicineDetailViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate
{
    @IBOutlet weak var medName: UITextField!
    @IBOutlet weak var specificNote: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    let imagePicker = UIImagePickerController()
    let picker = UIPickerView()
    
    var tableList: [String] = ["Number of dose per day","Number of dose per week","Set Timer"]
    var dosePerDay: String?
    var dosePerWeek: String?
    var alarm: String?
    var rightTableList = [String]()
    var weekdays: [String]?
    var light: [String] = ["","AM","PM"]
    var minute: [String] = [""]
    var Hours: [String] = [""]
    var perDay: [String] = [""]
    var hour: String?
    var min: String?
    var period: Int?
    var weekdayString: String?
    var encodedImage: String?
    var decodedImage: String?
    
    override func viewDidLoad()
    {
        configureTapGesture()
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButton))
        imagePicker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        picker.delegate = self
        picker.dataSource = self
        medName.delegate = self
        specificNote.delegate = self
        picker.tag = 1
        super.viewDidLoad()
        labelList()
        if let _ = globalname
        {
            retrieve()
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(MedicineDetailViewController.handleTap))
        tap.cancelsTouchesInView = false;
        view.addGestureRecognizer(tap)
    }

    @objc func handleTap()
    {
        view.endEditing(true)
    }
    
    func retrieve()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Medicine")
        fetchRequest.predicate = NSPredicate(format: "name = %@", globalname!)
        let users = try! managedContext.fetch(fetchRequest)
        for data in users as! [NSManagedObject]
        {
            medName.text = data.value(forKey: "name") as? String ?? ""
            dosePerDay = data.value(forKey: "day") as? String ?? ""
            dosePerWeek = data.value(forKey: "week") as? String ?? ""
            alarm = data.value(forKey: "timer") as? String ?? ""
            weekdayString = data.value(forKey: "week") as? String ?? ""
            specificNote.text = data.value(forKey: "note") as? String ?? ""
            decodedImage = data.value(forKey: "image") as? String ?? ""
            
        }
        if let decoded = decodedImage
        {
            let im = decoded
            let decodedData = NSData(base64Encoded: im, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            let iconValue:UIImage? = UIImage(data: decodedData! as Data) ?? nil
            image.image = iconValue
        }
        if dosePerWeek != "Daily"
        {
            dosePerWeek = "Optional"
        }
        labelList()
        tableView.reloadData()
    }
    
    func updateReminder()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Medicine")
        fetchRequest.predicate = NSPredicate(format: "name = %@", globalname!)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let object = test[0] as! NSManagedObject
            object.setValue(medName.text, forKey: "name")
            object.setValue(specificNote.text, forKey: "note")
            object.setValue(dosePerDay, forKey: "day")
            object.setValue(dosePerWeek, forKey: "week")
            object.setValue(encodedImage, forKey: "image")
            object.setValue(alarm, forKey: "timer")
            do
            {
                try managedContext.save()
                print("update successfully")
                performSegue(withIdentifier: "mainMed", sender: self)
            } catch
            {
                print(error)
            }
        } catch
        {
            print(error)
        }
    }
    
    @IBAction func unwindToMedDetail(segue:UIStoryboardSegue) {}
    
    @objc func doneButton()
    {
        if globalname != nil
        {
            updateReminder()
        } else
        {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            if medName.text != "" && dosePerDay != nil && alarm != nil
            {
                let detail = Medicine(context: managedContext)
                detail.name = medName.text
                detail.note = specificNote.text
                detail.image = encodedImage
                detail.day = dosePerDay
                detail.week = dosePerWeek
                detail.timer = alarm
                detail.isComplete = false
                do
                {
                    try managedContext.save()
                    print("Save Successfully")
                    performSegue(withIdentifier: "mainMed", sender: self)
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "mainMed"
        {
            let DestVC = segue.destination as! MyMedicineViewController
            DestVC.viewDidLoad()
        }
    }
    func timers()
    {
        let optionalWeekday = weekdayString?.map { String($0) } ?? [""]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm aa"
        let date2 = dateFormatter.date(from: self.alarm!)
        let calendar2 = Calendar.current
        let comp = calendar2.dateComponents([.hour, .minute], from: date2!)
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Medicine Reminder"
        content.body = "Time to take \(medName.text ?? "") medicine"
        content.sound = .default
        if dosePerWeek == "Daily"
        {
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request, withCompletionHandler: nil)
        } else
        {
            let trigger1 = UNCalendarNotificationTrigger(dateMatching: comp, repeats: true)
            for element in optionalWeekday
            {
                var dateInfo = DateComponents()
                dateInfo.hour = comp.hour!
                dateInfo.minute = comp.minute!
                dateInfo.weekday = Int(element)!
                dateInfo.timeZone = .current
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request, withCompletionHandler: nil)
            }
            let request1 = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger1)
            center.add(request1, withCompletionHandler: nil)
        }
    }
    
    func labelList()
    {
        minute.append("0")
        for element in 1...59
        {
            if Hours.count <= 13
            {
                Hours.append(String(element))
            }
            if perDay.count <= 10
            {
                perDay.append(String(element))
            }
                minute.append(String(element))
        }
        rightTableList = []
        if let day = dosePerDay
        {
            rightTableList.append(day)
        }else
        {
            rightTableList.append("")
        }
        if let week = dosePerWeek
        {
            rightTableList.append(week)
        }else
        {
            rightTableList.append("")
        }
        if let timer = alarm
        {
            rightTableList.append(timer)
        }else
        {
            rightTableList.append("")
        }
        tableView.reloadData()
    }
    
    @IBAction func addImageButton(_ sender: Any)
    {
        let alert = UIAlertController(title: "", message: "Select any option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
            {
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Photo Gallery",style: .default, handler: {(_: UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
            {
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            image.image = pickedImage
            let imageData = pickedImage.pngData()!
            encodedImage = imageData.base64EncodedString(options: .lineLength64Characters)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
extension MedicineDetailViewController: UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        if picker.tag == 1
        {
            return 3
        }else if picker.tag == 2
        {
            return 1
        } else
        {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if picker.tag == 1
        {
            switch component
            {
                case 0: return 13
                case 1: return 61
                case 2: return 3
                default: return 0
            }
        }else if picker.tag == 2
        {
            return perDay.count
        }else
        {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if picker.tag == 1
        {
            switch component
            {
                case 0: return Hours[row]
                case 1: return minute[row]
                case 2: return light[row]
                default: return nil
            }
        }
        if picker.tag == 2
        {
            return perDay[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if picker.tag == 1
        {
            if pickerView.selectedRow(inComponent: 0) <= 9
            {
                hour = "0" + String(pickerView.selectedRow(inComponent: 0))
            }else
            {
                hour = String(pickerView.selectedRow(inComponent: 0))
            }
            
            if pickerView.selectedRow(inComponent: 1)-1 <= 9
            {
                min = "0" + String(pickerView.selectedRow(inComponent: 1)-1)
            }else
            {
                min = String(pickerView.selectedRow(inComponent: 1)-1)
            }
            period = pickerView.selectedRow(inComponent: 2)
        }
        if picker.tag == 2
        {
            dosePerDay = String(perDay[row])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "medLabels") as! AllTableViewCell
        tableView.rowHeight = 80
        cell.labelName.text = tableList[indexPath.row]
        cell.selectedLabel.text = rightTableList[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            picker.tag = 2
            let alert = UIAlertController(title: "Dosage", message: "\n\n\n\n\n\n", preferredStyle: .alert)
            let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
            alert.isModalInPopover = true
            alert.view.addSubview(pickerFrame)
            pickerFrame.dataSource = self
            pickerFrame.delegate = self
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                _ in
                self.viewDidLoad()
            }))
            self.present(alert,animated: true, completion: nil)
        }
        else if indexPath.row == 1
        {
            let alert = UIAlertController(title: "", message: "Select any option", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Daily", style: .default, handler: { _ in
                self.dosePerWeek = "Daily"
                self.weekdayString = "Daily"
                self.labelList()
            }))
            alert.addAction(UIAlertAction(title: "Optional", style: .default, handler: { _ in
                self.dosePerWeek = "Optional"
                self.performSegue(withIdentifier: "segueToWeek", sender: self)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Set Timer", message: "(HH:MM:aa)\n\n\n\n\n\n", preferredStyle: .alert)
            let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
            picker.tag = 1
            alert.isModalInPopover = true
            alert.view.addSubview(pickerFrame)
            pickerFrame.dataSource = self
            pickerFrame.delegate = self
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                if let isHour = self.hour,let isPeriod = self.period,let isMin = self.min,isHour != "0" && isPeriod != 0 && isMin != "0"
                {
                    self.alarm = isHour + ":" + isMin + " " + self.light[isPeriod]
                    self.timers()
                    self.labelList()
                }else
                {
                    let alert = UIAlertController(title: "Error", message: "Please enter valid time", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert,animated: true, completion: nil )
                }
            }))
            self.present(alert,animated: true, completion: nil )
        }
    }
}
