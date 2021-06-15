//
//  TSFileManagerModuleInterface.swift
//  TransferModular
//
//  Created by Alex Linkov on 6/10/21.
//

import Foundation
import UniformTypeIdentifiers

public protocol TSFilePickerModuleInterface: AnyObject {
    
    func select(documentTypes: [UTType], allowsMultipleFileSelection: Bool)
    
}


public  protocol TSFilePickerModuleDelegate: AnyObject {
    
    func TSFilePickerModuleDidCancel(module: TSFilePicker)
    func TSFilePickerModuleDidFail(module: TSFilePicker, error: TSFilePickerModuleError)
    func TSFilePickerModuleDidPickFiles(module: TSFilePicker, files: [TSFilePickerDocument])
}
