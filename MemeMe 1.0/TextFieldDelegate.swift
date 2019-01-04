//
//  TextFieldDelegate.swift
//  MemeMe 1.0
//
//  Created by Deena Tenzer on 1/7/18.
//  Copyright © 2018 Deena Tenzer. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UINavigationControllerDelegate, UITextFieldDelegate {



    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.white,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -5]


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.textAlignment = .center

        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if(textField.text == "TOP" || textField.text == "BOTTOM"){
            textField.text = ""
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
