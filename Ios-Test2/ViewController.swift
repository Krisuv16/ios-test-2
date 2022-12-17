//
//  ViewController.swift
//  Ios-Test2
//
//  Created by Krisuv Bohara on 2022-12-13.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var nameTextFieldLandScape: UITextField!
    @IBOutlet weak var ageTextFieldLandscape: UITextField!
    @IBOutlet weak var genderTextFieldLandscape: UITextField!
    @IBOutlet weak var weightTextFieldLandscape: UITextField!
    @IBOutlet weak var heightTextFieldLandscape: UITextField!
    
    @IBOutlet weak var switchLandscape: UISwitch!
    @IBOutlet weak var switchPotrait: UISwitch!
    
    @IBOutlet weak var calculateBtnLandscape: UIButton!
    @IBOutlet weak var clearBtnLandscape: UIButton!
    
    @IBOutlet weak var calculateBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    
    @IBOutlet weak var resultLabelPotrait: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        heightTextField.placeholder = "Enter Height in Inches"
        weightTextField.placeholder = "Enter Weight in Pounds"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearFunction()
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        if(sender.isOn){
            heightTextField.placeholder = "Enter Height in Inches"
            weightTextField.placeholder = "Enter Weight in Pounds"
            
            heightTextField.text = ""
            weightTextField.text = ""
            resultLabel.text = ""
        }else{
            heightTextField.placeholder = "Enter Height in Meters"
            weightTextField.placeholder = "Enter Weight in Kilogram"
            
            heightTextField.text = ""
            weightTextField.text = ""
            resultLabel.text = ""
        }
    }
    
    func modelValue(_ bmi: Double, _ formatter3: DateFormatter, _ date: Date, _ hour: Int, _ minutes: Int) {
        let bmiModel = BmiEntity(context: self.context)
        
        bmiModel.name = nameTextField.text
        bmiModel.age = ageTextField.text
        bmiModel.gender = genderTextField.text
        bmiModel.bmi = String(format: "%.1f", bmi)
        bmiModel.weight = weightTextField.text
        bmiModel.height = heightTextField.text
        bmiModel.date = formatter3.string(from: date)
        bmiModel.time = String(hour) + " : " +  String(minutes)
        bmiModel.unit = switchPotrait.isOn ? "Imperial" : "Metric"
        self.saveData()
    }
    
    @IBAction func calculateBtnAction(_ sender: UIButton) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "MMM d yyyy"
        
        if(nameTextField.text!.isEmpty || ageTextField.text!.isEmpty || genderTextField.text!.isEmpty){
            showToast(message: "General Info Missing")
        }else if(heightTextField.text!.isEmpty || weightTextField.text!.isEmpty){
            showToast(message: "Units Info Missing")
        }
        else{
            if(switchPotrait.isOn){
                var bmi = Double(
                    Float(weightTextField.text!)!  * 703 / (Float(heightTextField.text!)! * Float(heightTextField.text!)!)
                )
                bmi.round()
                presentBmi(bmi: bmi)
                modelValue(bmi, formatter3, date, hour, minutes)
            }else{
                var bmi = Double(Float(weightTextField.text!)! / (Float(heightTextField.text!)! * Float(heightTextField.text!)!))
                bmi.round()
                presentBmi(bmi: bmi)
                modelValue(bmi, formatter3, date, hour, minutes)
            }
        }
    }
    
    
    
    //saving the data in the core data
    func saveData() {
        do
        {
            try self.context.save()
//            let _ = try self.context.fetch(Note.fetchRequest())
        }
        catch {
            print("Error")
        }
    }
    
    
    
    @IBAction func clearAction(_ sender: UIButton) {
        clearFunction()
    }
    
    func clearFunction(){
        heightTextField.text = ""
        weightTextField.text = ""
        resultLabel.text = ""
        nameTextField.text = ""
        ageTextField.text = ""
        genderTextField.text = ""
    }
    
    
    func presentBmi(bmi : Double) {
        resultLabel.isHidden = false
        print(bmi)
        if(bmi <= 16){
            resultLabel.text = "Your BMI is " + String(format: "%.1f", bmi) + " You have Severe Thinness!"
        } else if bmi > 16 && bmi <= 17 {
            resultLabel.text = "Your BMI is " + String(format: "%.1f", bmi) + " You Moderate Thinness!"
        } else if bmi > 17 && bmi <= 18.5 {
            resultLabel.text = "Your BMI is " + String(format: "%.1f", bmi) + " You have Mild Thinness!"
        } else if bmi > 18.5 && bmi <= 25 {
            resultLabel.text = "Your BMI is " + String(format: "%.1f", bmi) +  " You have Normal weight!"
        }else if bmi > 25 && bmi <= 30 {
            resultLabel.text = "Your BMI is " + String(format: "%.1f", bmi) +  " You are Over Weight!"
        } else if bmi > 30 && bmi <= 35 {
            resultLabel.text = "Your BMI is " + String(format: "%.1f", bmi) + " Your Obese Class Level is 1!"
        } else if bmi > 35 && bmi <= 40 {
            resultLabel.text = "Your BMI is " + String(format: "%.1f", bmi) + " Your Obese Class Level is 2!"
        } else if bmi > 40 {
            resultLabel.text = "Your BMI is " + String(format: "%.1f", bmi) + " Your Obese Class Level is 3!"
        }
    }
    

}

extension ViewController {
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

