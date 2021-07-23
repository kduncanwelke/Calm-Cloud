//
//  StoreHelper.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 7/1/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

func readData(ptr: UnsafePointer<UInt8>, length: Int) -> Data {
    return Data(bytes: ptr, count: length)
}

func readInteger(ptr: inout UnsafePointer<UInt8>?, maxLength: Int) -> Int? {
    var type: Int32 = 0
    var xclass: Int32 = 0
    var length: Int = 0
    
    ASN1_get_object(&ptr, &length, &type, &xclass, maxLength)
    
    guard type == V_ASN1_INTEGER else { return nil }
    
    let integerObject = d2i_ASN1_INTEGER(nil, &ptr, length)
    let intValue = ASN1_INTEGER_get(integerObject)
    ASN1_INTEGER_free(integerObject)
    
    return intValue
}

func readString(ptr: inout UnsafePointer<UInt8>?, maxLength: Int) -> String? {
    var strClass: Int32 = 0
    var strLength = 0
    var strType: Int32 = 0
    
    var strPointer = ptr
    ASN1_get_object(&strPointer, &strLength, &strType, &strClass, maxLength)
    
    guard let pointer = strPointer else { return nil }
    
    if strType == V_ASN1_UTF8STRING {
        let p = UnsafeMutableRawPointer(mutating: pointer)
        let utfString = String(bytesNoCopy: p, length: strLength, encoding: .utf8, freeWhenDone: false)
        return utfString
    }
    
    if strType == V_ASN1_IA5STRING {
        let p = UnsafeMutablePointer(mutating: pointer)
        let ia5String = String(bytesNoCopy: p, length: strLength, encoding: .ascii, freeWhenDone: false)
        return ia5String
    }
    
    return nil
}

func readDate(ptr: inout UnsafePointer<UInt8>?, maxLength: Int) -> Date? {
    var str_xclass: Int32 = 0
    var str_length = 0
    var str_type: Int32 = 0
    
    // A date formatter to handle RFC 3339 dates in the GMT time zone
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    formatter.timeZone = TimeZone(abbreviation: "GMT")
    
    var strPointer = ptr
    ASN1_get_object(&strPointer, &str_length, &str_type, &str_xclass, maxLength)
    
    guard str_type == V_ASN1_IA5STRING, let pointer = strPointer else { return nil }
    
    let p = UnsafeMutableRawPointer(mutating: pointer)
    
    if let dateString = String(bytesNoCopy: p, length: str_length, encoding: .ascii, freeWhenDone: false) {
        return formatter.date(from: dateString)
    }
    
    return nil
}
