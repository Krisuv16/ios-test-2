//
//  DetailViewController.swift
//  Ios-Test2
//
//  Created by Krisuv Bohara on 2022-12-15.
//

import UIKit

class DetailViewController: UIViewController {
    var dataList : BmiEntity!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var bmiTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var uniTextField: UITextField!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(dataList)
        nameTextField.text = dataList.name ?? ""
        ageTextField.text = dataList.age ?? ""
        genderTextField.text = dataList.gender ?? ""
        weightTextField.text = dataList.weight ?? ""
        heightTextField.text = dataList.height ?? ""
        bmiTextField.text = dataList.bmi ?? ""
        dateTextField.text = dataList.date ?? ""
        timeTextField.text = dataList.time ?? ""
        uniTextField.text = dataList.unit ?? ""
        heightLabel.text = dataList.unit == "Imperial" ? "Height in Inches" : "Height in Meters"
        weightLabel.text = dataList.unit == "Imperial" ? "Weight in Pounds" : "Weight in Kilogram"
        // Do any additional setup after loading the view.
        
        dateTextField.isEnabled = false
        timeTextField.isEnabled = false
        uniTextField.isEnabled = false
        
        resultLabel.isHidden = true
        updateBtn.isHidden = true
    }
    
    
    @IBAction func onUpdate(_ sender: UIButton) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "MMM d yyyy"
        
        //using alert Dialog
        let alert = UIAlertController(title: "Action Required", message: "Do you want to Update the data ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in}))
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: {action in
            
            self.dataList.name = self.nameTextField.text ?? self.dataList.name
            self.dataList.age = self.ageTextField.text ?? self.dataList.age
            self.dataList.gender = self.genderTextField.text ?? self.dataList.gender
            
            self.dataList.height = self.heightTextField.text ?? self.dataList.height
            self.dataList.weight = self.weightTextField.text ?? self.dataList.weight
            self.dataList.bmi = self.bmiTextField.text ?? self.dataList.bmi
            
            self.dataList.unit = self.uniTextField.text ?? self.dataList.unit
            
            self.dataList.date = formatter3.string(from: date)
            self.dataList.time = String(hour) + " : " +  String(minutes)
            
            self.updateData()
        }))
        
        //presenting dialog
        present(alert, animated: true)
    }
    
    func updateData(){
        do{
            try self.context.save()
            _ = self.navigationController?.popToRootViewController(animated: true)
            
        }catch{}
    }
    
    @IBAction func onCalculate(_ sender: UIButton) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "MMM d yyyy"
        
        
        if(weightTextField.text == dataList.weight && heightTextField.text == dataList.height){
            showToast(message: "Nothing to calculate")
        }else{
            if(dataList.unit == "Imperial"){
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
    
    func presentBmi(bmi : Double) {
        resultLabel.isHidden = false
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
    
    func modelValue(_ bmi: Double, _ formatter3: DateFormatter, _ date: Date, _ hour: Int, _ minutes: Int) {
        updateBtn.isHidden = false
        bmiTextField.text = String(bmi)
        dateTextField.text = formatter3.string(from: date)
        timeTextField.text = String(hour) + " : " +  String(minutes)
        heightTextField.text = heightTextField.text
        weightTextField.text = weightTextField.text
    }
    
    @IBAction func deleteFunction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Action Required", message: "Do you want to Delete the data ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in}))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            self.deleteData()
        }))
        present(alert, animated: true)
        
    }
    
    func deleteData(){
        self.context.delete(dataList)
        do{
            try self.context.save()
            _ = navigationController?.popToRootViewController(animated: true)
            
        }catch{
            print("Error")
        }
    }
    
}
extension DetailViewController {
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
