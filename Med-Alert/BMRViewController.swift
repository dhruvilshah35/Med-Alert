//
//  BMRViewController.swift
//  Med-Alert
//
//  Created by Dhruvil on 12/16/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit

class BMRViewController: UIViewController
{
    
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var feet: UITextField!
    @IBOutlet weak var inches: UITextField!
    @IBOutlet weak var pounds: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    
    override func viewDidLoad()
    {
        self.title = "Basal Metabolic Rate"
        textView.text = "The basal metabolic rate (BMR) is the amount of energy needed while resting in a temperate environment when the digestive system is inactive."
        super.viewDidLoad()
    }

    @IBAction func maleButton(_ sender: Any)
    {
        male.backgroundColor = .lightGray
        female.backgroundColor = .white
    }
    
    @IBAction func femaleButton(_ sender: Any)
    {
        male.backgroundColor = .white
        female.backgroundColor = .lightGray
    }
    
    @IBAction func calculateButton(_ sender: Any)
    {
        if pounds.text != "" && feet.text != "" && inches.text != "" && age.text != ""
        {
            let pound = Int(pounds.text!)
            let feets = Int(feet.text!)
            let inch = Int(inches.text!)
            let ageNumber = Int(age.text!)
            if male.backgroundColor == .lightGray
            {
                let W = Double(pound!) / 2.2
                let H = ((Double(feets!) * 12) + Double(inch!)) * 2.54
                let A = Double(ageNumber!)
                answer.text = "BMR = " + (NSString(format: "%.2f", ((10.0 * W) + (6.25 * H) - (5 * A) + 5.0)) as String) + " Calories/Day"
            }else if female.backgroundColor == .lightGray
            {
                let W = Double(pound!) / 2.2
                let H = ((Double(feets!) * 12) + Double(inch!)) * 2.54
                let A = Double(ageNumber!)
                answer.text = "BMR = " + (NSString(format: "%.2f", ((10.0 * W) + (6.25 * H) - (5 * A) - 161.0)) as String) + " Calories/Day"
            } else
            {
                let alert = UIAlertController(title: "Error", message: "Please select gender", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true,completion: nil)
            }
        }else
        {
            let alert = UIAlertController(title: "Error", message: "Please enter all the details", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true,completion: nil)
        }
    }
    
    @IBAction func infoButton(_ sender: Any)
    {
        performSegue(withIdentifier: "bmrInfo", sender: self)
    }
    
}
