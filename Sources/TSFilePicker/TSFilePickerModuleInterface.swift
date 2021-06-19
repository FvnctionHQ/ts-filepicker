//
//  TSFileManagerModuleInterface.swift
//  TransferModular
//
//  Created by Alex Linkov on 6/10/21.
//

import Foundation
import UniformTypeIdentifiers
import UIKit

public protocol TSFilePickerModuleInterface: AnyObject {
    
    func select(documentTypes: [UTType], allowsMultipleFileSelection: Bool, style: UIUserInterfaceStyle)
    
}


public  protocol TSFilePickerModuleDelegate: AnyObject {
    func TSFilePickerModuleDidRequestShowLoading(module: TSFilePicker)
    func TSFilePickerModuleDidRequestDismissLoading(module: TSFilePicker)
    func TSFilePickerModuleDidCancel(module: TSFilePicker)
    func TSFilePickerModuleDidFail(module: TSFilePicker, error: TSFilePickerModuleError)
    func TSFilePickerModuleDidPickFiles(module: TSFilePicker, files: [TSFilePickerDocument])
}
