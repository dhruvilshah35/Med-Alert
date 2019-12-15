//
//  EditMedicineViewController.swift
//  Med-Alert
//
//  Created by Dhruvil on 12/14/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit

class EditMedicineViewController: UIViewController,,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var note: UITextField!
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
    var decodedImage: String?
    
    override func viewDidLoad()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButton))
        imagePicker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        picker.delegate = self
        picker.dataSource = self
        picker.tag = 2
        super.viewDidLoad()
    }
}
