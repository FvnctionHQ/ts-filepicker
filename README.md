# TSFilePicker

Simple file picker.

## Installation
To add TSFilePicker to your Xcode project, select File -> Swift Packages -> Add Package Depedancy. Enter `https://github.com/FvnctionHQ/ts-filepicker`

## Requirements
- iOS 14

## Api

Start picking documents.  By adding `.folder` to documentTypes you configure the picker to pick folders and return error if non of the specified types were found in selected folder.
`func select(documentTypes: [UTType], allowsMultipleFileSelection: Bool)`

### Delegate

`func TSFilePickerModuleDidCancel(module: TSFilePicker)`
Called when file picking was canceled by user.

`func TSFilePickerModuleDidFail(module: TSFilePicker, error: TSFilePickerModuleError)`
 Called when en error occured

`func TSFilePickerModuleDidPickFiles(module: TSFilePicker, files: [TSFilePickerDocument])`
Called when documents were picked successfully
