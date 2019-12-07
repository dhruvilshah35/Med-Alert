//
//  DosePerWeekViewController.swift
//  Med-Alert
//
//  Created by Dhruvil on 12/4/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit

class DosePerWeekViewController: UIViewController
{
    @IBOutlet weak var weekstack: UIStackView!
    @IBOutlet weak var monday: UIButton!
    @IBOutlet weak var tuesday: UIButton!
    @IBOutlet weak var wednesday: UIButton!
    @IBOutlet weak var thursday: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var saturday: UIButton!
    @IBOutlet weak var sunday: UIButton!
    @IBOutlet weak var weekdayPicker: UIPickerView!
    
    let doseOption: [String] = ["Daily","Optional"]
    var code: Int = 0
    var lastPickerValue: String = "Daily"
    override func viewDidLoad()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButton))
        weekstack.isHidden = true
        weekdayPicker.delegate = self
        weekdayPicker.dataSource = self
        super.viewDidLoad()
    }
    
    @objc func doneButton(sender: UIBarButtonItem)
    {
        if lastPickerValue != "Daily" && code == 0
        {
             let alert = UIAlertController(title: "Error", message: "Please select atleast one", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else
        {
            self.performSegue(withIdentifier: "unwindByWeek", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let DestVC = segue.destination as! MedicineDetailViewController
        if lastPickerValue == "Daily"
        {
            DestVC.dosePerWeek = lastPickerValue
        } else
        {
            DestVC.dosePerWeek = String(code)
        }
    }
    @IBAction func mondayButtonClicked(_ sender: Any)
    {
        if monday.backgroundColor != UIColor.red
        {
            code = code + 1
            monday.backgroundColor = UIColor.red
        } else
        {
            code = code - 1
            monday.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func tuesdayButtonClicked(_ sender: Any)
    {
        if tuesday.backgroundColor != UIColor.red
        {
            code = code + 10
            tuesday.backgroundColor = UIColor.red
        } else
        {
            code = code + 10
            tuesday.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func wednesdayButtonClicked(_ sender: Any)
    {
        if wednesday.backgroundColor != UIColor.red
        {
            code = code + 100
            wednesday.backgroundColor = UIColor.red
        } else
        {
            code = code + 100
            wednesday.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func thursdayButtonClicked(_ sender: Any)
    {
        if thursday.backgroundColor != UIColor.red
        {
            code = code + 1000
            thursday.backgroundColor = UIColor.red
        } else
        {
            code = code + 1000
            thursday.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func fridayButtonClicked(_ sender: Any)
    {
        if friday.backgroundColor != UIColor.red
        {
            code = code + 10000
            friday.backgroundColor = UIColor.red
        } else
        {
            code = code + 1000
            thursday.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func saturdayButtonClicked(_ sender: Any)
    {
        if saturday.backgroundColor != UIColor.red
        {
            code = code + 100000
            saturday.backgroundColor = UIColor.red
        } else
        {
            code = code + 100000
            saturday.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func sundayButtonClicked(_ sender: Any)
    {
        if sunday.backgroundColor != UIColor.red
        {
            code = code + 1000000
            sunday.backgroundColor = UIColor.red
        }
        else
        {
            code = code + 100000
            saturday.backgroundColor = UIColor.white
        }
    }
}
extension DosePerWeekViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return doseOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return doseOption[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if doseOption[row] == "Optional"
        {
            weekstack.isHidden = false
            lastPickerValue = ""
        }else
        {
            weekstack.isHidden = true
            code = 0
            monday.backgroundColor = UIColor.white
            tuesday.backgroundColor = UIColor.white
            wednesday.backgroundColor = UIColor.white
            thursday.backgroundColor = UIColor.white
            friday.backgroundColor = UIColor.white
            saturday.backgroundColor = UIColor.white
            sunday.backgroundColor = UIColor.white
        }
    }
    
    
}
