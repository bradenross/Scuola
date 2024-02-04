//
//  NumberFormatterService.swift
//  Scuola
//
//  Created by Braden Ross on 2/3/24.
//

import Foundation

func suffixNumber(num: Int) -> String{
    if(num < 1000){
        return "\(num)"
    }
    
    let exp:Int = Int(log10(Double(num)) / 3.0 );

    let units:[String] = ["K","M","G","T","P","E"];

    let roundedNum:Double = round(Double(10 * num) / pow(1000.0,Double(exp))) / 10;

    return "\(roundedNum)\(units[exp-1])";

}
