//
//  TSFileManagerModuleCoordinator.swift
//  TransferModular
//
//  Created by Alex Linkov on 6/14/21.
//

import Foundation
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

typealias TSFilePicker = TSFilePickerModuleCoordinator

extension TSFilePickerModuleCoordinator: TSFilePickerModuleInterface {
  
    func select(documentTypes: [UTType], allowsMultipleFileSelection: Bool) {
        
        self.documentTypes = documentTypes
        
        var types: [UTType]
        if (documentTypes.contains(.folder)) {
            types = [.folder]
        } else {
            types = documentTypes
        }
        pickerController = UIDocumentPickerViewController(forOpeningContentTypes: types)
        pickerController!.delegate = self
        pickerController!.allowsMultipleSelection = allowsMultipleFileSelection
        presentationController?.present(pickerController!, animated: true)
    }
    
    
}

extension TSFilePickerModuleCoordinator: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if (urls.count == 0) {
            
            delegate?.TSFilePickerModuleDidFail(module: self, error: .failedToPick("No files found"))
            return
            
        }
        
        
        var pickedDocuments: [TSFilePickerDocument] = []
        
        if (documentTypes.contains(.folder)) {
            
            let selectedFolderURL: URL = urls.first!
            let selectedFolderName = selectedFolderURL.lastPathComponent
            
            
            let shouldStopAccessing = selectedFolderURL.startAccessingSecurityScopedResource()
            
            defer {
                if shouldStopAccessing {
                    selectedFolderURL.stopAccessingSecurityScopedResource()
                }
            }
            
            var didFail = true
            var readError: NSError?
            
            NSFileCoordinator().coordinate(readingItemAt: selectedFolderURL, error: &readError) { (folderURL) in
            
                let keys: [URLResourceKey] = [.nameKey, .isDirectoryKey, .contentTypeKey]
                let fileList = FileManager.default.enumerator(at: folderURL, includingPropertiesForKeys: keys)


                
                fileList!.forEach { fileURL in
                   
                    let url = fileURL as! URL
                    let resourceValues = try! url.resourceValues(forKeys: Set(keys))
                    let isDirectory = resourceValues.isDirectory ?? false
                    let type = (resourceValues.contentType ?? .none)!
                    
                    if !isDirectory {
                        if (filetypeConfirmsToAnyOfTypes(filetype: type, types: documentTypes)) {
                            let doc = TSFilePickerDocument(fileURL: url)
                            pickedDocuments.append(doc)
                        }
                        
                    }
                }
                

                
                if (pickedDocuments.count != 0) {
                    didFail = false
                }
                
            }
            
            if (didFail) {
                delegate?.TSFilePickerModuleDidFail(module: self, error: .failedToPick(" Folder \(selectedFolderName) does not contain any of requested types: \(documentTypes.filter{$0 != .folder}.map{$0.description} )"))
                return
            }

           
        }
        
        
        if (!documentTypes.contains(.folder)) {

            
            for url in urls {
                
                let shouldStopAccessing = url.startAccessingSecurityScopedResource()
                
                defer {
                    if shouldStopAccessing {
                        url.stopAccessingSecurityScopedResource()
                    }
                }
                
                NSFileCoordinator().coordinate(readingItemAt: url, error: NSErrorPointer.none) { (fileURL) in
                
                    let doc = TSFilePickerDocument(fileURL: fileURL)
                    pickedDocuments.append(doc)
                }
                
            }
        }
        
        delegate?.TSFilePickerModuleDidPickFiles(module: self, files: pickedDocuments)
        
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        delegate?.TSFilePickerModuleDidCancel(module: self)
    }
     
    

}

class TSFilePickerModuleCoordinator: NSObject {
    
    var documentTypes: [UTType]!
    var pickerController: UIDocumentPickerViewController?
    weak var presentationController: UIViewController?
    weak var delegate: TSFilePickerModuleDelegate?
    
    
    init(presentationController: UIViewController, delegate: TSFilePickerModuleDelegate) {
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
    }
    
    deinit {
    }

    
    func filetypeConfirmsToAnyOfTypes(filetype: UTType, types: [UTType]) -> Bool {
        
        var confirms = false
        
        types.forEach { type in
            let c = filetype.conforms(to: type)
            if (c) { confirms = true }
        }
        
        return confirms
    }

}
