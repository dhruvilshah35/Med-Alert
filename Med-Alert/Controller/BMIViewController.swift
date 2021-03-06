//
//  BMIViewController.swift
//  Med-Alert
//
//  Created by Dhruvil on 12/15/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit

class BMIViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var feet: UITextField!
    @IBOutlet weak var inches: UITextField!
    @IBOutlet weak var pounds: UITextField!
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var calc: String?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        feet.delegate = self
        inches.delegate = self
        pounds.delegate = self
         self.addDoneButtonOnKeyboard()
        self.title = calc ?? ""
        if calc == "Body Mass Index"
        {
            textView.text = "BMI Categories: \nUnderweight = <18.5 \nNormal weight = 18.5–24.9 \nOverweight = 25–29.9 \nObesity = BMI of 30 or greater"
        } else if calc == "Ideal Weight Calculator"
        {
            pounds.isEnabled = false
            textView.text = "The Ideal Weight Calculator computes ideal bodyweight (IBW) ranges based on height. It gives you an idea of what hsould be the ideal weight according to your height. We have used following formula:\n\nB. J. Devine Formula (1974)= 50.0 kg + 2.3 kg per inch over 5 feet\n\n In pounds = 110.23 pound + 5.07 per inch over 5 feet."
        }
        self.feet.keyboardType = UIKeyboardType.decimalPad
        self.inches.keyboardType = UIKeyboardType.decimalPad
        self.pounds.keyboardType = UIKeyboardType.decimalPad
    }
  
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: Selector(("doneButtonAction")))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.feet.inputAccessoryView = doneToolbar
        self.inches.inputAccessoryView = doneToolbar
        self.pounds.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.feet.resignFirstResponder()
        self.inches.resignFirstResponder()
        self.pounds.resignFirstResponder()
    }
    
    @IBAction func calculateButton(_ sender: Any)
    {
        if feet.text != "" && inches.text != ""
        {
            if calc == "Body Mass Index" && pounds.text != ""
            {
                let feets = Int(feet.text!)
                let inch = Int(inches.text!)
                let pound = Int(pounds.text!)
                answer.text = "BMI = " + (NSString(format: "%.2f",(Double(pound! * 703) / (pow(Double((feets! * 12) + inch!), 2.0)))) as String)
            }else if calc == "Ideal Weight Calculator"
            {
                var feets = Int(feet.text!)
                let inch = Int(inches.text!)
                if feets! >= 5
                {
                    feets = (feets! - 5) * 12
                    answer.text = "Ideal Weight = " + String(110.23 + (5.07 * Double(feets! + inch!))) + " Pounds"
                } else
                {
                    let alert = UIAlertController(title: "Error", message: "Feet should be greater than 5", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true,completion: nil)
                }
            }
        }else
        {
            let alert = UIAlertController(title: "Error", message: "Please enter all the details", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true,completion: nil)
        }
        viewDidLoad()
    }
    
    @IBAction func infoButton(_ sender: Any)
    {
        performSegue(withIdentifier: "info", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "info"
        {
            let DestVC = segue.destination as! InfoViewController
            DestVC.calcType = calc
        }
    }
}
