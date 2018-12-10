//
//  AddFormViewController.swift
//  EasyTaxes
//
//  Created by Joel Gutierrez on 11/29/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

import UIKit

protocol AddFormDelegate: class {
    func addFormToTVC(form: Form)
}

class AddFormViewController: UIViewController {
    //MARK: - ui components
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var youImageView: UIImageView!
    @IBOutlet weak var spouseImageView: UIImageView!
    @IBOutlet weak var singleImageView: UIImageView!
    @IBOutlet weak var marriedFJImageView: UIImageView!
    @IBOutlet weak var line1: UITextField! {didSet { line1?.addDoneCancelToolbar() }}
    @IBOutlet weak var line2: UITextField! {didSet { line2?.addDoneCancelToolbar() }}
    @IBOutlet weak var line3: UITextField! {didSet { line3?.addDoneCancelToolbar() }}
    @IBOutlet weak var line4: UITextField!
    @IBOutlet weak var line5: UITextField!
    @IBOutlet weak var line6: UITextField!
    @IBOutlet weak var line7: UITextField! {didSet { line7?.addDoneCancelToolbar() }}
    @IBOutlet weak var line8a: UITextField! {didSet { line8a?.addDoneCancelToolbar() }}
    @IBOutlet weak var line9: UITextField!
    @IBOutlet weak var line10: UITextField! {didSet {line10?.addDoneCancelToolbar() }}
    @IBOutlet weak var line11: UITextField! {didSet { line11?.addDoneCancelToolbar() }}
    @IBOutlet weak var line12: UITextField!
    @IBOutlet weak var line13: UITextField!
    @IBOutlet weak var line14: UITextField!
    @IBOutlet weak var calculate: UIButton!
    
    //MARK: - vc variables
    var line5Selected: Bool =  false
    weak var delegate: AddFormDelegate?
    var currForm: Form!
    var calcTapped: Bool = false
    var isPrefilled: Bool = false
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: self.innerView.frame.size.width, height: self.innerView.frame.size.height)
        setImageViewProperties()
        addTargetsToTFs()
        disableSaveButton()
        //enableScreenToMoveUpWithKeyboardUsage()

        if isPrefilled {
            disbleAllTextFields()
            disableImageViews()
            disableCalculateButton()
            changeLeftNavBarButtonItem()
            prefillForm()
        }
    }
    
    //MARK: - helper functions
    //allows the screen to move up/down when a keyboard will show or hide
    func enableScreenToMoveUpWithKeyboardUsage() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //have enabled tf's respond to value change within their text field
    func addTargetsToTFs() {
        line1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        line2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        line3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        line7.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        line8a.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        line10.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        line11.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //change the left nav bar button item to be the back image in gray
    func changeLeftNavBarButtonItem() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back.png"), for: .normal)
        button.addTarget(self, action: #selector(self.cancelTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    //disables the calculate button from being tappable
    func disableCalculateButton() {
        calculate.isEnabled = false
        calculate.backgroundColor = UIColor(red: 162/255.0, green: 177/255.0, blue: 187/255.0, alpha: 1.0)
    }
    
    //disables all image views - no interaction
    func disableImageViews() {
        self.youImageView.isUserInteractionEnabled = false
        self.spouseImageView.isUserInteractionEnabled = false
        self.singleImageView.isUserInteractionEnabled = false
        self.marriedFJImageView.isUserInteractionEnabled = false
    }
    
    //disables all textfields - no interaction
    func disbleAllTextFields() {
        line1.isUserInteractionEnabled = false
        line2.isUserInteractionEnabled = false
        line3.isUserInteractionEnabled = false
        line7.isUserInteractionEnabled = false
        line8a.isUserInteractionEnabled = false
        line10.isUserInteractionEnabled = false
        line11.isUserInteractionEnabled = false
        
        line1.backgroundColor = UIColor(red: 162/255.0, green: 177/255.0, blue: 187/255.0, alpha: 1.0)
        line2.backgroundColor = UIColor(red: 162/255.0, green: 177/255.0, blue: 187/255.0, alpha: 1.0)
        line3.backgroundColor = UIColor(red: 162/255.0, green: 177/255.0, blue: 187/255.0, alpha: 1.0)
        line7.backgroundColor = UIColor(red: 162/255.0, green: 177/255.0, blue: 187/255.0, alpha: 1.0)
        line8a.backgroundColor = UIColor(red: 162/255.0, green: 177/255.0, blue: 187/255.0, alpha: 1.0)
        line10.backgroundColor = UIColor(red: 162/255.0, green: 177/255.0, blue: 187/255.0, alpha: 1.0)
        line11.backgroundColor = UIColor(red: 162/255.0, green: 177/255.0, blue: 187/255.0, alpha: 1.0)
    }
    
    //populate the forms based on the curr form - passed in from user profile
    func prefillForm() {
        line1.text = getCurrencyString(number: currForm.getLine1())
        line2.text = getCurrencyString(number: currForm.getLine2())
        line3.text = getCurrencyString(number: currForm.getLine3())
        line4.text = getCurrencyString(number: currForm.getLine4())
        line5.text = getCurrencyString(number: currForm.getLine5())
        line6.text = getCurrencyString(number: currForm.getLine6())
        line7.text = getCurrencyString(number: currForm.getLine7())
        line8a.text = getCurrencyString(number: currForm.getLine8())
        line9.text = getCurrencyString(number: currForm.getLine9())
        line10.text = getCurrencyString(number: currForm.getLine10())
        line11.text = getCurrencyString(number: currForm.getLine11())
        line12.text = getCurrencyString(number: currForm.getLine12())
        line13.text = getCurrencyString(number: currForm.getLine13())
        line14.text = getCurrencyString(number: currForm.getLine14())
        
        if(currForm.getLine13() != 0) {
            line13.textColor = UIColor.green
            line14.textColor = UIColor.black
        }
        if(currForm.getLine14() != 0) {
            line14.textColor = UIColor.red
            line13.textColor = UIColor.black
        }
            
        if currForm.getLine5Status() == 0 {
            self.youImageView.isHighlighted = true
        } else if currForm.getLine5Status() == 1 {
            self.spouseImageView.isHighlighted = true
        } else if currForm.getLine5Status() == 2 {
            self.youImageView.isHighlighted = true
            self.spouseImageView.isHighlighted = true
        } else if currForm.getLine5Status() == 3 {
            self.singleImageView.isHighlighted = true
        } else if currForm.getLine5Status() == 4 {
            self.marriedFJImageView.isHighlighted = true
        }
    }
    
    //the right nav bar button to be disabled
    func disableSaveButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    //the right nav bar button to be enabled
    func enableSaveButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    //sets the image view properties
    //images include: you, spouse, single, and mfj
    func setImageViewProperties() {
        youImageView.layer.borderWidth = 1
        spouseImageView.layer.borderWidth = 1
        singleImageView.layer.borderWidth = 1
        marriedFJImageView.layer.borderWidth = 1

        youImageView.layer.borderColor = UIColor.black.cgColor
        spouseImageView.layer.borderColor = UIColor.black.cgColor
        singleImageView.layer.borderColor = UIColor.black.cgColor
        marriedFJImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    //sets the single and mfj images to be unhighlighted
    func setRightSideImageViewsToUnhighlighted() {
        singleImageView.isHighlighted = false
        marriedFJImageView.isHighlighted = false
    }
    
    //sets the you and spouse images as unhighlighted
    func setLeftSideImageViewsToUnhighlighted() {
        youImageView.isHighlighted = false
        spouseImageView.isHighlighted = false
    }
    
    //input: imageview
    //function: sets all other images besides input to be unselected
    func setAllOtherImageViewsToUnhighlighted(currImageView: UIImageView) {
        if(currImageView.isEqual(youImageView)) {
            spouseImageView.isHighlighted = false
            singleImageView.isHighlighted = false
            marriedFJImageView.isHighlighted = false
        } else if (currImageView.isEqual(spouseImageView)) {
            youImageView.isHighlighted = false
            singleImageView.isHighlighted = false
            marriedFJImageView.isHighlighted = false
        } else if (currImageView.isEqual(singleImageView)) {
            youImageView.isHighlighted = false
            spouseImageView.isHighlighted = false
            marriedFJImageView.isHighlighted = false
        } else if (currImageView.isEqual(marriedFJImageView)) {
            youImageView.isHighlighted = false
            spouseImageView.isHighlighted = false
            singleImageView.isHighlighted = false
        }
    }
    
    //checks if all tf's are populated
    //returns true if they are
    //returns false if they are not
    func allTFsPopulated() -> Bool {
        line5Selected = youImageView.isHighlighted || spouseImageView.isHighlighted || singleImageView.isHighlighted || marriedFJImageView.isHighlighted
        return line1.text != "" && line2.text != "" && line3.text != ""  && line5Selected && line7.text != "" && line8a.text != "" && line10.text != "" && line11.text != ""
    }
    
    //input: float number, output: the float number is currency format - ie: "$123,000.00"
    func getCurrencyString(number: Float) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    //create a form based on the fields
    //display the results of the form to the tf's
    func createForm() {
        let filingStatus = getFilingStatus()
        let form = Form.init(line1: Float(line1.text!)!, line2: Float(line2.text!)!, line3: Float(line3.text!)!, status: filingStatus, line7: Float(line7.text!)!, line8a: Float(line8a.text!)!, line10: Float(line10.text!)!, line11: Float(line11.text!)!)
        line4.text = getCurrencyString(number: form.getLine4())
        line5.text = getCurrencyString(number: form.getLine5())
        line6.text = getCurrencyString(number: form.getLine6())
        line9.text = getCurrencyString(number: form.getLine9())
        line12.text = getCurrencyString(number: form.getLine12())
        line13.text = getCurrencyString(number: form.getLine13())
        line14.text = getCurrencyString(number: form.getLine14())

        if(form.getLine13() != 0) {
            line13.textColor = UIColor.green
            line14.textColor = UIColor.black
        }
        if(form.getLine14() != 0) {
            line14.textColor = UIColor.red
            line13.textColor = UIColor.black
        }
        if form.getLine2() > 1500 {
            displayCantUseFormAlert()
            return
        }
        currForm = form
    }
    
    //get the filing status based on the image/s that have been selected and
    //return a code that corresponds to which images were selected
    func getFilingStatus() -> Int {
        if(youImageView.isHighlighted && spouseImageView.isHighlighted) {
            return 2
        } else if (youImageView.isHighlighted) {
            return 0
        } else if (spouseImageView.isHighlighted) {
            return 1
        } else if (singleImageView.isHighlighted) {
            return 3
        } else { //marriedFJImageView.isHighlighted
            return 4
        }
    }
    
    //MARK: - alerts
    //display that the user is not eligle to use the 1040ez tax form
    func displayCantUseFormAlert() {
        let alertcontroller = UIAlertController(title: "Cant use form", message: "Your taxable interest (line2) is above the limit", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertcontroller.addAction(okAction)
        self.present(alertcontroller, animated: true, completion: nil)
    }

    //display that there are missing fields in the form still - so cant calculate the form yet
    func displayMissingFieldsAlert() {
        let alertcontroller = UIAlertController(title: "Missing Fields", message: "Please make sure all fields are populated.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertcontroller.addAction(okAction)
        self.present(alertcontroller, animated: true, completion: nil)
    }
    
    //display that the form has not been calculated yet
    func displayNotCalculatedAlert() {
        let alertcontroller = UIAlertController(title: "Form not created", message: "Please make sure to calculate the form.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertcontroller.addAction(okAction)
        self.present(alertcontroller, animated: true, completion: nil)
    }

    
    //MARK: - IBActions
    //only line 10 and 11 need the view to shift up when the keyboard is displayed
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.line10.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        } else if self.line11.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    //make view go down if line 10 or 11 tf's are being displayed
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.line10.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    self.view.frame.origin.y += keyboardSize.height
                }
            }
        } else if self.line11.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    self.view.frame.origin.y += keyboardSize.height
                }
            }
        }
    }
    
    //if a text field changed, dont allow save, make user hit calculate button again
    @objc func textFieldDidChange(_ textField: UITextField) {
        calcTapped = false
        disableSaveButton()
    }
    
    //left nav bar button is tapped - go back to user profile vc
    @IBAction func cancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //if the save button (right nav bar button) is tapped and all tf's are populated and calc button is tapped
    //then exit the view controller and go back to user profile vc
    @IBAction func saveTapped(_ sender: Any) {
        if allTFsPopulated() && calcTapped {
            delegate?.addFormToTVC(form: currForm)
            self.navigationController?.popViewController(animated: true)
        } else {
            if(!calcTapped) {
                displayNotCalculatedAlert()
            } else {
                displayMissingFieldsAlert()
            }
        }
    }
    
    //if you image is tapped - single or mfj images should be unselected
    @IBAction func youImageTapped(_ sender: Any) {
        if(youImageView.isHighlighted){
            youImageView.isHighlighted = false
        } else {
            youImageView.isHighlighted = true
            setRightSideImageViewsToUnhighlighted()
        }
        calcTapped = false
        disableSaveButton()
    }
    
    //if spouse image is tapped - single or mfj images should be unselected
    @IBAction func spouseImageTapped(_ sender: Any) {
        if(spouseImageView.isHighlighted){
            spouseImageView.isHighlighted = false
        } else {
            spouseImageView.isHighlighted = true
            setRightSideImageViewsToUnhighlighted()
        }
        calcTapped = false
        disableSaveButton()
    }
    
    //if single image is tapped - no other images should stay selected
    @IBAction func singleImageTapped(_ sender: Any) {
        if(singleImageView.isHighlighted){
            singleImageView.isHighlighted = false
        } else {
            singleImageView.isHighlighted = true
            setAllOtherImageViewsToUnhighlighted(currImageView: singleImageView)
        }
        calcTapped = false
        disableSaveButton()
    }
    
    //if mfj image is tapped - no other images should stay selected
    @IBAction func marriedFJImageTapped(_ sender: Any) {
        if(marriedFJImageView.isHighlighted){
            marriedFJImageView.isHighlighted = false
        } else {
            marriedFJImageView.isHighlighted = true
            setAllOtherImageViewsToUnhighlighted(currImageView: marriedFJImageView)
        }
        calcTapped = false
        disableSaveButton()
    }
    
    //uibutton calculate is tapped - check if to calculate or display missing fields alert
    @IBAction func calculateTapped(_ sender: Any) {
        if allTFsPopulated() {
            createForm()
            calcTapped = true
            enableSaveButton()
        } else {
            calcTapped = false
            disableSaveButton()
            displayMissingFieldsAlert()
        }
    }
    
    //hide keyboard is the background view is tapped
    @IBAction func viewTapped(_ sender: Any) {
        if self.line1.isFirstResponder {
            self.line1.resignFirstResponder()
        } else if self.line2.isFirstResponder {
            self.line2.resignFirstResponder()
        } else if self.line3.isFirstResponder {
            self.line3.resignFirstResponder()
        } else if self.line7.isFirstResponder {
            self.line7.resignFirstResponder()
        } else if self.line8a.isFirstResponder {
            self.line8a.resignFirstResponder()
        } else if self.line10.isFirstResponder {
            self.line10.resignFirstResponder()
        } else if self.line11.isFirstResponder {
            self.line11.resignFirstResponder()
        }
    }
}
