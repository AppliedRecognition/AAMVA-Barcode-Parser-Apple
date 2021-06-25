Pod::Spec.new do |s|
  s.name             = 'AAMVA-Barcode-Parser'
  s.module_name      = 'AAMVABarcodeParser'
  s.version          = '1.4.0'
  s.summary          = 'Parses barcodes on North American ID cards encoded in AAMVA standard.'
  s.homepage         = "https://github.com/AppliedRecognition/AAMVA-Barcode-Parser-Apple/tree/v#{s.version}"
  s.license          = { :type => 'MIT', :file => 'LICENCE' }
  s.author           = { 'jakubdolejs' => 'jakubdolejs@gmail.com' }
  s.source           = { :git => 'https://github.com/AppliedRecognition/AAMVA-Barcode-Parser-Apple.git', :tag => "v#{s.version}" }
  s.platform	     = :ios, '11.0'
  s.swift_version    = "5"
  s.source_files = 'Sources/AAMVABarcodeParser/*.swift'
  s.info_plist       = {
    "com.appliedrec.intellicheckURL" => "https://dev.ver-id.com/id-check/"
  }
  s.test_spec do |test|
    test.source_files = 'Sources/AAMVABarcodeParserTests/*.swift'
    test.resource = 'Sources/AAMVABarcodeParserTests/barcode_data/*.txt'
  end
end
