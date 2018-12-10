//
//  Form.swift
//  EasyTaxes
//
//  Created by Joel Gutierrez on 11/28/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

import Foundation

struct Form {
    //MARK: - Global Vars - manually change every year
    var TAXINTEREST: Float = 1_500.00                     //line-2 instructions
    var WORKSHEET_LINE_A: Float = 350.00                 //backside of form, line-A
    var MIN_STD_DEDUCTION: Float = 1_050.00               //backside of form, line-B
    var DEPENDENT_SINGLE_MAX: Float = 6_350.00            //dependent and single
    var DEPENDENT_FILING_JOINTLY_MAX: Float = 12_700.00   //dependent and married filing jointly
    var INDEPENDENT_SINGLE: Float = 10_400.00             //independent and single
    var INDEPENDENT_FILING_JOINTLY: Float = 20_800.00     //independent and married filing jointly
    var LINE5F_WORKSHEET_ONLY1CLAIMEDASINDEPENDENT: Float = 4050.00
    var YOU_STATUS: Int = 0
    var SPOUSE_STATUS: Int = 1
    var YOU_AND_SPOUSE_STATUS: Int = 2
    var SINGLE_STATUS: Int = 3
    var MARRIEDFILINGJOINTLY_STATUS = 4
    
    //MARK: - Income variables
    var line1_WagesSalariesTips: Float?
    var line2_TaxableInterest: Float?
    var line3_UnemploymentComp: Float?
    private var line4_Sum123_AdjustedGrossIncome: Float = 0.00
    private var line5_ClaimOrNoClaim: Float = 0.00
    var line5_Status: Int
    private var line6_Sub5From4_TaxableIncome: Float = 0.00

    //MARK: - Payments, Credits, and Tax variables
    var line7_FederalIncomeWithheld: Float?
    var line8a_EarnedIncomeCredit: Float?
    //var line8b_NontaxableCombatPayElection: Float?
    private var line9_Sum7and8a_TotalPaymentsAndCredits: Float = 0.00
    var line10_RefLine6ForTaxTable_Tax: Float?
    var line11_HealthCare: Float?
    var line12_Sum10and11_TotalTax: Float?
    
    //MARK: - Refund and amount you owe variables
    private var line13a_Refund: Float = 0.00
    private var line14_AmountYouOwe: Float = 0.00
    private var isAmountOwedByUser: Bool = false
    
    //MARK: - extra class variables
    private var date: String = ""
    
    //MARK: constructor
    //fills all lines of the 1040ez tax form
    init(line1: Float, line2: Float, line3: Float, status: Int, line7: Float, line8a: Float, line10: Float, line11: Float) {
        self.line1_WagesSalariesTips = line1
        self.line2_TaxableInterest = line2
        self.line3_UnemploymentComp = line3
        self.line5_Status = status
        self.line7_FederalIncomeWithheld = line7
        self.line8a_EarnedIncomeCredit = line8a
        self.line10_RefLine6ForTaxTable_Tax = line10
        self.line11_HealthCare = line11
        self.setDateCreatedAsCurrent()
        
        self.line4_Sum123_AdjustedGrossIncome = self.line4_AdjustedGrossIncome(line1: line1, line2: line2, line3: line3)
        self.line5_ClaimOrNoClaim = worksheet(status: status, line1: line1)
        self.line6_Sub5From4_TaxableIncome = line6(line5: line5_ClaimOrNoClaim, line4: line4_Sum123_AdjustedGrossIncome)
        self.line9_Sum7and8a_TotalPaymentsAndCredits = line9(line7: line7_FederalIncomeWithheld!, line8a: line8a_EarnedIncomeCredit!)
        self.line12_Sum10and11_TotalTax = line12(line10: line10_RefLine6ForTaxTable_Tax!, line11: line11_HealthCare!)
        assignRefundOrOwe(line9: line9_Sum7and8a_TotalPaymentsAndCredits, line12: line12_Sum10and11_TotalTax!)
    }
    
    //MARK: helper functions
    //gets the current date and time and links it to this form
    mutating func setDateCreatedAsCurrent() {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        date = formatter.string(from: currentDateTime)
    }
    
    //outputs line 4 value - needs line1,2,3 as input to calculate
    func line4_AdjustedGrossIncome(line1: Float, line2: Float, line3: Float) -> Float {
        if (line2 > TAXINTEREST) {
            return 0.00
        } else {
            return line1 + line2 + line3
        }
    }
    
    //outputs line5a value - needs line 1 as input to calculate
    func line5A_Worksheet(line1: Float) -> Float {
        return line1 + WORKSHEET_LINE_A
    }
    
    //outputs line5c value - needs line5a/b as input to calculate
    func line5C_Worksheet(line5a: Float, line5b: Float) -> Float {
        return max(line5a, line5b)
    }
    
    //outputs line5e value - needs line5c/d as input to calculate
    func line5E_Worksheet(line5c: Float, line5d: Float) -> Float {
        return min(line5c, line5d)
    }
    
    //outputs line5g value - needs line5e/f as input to calculate
    func line5G_Worksheet(line5e: Float, line5f: Float) -> Float {
        return line5e + line5f
    }
    
    //outputs: value of backside worksheet
    //inputs: needs the filing status and line1 from the front side of the sheet
    func worksheet(status: Int, line1: Float) -> Float {
        var back5g: Float = 0.00
        if(status == YOU_AND_SPOUSE_STATUS || status == YOU_STATUS || status == SPOUSE_STATUS) {
            let back5a = self.line5A_Worksheet(line1: line1)
            let back5c = self.line5C_Worksheet(line5a: back5a, line5b: MIN_STD_DEDUCTION)
            var back5d: Float = 0.00
            var back5f: Float = 0.00
            
            if(status == YOU_AND_SPOUSE_STATUS) {
                back5d = DEPENDENT_FILING_JOINTLY_MAX
                back5f = 0.00
            } else if (status == YOU_STATUS) {
                back5d = DEPENDENT_SINGLE_MAX
                back5f = 0.00
            } else if (status == SPOUSE_STATUS) {
                back5d = DEPENDENT_FILING_JOINTLY_MAX
                back5f = LINE5F_WORKSHEET_ONLY1CLAIMEDASINDEPENDENT
            }
            
            let back5e = line5E_Worksheet(line5c: back5c, line5d: back5d)
            back5g = line5G_Worksheet(line5e: back5e, line5f: back5f)
            
            print("worksheet 5a: \(back5a)")
            print("worksheet 5c: \(back5c)")
            print("worksheet 5d: \(back5d)")
            print("worksheet 5e: \(back5e)")
            print("worksheet 5f: \(back5f)")
            print("worksheet 5g: \(back5g)")
        } else if (status == SINGLE_STATUS) {
            back5g = INDEPENDENT_SINGLE
        } else if (status == MARRIEDFILINGJOINTLY_STATUS) {
            back5g = INDEPENDENT_FILING_JOINTLY
        }
        return back5g
    }
    
    //outputs value of line 6
    //inputs: line5 and 4 values
    func line6(line5: Float, line4: Float) -> Float {
        if line5 > line4 {
            return 0.00
        } else {
            return line4 - line5
        }
    }
    
    //outputs value of line9
    //inputs: values of line 7 and line8a
    func line9(line7: Float, line8a: Float) -> Float {
        return line7 + line8a
    }
    
    //outputs value of line12
    //inputs: line10 and line11 values
    func line12(line10: Float, line11: Float) -> Float {
        return line10 + line11
    }
    
    //inputs: line9 and line12 values
    //result: isAmountOwed bool is set
    //  line13 and line14 fields are set
    mutating func assignRefundOrOwe(line9: Float, line12: Float) {
        if line9 > line12 {
            line13a_Refund = line9 - line12
            line14_AmountYouOwe = 0
            isAmountOwedByUser = false
        } else {
            line13a_Refund = 0
            line14_AmountYouOwe = line12 - line9
            isAmountOwedByUser = true
        }
    }
    
    //returns if form shows amount is owed or not
    //returns true is amount is owed
    //return false if amount is not owed
    func isAmountOwed() -> Bool {
        return isAmountOwedByUser
    }
    
    //returns the date, as a string, of when the form was created
    func getDateCreated() -> String {
        return date
    }
    
    //MARK: - get line # functions
    func getLine1() -> Float {
        return line1_WagesSalariesTips!
    }
    
    func getLine2() -> Float {
        return line2_TaxableInterest!
    }
    
    func getLine3() -> Float {
        return line3_UnemploymentComp!
    }
    
    func getLine4() -> Float {
        return line4_Sum123_AdjustedGrossIncome
    }
    
    func getLine5() -> Float {
        return line5_ClaimOrNoClaim
    }
    
    func getLine5Status() -> Int {
        return line5_Status
    }
    
    func getLine6() -> Float {
        return line6_Sub5From4_TaxableIncome
    }
    
    func getLine7() -> Float {
        return line7_FederalIncomeWithheld!
    }
    
    func getLine8() -> Float {
        return line8a_EarnedIncomeCredit!
    }
    
    func getLine9() -> Float {
        return line9_Sum7and8a_TotalPaymentsAndCredits
    }
    
    func getLine10() -> Float {
        return line10_RefLine6ForTaxTable_Tax!
    }
    
    func getLine11() -> Float {
        return line11_HealthCare!
    }
    
    func getLine12() -> Float {
        return line12_Sum10and11_TotalTax!
    }
    
    func getLine13() -> Float {
        return line13a_Refund
    }
    
    func getLine14() -> Float {
        return line14_AmountYouOwe
    }
}
