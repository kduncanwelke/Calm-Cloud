//
//  ReceiptItem.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 7/1/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct ReceiptItem {
    var number: Int?
    var id: String?
    var transactionId: String?
    var originalId: String?
    var dateOfPurchase: Date?
    var originalDateOfPurchase: Date?
    var subscriptionExp: Date?
    var subscriptionPeriod: Int?
    var subscriptionCancel: Date?
    var orderId: Int?
    
    init?(with pointer: inout UnsafePointer<UInt8>?, payloadLength: Int) {
        guard let endPointer = pointer?.advanced(by: payloadLength) else { return }
        var type: Int32 = 0
        var xclass: Int32 = 0
        var length = 0
        
        ASN1_get_object(&pointer, &length, &type, &xclass, payloadLength)
        
        guard type == V_ASN1_SET, let point = pointer else { return nil }
        
        while point < endPointer {
            ASN1_get_object(&pointer, &length, &type, &xclass, point.distance(to: endPointer))
            guard type == V_ASN1_SEQUENCE else { return nil }
            
            guard let attributeType = readInteger(ptr: &pointer, maxLength: point.distance(to: endPointer)) else { return nil }
            
            // Attribute version must be an integer, but not using the value
            guard let _ = readInteger(ptr: &pointer, maxLength: point.distance(to: endPointer)) else { return nil }
            
            ASN1_get_object(&pointer, &length, &type, &xclass, point.distance(to: endPointer))
            
            guard type == V_ASN1_OCTET_STRING else { return nil }
            
            switch attributeType {
            case 1701:
                var p = pointer
                number = readInteger(ptr: &p, maxLength: length)
            case 1702:
                var p = pointer
                id = readString(ptr: &p, maxLength: length)
            case 1703:
                var p = pointer
                transactionId = readString(ptr: &p, maxLength: length)
            case 1705:
                var p = pointer
                originalId = readString(ptr: &p, maxLength: length)
            case 1704:
                var p = pointer
                dateOfPurchase = readDate(ptr: &p, maxLength: length)
            case 1706:
                var p = pointer
                originalDateOfPurchase = readDate(ptr: &p, maxLength: length)
            case 1708:
                var p = pointer
                subscriptionExp = readDate(ptr: &p, maxLength: length)
            case 1712:
                var p = pointer
                subscriptionCancel = readDate(ptr: &p, maxLength: length)
            case 1711:
                var p = pointer
                orderId = readInteger(ptr: &p, maxLength: length)
            default:
                break
            }
            
            guard let point = pointer?.advanced(by: length) else { return }
            pointer = point
        }
    }
}
