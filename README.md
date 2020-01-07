# AAMVA Barcode Parser

Parse barcodes on North American ID cards encoded using [AAMVA standard](https://www.aamva.org/DL-ID-Card-Design-Standard/).

## Installation
1. Install [CocoaPods](https://cocoapods.org).
1. Add a file called **Podfile** in your project's root folder.
1. Refer to the [Podfile reference documentation](https://guides.cocoapods.org/syntax/podfile.html) to set up your Podfile.
1. Add the AAMVA Barcode Parser dependency in your Podfile:

    ```ruby
    pod 'AAMVA-Barcode-Parser', '~> 1'
    ```
1. Open Terminal, navigate to the folder with your Podfile and enter:

    ```shell
    pod install
    ```
    
## Usage
```swift
import AAMVABarcodeParser

/// Parse barcode data
/// - Parameter barcodeData: Barcode data scanned from the back of a North American ID card
/// - Returns: Parsed document data
func parseBarcodeData(_ barcodeData) -> DocumentData {
    let parser = AAMVABarcodeParser()
    let documentData = try parser.parseData(barcodeData)
    if let firstName = documentData.firstName, let lastName = documentData.lastName {
        NSLog("Parsed ID card belonging to %@ %@", firstName, lastName)
    }
    return documentData
}
```

## [Reference documentation](https://appliedrecognition.github.io/AAMVA-Barcode-Parser-Apple/)
