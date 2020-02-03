//
//  InfoViewController.swift
//  Med-Alert
//
//  Created by Dhruvil on 12/16/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController
{
    @IBOutlet weak var textView: UITextView!
    var calcType: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Information"
        if calcType == "Body Mass Index"
        {
            textView.text = "BMI is a measurement of a person's leanness or corpulence based on their height and weight, and is intended to quantify tissue mass. It is widely used as a general indicator of whether a person has a healthy body weight for their height. Specifically, the value obtained from the calculation of BMI is used to categorize whether a person is underweight, normal weight, overweight, or obese depending on what range the value falls between. These ranges of BMI vary based on factors such as region and age, and are sometimes further divided into subcategories such as severely underweight or very severely obese. Being overweight or underweight can have significant health effects, so while BMI is an imperfect measure of healthy body weight, it is a useful indicator of whether any additional testing or action is required. Refer to the table back to see the different categories based on BMI that is used by the calculator."
        }
        else if calcType == "Ideal Weight Calculator"
        {
            textView.text = "The idea of finding the IBW using a formula has been sought after by many experts for a long time. Currently, there persist several popular formulas, and our Ideal Weight Calculator provides their results for side-to-side comparisons.\nNote that IBW is not a perfect measurement. It does not consider the percentages of body fat and muscle in a person's body. This means that it is possible for highly fit, healthy athletes to be considered overweight based on their IBW. This is why IBW should be considered with the perspective that it is an imperfect measure and not necessarily indicative of health, or a weight that a person should necessarily strive toward; it is possible to be over or under your IBW and be perfectly healthy.\n\nHow much a person should weigh is not an exact science. It is highly dependent on each individual. Thus far, there is no measure, be it IBW, body mass index (BMI), or any other that can definitively state how much a person should weigh to be healthy. They are only references, and it's more important to adhere to making healthy life choices such as regular exercise, eating a variety of unprocessed foods, getting enough sleep, etc. than it is to chase a specific weight based on a generalized formula.\nThat being said, many factors can affect the ideal weight; the major factors are listed below. Other factors include health conditions, fat distribution, progeny, etc."
        } else
        {
            textView.text = "We are using following formula:\nMifflin-St Jeor Equation:\nFor men:\nBMR = 10W + 6.25H - 5A + 5\nFor women:\nBMR = 10W + 6.25H - 5A - 161\nWhere:\nW = weight\nH = Height\nA = Age.It is the equivalent of figuring out how much gas an idle car consumes while parked. In such a state, energy will be used only to maintain vital organs, which include the heart, lungs, kidneys, nervous system, intestines, liver, lungs, sex organs, muscles, and skin. For most people, upwards of ~70% of total energy (calories) burned each day is due to upkeep. Physical activity makes up ~20% of expenditure and ~10% is used for the digestion of food, also known as thermogenesis.\nThe BMR is measured under very restrictive circumstances while awake. An accurate BMR measurement requires that a person's sympathetic nervous system is inactive, which means the person must be completely rested. Basal metabolism is usually the largest component of a person's total caloric needs. The daily caloric need is the BMR value multiplied by a factor with a value between 1.2 and 1.9, depending on activity level."
        }
    }
}
