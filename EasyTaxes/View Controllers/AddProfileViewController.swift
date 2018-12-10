//
//  AddProfileViewController.swift
//  EasyTaxes
//
//  Created by Joel Gutierrez on 11/20/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

import UIKit
import ContactsUI

//MARK: - add profile protocol
protocol AddProfileDelegate: class {
    func addProfileToCVC(profile: Profile)
}

//MARK: - add profile vc
class AddProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CNContactPickerDelegate, UITextFieldDelegate {
    //MARK: - ui components
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var birthTF: UITextField!
    @IBOutlet weak var homeAddressTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    
    //MARK: - vc variables
    var address1: (String) = ""
    var address2: (String) = ""
    var isEverythingFilled: Bool = false
    var profilesModel = ProfilesModel.sharedInstance
    weak var delegate: AddProfileDelegate?
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        disableSaveButton()
        addTargetsToTFs()
        enableScreenToMoveUpWithKeyboardUsage()
    }

    //MARK: - helper functions
    //enable textfields to show while using keyboard
    func enableScreenToMoveUpWithKeyboardUsage() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //have each textfield recognize to textfielddidchange
    func addTargetsToTFs() {
        nameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneNumberTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        birthTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        homeAddressTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cityTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        stateTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        zipCodeTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //disables nav bar save button
    func disableSaveButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    //enables nav bar save button
    func enableSaveButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    //checks if all tf's are populated
    func allTFsPopulated() -> Bool {
        return nameTF.text != "" && birthTF.text != "" && homeAddressTF.text != ""  && cityTF.text != "" && stateTF.text != "" && zipCodeTF.text != "" && phoneNumberTF.text != ""
    }
    
    //displays alert that says fields are missing
    func displayMissingFieldsAlert() {
        let alertcontroller = UIAlertController(title: "Missing Fields", message: "Please make sure all fields are populated.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertcontroller.addAction(okAction)
        self.present(alertcontroller, animated: true, completion: nil)
    }
    
    //save the profile information to the data model
    func saveProfileInformation() {
        self.address1 = self.homeAddressTF.text!
        self.address2 = self.cityTF.text! + ", " + self.stateTF.text! + " " + self.zipCodeTF.text!
        let profile = Profile.init(name: self.nameTF.text!, image: resizeImage(image: profileImageView.image!, targetSize: CGSize(width: 120, height: 120)), birthdate: self.birthTF.text!, address1: self.address1, address2: self.address2, phoneNumber: self.phoneNumberTF.text!)
        delegate?.addProfileToCVC(profile: profile)
    }
    
    //input: uiimage to resize, target size, output: original image in specified format
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //MARK: - IBActions
    //if a keyboard is about to be shown - move view up so fields are visible
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    //make view go backdown if the keyboard is about to go away
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    //function is executed if a textfields value has changed - respond accordingly
    @objc func textFieldDidChange(_ textField: UITextField) {
        if allTFsPopulated() {
            enableSaveButton()
        } else {
            disableSaveButton()
        }
    }
    
    //cancel nav bar button is tapped - exit view controller
    @IBAction func cancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //save nav bar button is tapped - only saves if tf's are all populated
    @IBAction func saveTapped(_ sender: Any) {
        if allTFsPopulated() {
            saveProfileInformation()
            self.navigationController?.popViewController(animated: true)
        } else {
            displayMissingFieldsAlert()
        }
    }
    
    //user hits the take photo button - camera view controller will be displayed
    @IBAction func takePhotoTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //user taps the photo library button - image gallery is shown for the user to select an image
    @IBAction func photoLibraryTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //user wants to populate fields from a contact in their contacts - contacts are shown
    @IBAction func addInfoFromContactsTapped(_ sender: Any) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactPostalAddressesKey, CNContactImageDataKey, CNContactBirthdayKey, CNContactNonGregorianBirthdayKey]
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    //hide the keyboard if the background view is tapped
    @IBAction func viewTapped(_ sender: Any) {
        if self.nameTF.isFirstResponder {
            self.nameTF.resignFirstResponder()
        } else if self.phoneNumberTF.isFirstResponder {
            self.phoneNumberTF.resignFirstResponder()
        } else if self.birthTF.isFirstResponder {
            self.birthTF.resignFirstResponder()
        } else if self.homeAddressTF.isFirstResponder {
            self.homeAddressTF.resignFirstResponder()
        } else if self.cityTF.isFirstResponder {
            self.cityTF.resignFirstResponder()
        } else if self.stateTF.isFirstResponder {
            self.stateTF.resignFirstResponder()
        } else if self.zipCodeTF.isFirstResponder {
            self.zipCodeTF.resignFirstResponder()
        }
    }

    
    //MARK: - contact picker
    //if a contact is selected from the users contact list -> populate information in textfields
    //thats provided from the contact
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let userName:String = contact.givenName
        nameTF.text = userName
    

        if contact.phoneNumbers.count > 0 {
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
            let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue
            phoneNumberTF.text = primaryPhoneNumberStr
        }
        
        if let yearBirth = contact.birthday?.year, let monthBirth = contact.birthday?.month, let dayBirth = contact.birthday?.day {
            let yearString = "\(yearBirth)"
            let monthString = "\(monthBirth)"
            let dayString = "\(dayBirth)"
            birthTF.text = monthString + "/" + dayString + "/" + yearString
        }
        
        if contact.postalAddresses.count > 0 {
            let userPostalAddresses:[CNLabeledValue<CNPostalAddress>] = contact.postalAddresses
            let firstPostalAddress:CNPostalAddress = userPostalAddresses[0].value
            let primaryStreet: String = firstPostalAddress.street
            let primaryCity: String = firstPostalAddress.city
            let primaryState: String = firstPostalAddress.state
            let primaryPostalCode: String = firstPostalAddress.postalCode
            self.homeAddressTF.text = primaryStreet
            self.cityTF.text = primaryCity
            self.stateTF.text = primaryState
            self.zipCodeTF.text = primaryPostalCode
        }
        
        if (contact.imageDataAvailable) {
            let imageUser = UIImage(data: contact.imageData!)
            profileImageView.image = imageUser
        }
        
        if allTFsPopulated() {
            enableSaveButton()
        }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {}
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {}
    
    //MARK: - textfield delegate
    //if the done return button is tapped from the keyboard - close the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    
    //MARK: - image picker functions
    //if an image is picked from the image gallery - dismiss the keyboard
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.image = image
        dismiss(animated:true, completion: nil)
    }
}
