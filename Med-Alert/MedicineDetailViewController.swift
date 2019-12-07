//
//  MedicineDetailViewController.swift
//  Med-Alert
//
//  Created by Dhruvil on 12/4/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit

class MedicineDetailViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var medName: UITextField!
    @IBOutlet weak var specificNote: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    let imagePicker = UIImagePickerController()
    let picker = UIPickerView()
    var tableList: [String] = ["Number of dose per day","Number of dose per week","Set Timer"]
    var dosePerDay = ""
    var dosePerWeek = ""
    var alarm = ""
    var rightTableList = [String]()
    let light: [String] = ["","AM","PM"]
    var minute: [String] = [""]
    var Hours: [String] = [""]
    var perDay: [String] = [""]
    var hour: String = ""
    var min: String = ""
    var period: String = ""
    
    override func viewDidLoad()
    {
        imagePicker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        picker.delegate = self
        picker.dataSource = self
        picker.tag = 1
        super.viewDidLoad()
        labelList()
    }
    
    @IBAction func unwindToMedDetail(segue:UIStoryboardSegue) {}
    
    func labelList()
    {
        for element in 1...60
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
        rightTableList.append(dosePerDay)
        rightTableList.append(dosePerWeek)
        rightTableList.append(alarm)
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
        }
        if picker.tag == 2
        {
            return 1
        } else
        {
            return 1
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
        }
        if picker.tag == 2
        {
            return perDay.count
        }
        else
        {
            return 1
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
        } else
        {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if picker.tag == 1
        {
            hour = String(pickerView.selectedRow(inComponent: 0))
            min = String(pickerView.selectedRow(inComponent: 1))
            period = String(light[pickerView.selectedRow(inComponent: 2)])
            
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
        cell.labelName.text = tableList[indexPath.row]
        cell.selectedLabel.text = rightTableList[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableList[indexPath.row] == tableList[0]
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
        } else if tableList[indexPath.row] == tableList[1]
        {
            performSegue(withIdentifier: "perWeek", sender: self)
        } else
        {
            let alert = UIAlertController(title: "Set Timer", message: "\n\n\n\n\n\n", preferredStyle: .alert)
            let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
            picker.tag = 1
            alert.isModalInPopover = true
            alert.view.addSubview(pickerFrame)
            pickerFrame.dataSource = self
            pickerFrame.delegate = self
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                self.alarm = self.hour + ":" + self.min + ":" + self.period
                self.viewDidLoad()
            }))
            self.present(alert,animated: true, completion: nil )
        }
    }
}
