Pod::Spec.new do |s|
  s.name             = 'AAMVA-Barcode-Parser'
  s.module_name      = 'AAMVABarcodeParser'
  s.version          = '1.2.1'
  s.summary          = 'Parses barcodes on North American ID cards encoded in AAMVA standard.'
  s.homepage         = 'https://github.com/AppliedRecognition'
  s.license          = { :type => 'MIT', :file => 'LICENCE' }
  s.author           = { 'jakubdolejs' => 'jakubdolejs@gmail.com' }
  s.source           = { :git => 'https://github.com/AppliedRecognition/AAMVA-Barcode-Parser-Apple.git', :tag => "v#{s.version}" }
  s.platform	     = :ios, '11.0'
  s.swift_versions   = ["5.0", "5.1"]
  s.source_files = 'AAMVA Barcode Parser/*.swift'
  s.info_plist       = {
    "com.appliedrec.intellicheckURL" => "https://dev.ver-id.com/id-check/parse-verify"
  }
  s.test_spec do |test|
    test.source_files = 'AAMVA Barcode ParserTests/*.swift'
    test.resource = 'AAMVA Barcode ParserTests/barcode_data/*.txt'
  end
end
