//
//  Receipt.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 7/1/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

enum Status: String {
    case validationSuccess = "This receipt is valid."
    case noReceiptPresent = "A receipt was not found on this device."
    case unknownFailure = "An unexpected failure occurred during verification."
    case unknownReceiptFormat = "The receipt is not in PKCS7 format."
    case invalidPKCS7Signature = "Invalid PKCS7 Signature."
    case invalidPKCS7Type = "Invalid PKCS7 Type."
    case invalidAppleRootCertificate = "Public Apple root certificate not found."
    case failedAppleSignature = "Receipt not signed by Apple."
    case unexpectedASN1Type = "Unexpected ASN1 Type."
    case missingComponent = "Expected component was not found."
    case invalidBundleIdentifier = "Receipt bundle identifier does not match application bundle identifier."
    case invalidVersionIdentifier = "Receipt version identifier does not match application version."
    case invalidHash = "Receipt failed hash check."
    case invalidExpired = "Receipt has expired."
}

class Receipt {
    var status: Status?
    var bundleIdString: String?
    var bundleVersionString: String?
    var bundleIdData: Data?
    var hashData: Data?
    var opaqueData: Data?
    var expirationDate: Date?
    var receiptCreationDate: Date?
    var originalAppVersion: String?
    var inAppReceipts: [ReceiptItem] = []
    
    static public func isReceiptPresent() -> Bool {
        if let receiptUrl = Bundle.main.appStoreReceiptURL,
            let canReach = try? receiptUrl.checkResourceIsReachable(),
            canReach {
            return true
        }
        
        return false
    }
    
    init() {
        guard let payload = find() else { return }
        
        guard check(payload) else { return }
        
        beginReading(payload)
        confirm()
    }
    
    private func find() -> UnsafeMutablePointer<PKCS7>? {
        // Load the receipt into a Data object
        guard let receiptUrl = Bundle.main.appStoreReceiptURL, let receiptData = try? Data(contentsOf: receiptUrl) else {
            status = .noReceiptPresent
            return nil
        }
        
        let receiptBIO = BIO_new(BIO_s_mem())
        let receiptBytes: [UInt8] = .init(receiptData)
        BIO_write(receiptBIO, receiptBytes, Int32(receiptData.count))
        
        let receiptPKCS7 = d2i_PKCS7_bio(receiptBIO, nil)
        BIO_free(receiptBIO)
        
        guard let receipt = receiptPKCS7 else {
            status = .unknownReceiptFormat
            return nil
        }
        
        guard OBJ_obj2nid(receipt.pointee.type) == NID_pkcs7_signed else {
            status = .invalidPKCS7Signature
            return nil
        }
        
        // Check that the container contains data
        let receiptContents = receipt.pointee.d.sign.pointee.contents
        
        guard OBJ_obj2nid(receiptContents?.pointee.type) == NID_pkcs7_data else {
            status = .invalidPKCS7Type
            return nil
        }
        
        return receipt
    }
    
    private func beginReading(_ receiptPKCS7: UnsafeMutablePointer<PKCS7>?) {
        // Get a pointer to the start and end of the ASN.1 payload
        let receiptSign = receiptPKCS7?.pointee.d.sign
        
        guard let octets = receiptSign?.pointee.contents.pointee.d.data else { return }
        
        var ptr = UnsafePointer(octets.pointee.data)
        
        guard let end = ptr?.advanced(by: Int(octets.pointee.length)) else { return }
        
        var type: Int32 = 0
        var xclass: Int32 = 0
        var length: Int = 0
        
        guard let pointer = ptr else { return }
        
        ASN1_get_object(&ptr, &length, &type, &xclass, pointer.distance(to: end))
        
        guard type == V_ASN1_SET else {
            status = .unexpectedASN1Type
            return
        }
        
        // 1
        while pointer < end {
            // 2
            ASN1_get_object(&ptr, &length, &type, &xclass, pointer.distance(to: end))
            
            guard type == V_ASN1_SEQUENCE else {
                status = .unexpectedASN1Type
                return
            }
            
            // 3
            guard let attributeType = readInteger(ptr: &ptr, maxLength: length) else {
                status = .unexpectedASN1Type
                return
            }
            
            // 4
            guard let _ = readInteger(ptr: &ptr, maxLength: pointer.distance(to: end)) else {
                status = .unexpectedASN1Type
                return
            }
            
            // 5
            ASN1_get_object(&ptr, &length, &type, &xclass, pointer.distance(to: end))
            
            guard type == V_ASN1_OCTET_STRING else {
                status = .unexpectedASN1Type
                return
            }
            
            switch attributeType {
            case 2: // The bundle identifier
                var stringStartPtr = ptr
                bundleIdString = readString(ptr: &stringStartPtr, maxLength: length)
                bundleIdData = readData(ptr: pointer, length: length)
                
            case 3: // Bundle version
                var stringStartPtr = ptr
                bundleVersionString = readString(ptr: &stringStartPtr, maxLength: length)
                
            case 4: // Opaque value
                opaqueData = readData(ptr: pointer, length: length)
                
            case 5: // Computed GUID (SHA-1 Hash)
                hashData = readData(ptr: pointer, length: length)
                
            case 12: // Receipt Creation Date
                var dateStartPtr = ptr
                receiptCreationDate = readDate(ptr: &dateStartPtr, maxLength: length)
                
            case 17: // IAP Receipt
                var iapStartPtr = ptr
                let parsedReceipt = ReceiptItem(with: &iapStartPtr, payloadLength: length)
                if let newReceipt = parsedReceipt {
                    inAppReceipts.append(newReceipt)
                }
            case 19: // Original App Version
                var stringStartPtr = ptr
                originalAppVersion = readString(ptr: &stringStartPtr, maxLength: length)
                
            case 21: // Expiration Date
                var dateStartPtr = ptr
                expirationDate = readDate(ptr: &dateStartPtr, maxLength: length)
                
            default: // Ignore other attributes in receipt
                print("Not processing attribute type: \(attributeType)")
            }
            
            // Advance pointer to the next item
            ptr = pointer.advanced(by: length)
        }
    }
    
    private func check(_ receipt: UnsafeMutablePointer<PKCS7>?) -> Bool {
        guard let rootCertUrl = Bundle.main.url(forResource: "AppleIncRootCertificate", withExtension: "cer"), let rootCertData = try? Data(contentsOf: rootCertUrl) else {
            status = .invalidAppleRootCertificate
            return false
        }
        
        let rootCertBio = BIO_new(BIO_s_mem())
        let rootCertBytes: [UInt8] = .init(rootCertData)
        BIO_write(rootCertBio, rootCertBytes, Int32(rootCertData.count))
        let rootCertX509 = d2i_X509_bio(rootCertBio, nil)
        BIO_free(rootCertBio)
        
        let store = X509_STORE_new()
        X509_STORE_add_cert(store, rootCertX509)
        
        let verificationResult = PKCS7_verify(receipt, nil, store, nil, nil, 0)
        print("\(verificationResult)")
        
        guard verificationResult == 1  else {
            status = .failedAppleSignature
            return false
        }
        
        return true
    }
    
    private func confirm() {
        guard let idString = bundleIdString, let version = bundleVersionString, let _ = opaqueData, let hash = hashData else {
            status = .missingComponent
            return
        }
        
        // Check the bundle identifier
        guard let appBundleId = Bundle.main.bundleIdentifier else {
            status = .unknownFailure
            return
        }
        
        guard idString == appBundleId else {
            status = .invalidBundleIdentifier
            return
        }
        
        // Check the version
        guard let appVersionString =
            Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
                status = .unknownFailure
                return
        }
        
        guard version == appVersionString else {
            status = .invalidVersionIdentifier
            return
        }
        
        // Check the GUID hash
        let guidHash = hashy()
        
        guard hash == guidHash else {
            status = .invalidHash
            return
        }
    }
    
    private func getIdentifier() -> Data? {
        let device = UIDevice.current
        guard var uuid = device.identifierForVendor?.uuid else { return nil }
        
        let addr = withUnsafePointer(to: &uuid) { (p) -> UnsafeRawPointer in
            UnsafeRawPointer(p)
        }
        
        let data = Data(bytes: addr, count: 16)
        return data
    }
    
    private func hashy() -> Data? {
        guard let identifierData = getIdentifier() else { return nil }
        var ctx = SHA256_CTX()
        SHA256_Init(&ctx)
        
        guard let opaque = opaqueData, let bundle = bundleIdData else { return nil }
        
        let identifierBytes: [UInt8] = .init(identifierData)
        SHA256_Update(&ctx, identifierBytes, identifierData.count)
        
        let opaqueBytes: [UInt8] = .init(opaque)
        SHA256_Update(&ctx, opaqueBytes, opaque.count)
        
        let bundleBytes: [UInt8] = .init(bundle)
        SHA256_Update(&ctx, bundleBytes, bundle.count)
        
        var hash: [UInt8] = .init(repeating: 0, count: 20)
        SHA256_Final(&hash, &ctx)
        
        return Data(bytes: hash, count: 20)
    }
}
