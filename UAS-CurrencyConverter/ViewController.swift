//
//  ViewController.swift
//  UAS-CurrencyConverter
//
//  Created by Gregorius on 12/10/17.
//  Copyright © 2017 Gregorius. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var baseCurrencyPickerView: UIPickerView!
    @IBOutlet weak var convertCurrencyPickerView: UIPickerView!
    @IBOutlet weak var baseAmountTextField: UITextField!
    @IBOutlet weak var convertAmountLabel: UILabel!
    
    let userDef = UserDefaults.standard
    let currency:[String] = ["IDR", "GBP", "USD", "SGD", "CNY", "HKD", "AUD", "EUR"]
    //var url = NSURL(string: "")
    //let session = URLSession.shared
    var baseRow = 0
    var convertRow = 0
    var rateCurrency:Double = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func convertClick(_ sender: Any) {
        convert()
        //print(url ?? "tes")
        self.convertAmountLabel.text = String(self.rateCurrency * Double(self.baseAmountTextField.text!)!)
    }

    func convert(){
        let url = NSURL(string: "https://api.fixer.io/latest?base=\(currency[baseRow])")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url! as URL) { (data, response, error) -> Void in
            do {
                if let err = error as? URLError, err.code == URLError.Code.notConnectedToInternet
                {
                    //ALERT
                    let alert = UIAlertController(title: "No internet Connection", message: "Currency rate will be used stored offline cache data", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Got it!", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    //END OF ALERT
                    
                    print("No internet connection")
                } else {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                    let dateRates = jsonData.object(forKey: "date") as! String
                    let results = jsonData.object(forKey: "rates") as! NSDictionary
                    for(key,value) in results{
                        switch key as! NSString{
                        case "IDR": DispatchQueue.main.async(execute:{
                            self.userDef.set(value, forKey: "\(self.currency[self.baseRow])toIDR")
                        })
                        case "GBP": DispatchQueue.main.async(execute:{
                            print("\(self.currency[self.baseRow]) to GBP \(value)")
                            self.userDef.set(value, forKey: "\(self.currency[self.baseRow])toGBP")
                        })
                        case "USD": DispatchQueue.main.async(execute:{
                            print("\(self.currency[self.baseRow]) to USD \(value)")
                            self.userDef.set(value, forKey: "\(self.currency[self.baseRow])toUSD")
                        })
                        case "SGD": DispatchQueue.main.async(execute:{
                            print("\(self.currency[self.baseRow]) to SGD \(value)")
                            self.userDef.set(value, forKey: "\(self.currency[self.baseRow])toSGD")
                        })
                        case "CNY": DispatchQueue.main.async(execute:{
                            print("\(self.currency[self.baseRow]) to CNY \(value)")
                            self.userDef.set(value, forKey: "\(self.currency[self.baseRow])toCNY")
                        })
                        case "HKD": DispatchQueue.main.async(execute:{
                            print("\(self.currency[self.baseRow]) to HKD \(value)")
                            self.userDef.set(value, forKey: "\(self.currency[self.baseRow])toHKD")
                        })
                        case "AUD": DispatchQueue.main.async(execute:{
                            print("\(self.currency[self.baseRow]) to AUD \(value)")
                            self.userDef.set(value, forKey: "\(self.currency[self.baseRow])toAUD")
                        })
                        case "EUR": DispatchQueue.main.async(execute:{
                            print("\(self.currency[self.baseRow]) to EUR \(value)")
                            self.userDef.set(value, forKey: "\(self.currency[self.baseRow])toEUR")
                        })
                        default:break
                        }
                        self.userDef.set(dateRates, forKey: "lastDate")
                        self.rateCurrency = self.userDef.double(forKey: "\(self.currency[self.baseRow])to\(self.currency[self.convertRow])")
                    }
                }
            }
             catch {
                print("Error : \(error)")
            }
        }
        dataTask.resume()
    }
    
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == baseCurrencyPickerView){
            return currency.count
        } else {
            return currency.count-1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == baseCurrencyPickerView){
            return currency[row]
        } else {
            return currency[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(currency[row]) is selected")
        if(pickerView == baseCurrencyPickerView){
            baseRow = row
        } else {
            convertRow = row
        }
    }
}

