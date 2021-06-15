//
//  TSFileManagerModuleError.swift
//  TransferModular
//
//  Created by Alex Linkov on 6/14/21.
//

import Foundation

public enum TSFilePickerModuleError: Error {
    
    case failedToPick(String)
    case failedToReadDir(String)
}

extension TSFilePickerModuleError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        
        case .failedToPick(let reason):
            let format = NSLocalizedString(
                "TSFileManagerModule Error: Failed to pick: '%@'",
                comment: ""
            )

            return String(format: format, reason)
     
        case .failedToReadDir(let reason):
            let format = NSLocalizedString(
                "TSFileManagerModule Error: Failed to read dir: '%@'",
                comment: ""
            )

            return String(format: format, reason)
            
            
        }
    }
}
