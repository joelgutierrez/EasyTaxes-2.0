//
//  Profile.swift
//  EasyTaxes
//
//  Created by Joel Gutierrez on 11/28/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

import Foundation
import UIKit

struct Profile {
    //MARK: - class variables
    private var name: (String);
    private var image: (UIImage);
    private var birthdate: (String);
    private var address1: (String);
    private var address2: (String);
    private var phoneNumber: (String);
    private var forms = [Form]();
    
    //MARK: - constructor
    //creates a profile based on name, image, bday, address, and phone number
    init(name: String, image: UIImage, birthdate: String, address1: String, address2: String, phoneNumber: String) {
        self.name = name;
        self.image = image;
        self.birthdate = birthdate;
        self.address1 = address1;
        self.address2 = address2;
        self.phoneNumber = phoneNumber;
    }
    
    //MARK: - class functions
    func getName() -> String {
        return self.name;
    }
    
    func getUIImage() -> UIImage {
        return self.image;
    }
    
    func getBirthdate() -> String {
        return self.birthdate;
    }
    
    func getAddress1() -> String {
        return self.address1;
    }
    
    func getAddress2() -> String {
        return self.address2;
    }
    
    func getPhoneNumber() -> String {
        return self.phoneNumber;
    }
    
    func getFormCount() -> Int {
        return forms.count
    }
    
    mutating func addForm(form: Form) {
        forms.append(form)
    }
    
    mutating func deleteForm(atIndex: Int) {
        forms.remove(at: atIndex)
    }
    
    func form(atIndex: Int) -> Form? {
        if (atIndex >= 0 && atIndex < getFormCount()) {
            return forms[atIndex]
        } else {
            return nil
        }
    }
}
