//
//  TSFileManagerModel.swift
//  TransferModular
//
//  Created by Alex Linkov on 6/14/21.
//

import UIKit
import Foundation

class TSFilePickerDocument: UIDocument {
    
    var orderBeforeSend: Int = 0
    var directory: String?
    
    var data: Data?
    
    override func contents(forType typeName: String) throws -> Any {
        guard let data = data else { return Data() }
        
        return try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        
        guard let data = contents as? Data else { return }
        
        self.data = data
    }
    
}
