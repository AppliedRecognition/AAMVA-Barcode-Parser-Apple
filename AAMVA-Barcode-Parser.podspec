Pod::Spec.new do |s|
  s.name             = 'AAMVA-Barcode-Parser'
  s.module_name      = 'AAMVABarcodeParser'
  s.version          = '1.0.0'
  s.summary          = 'Parses barcodes on North American ID cards encoded in AAMVA standard.'
  s.homepage         = 'https://github.com/AppliedRecognition'
  s.license          = { :type => 'MIT', :file => 'LICENCE' }
  s.author           = { 'jakubdolejs' => 'jakubdolejs@gmail.com' }
  s.source           = { :git => 'https://github.com/AppliedRecognition/AAMVA-Barcode-Parser.git', :tag => "v#{s.version}" }
  s.platform	     = :ios, '11.0'
  s.swift_versions   = ["5.0", "5.1"]
  s.source_files = 'AAMVA Barcode Parser/*.swift'
  s.test_spec do |test|
    test.source_files = 'AAMVA Barcode ParserTests/*.swift'
    test.resource = 'barcode_data/**/*.txt'
    test.preserve_path = 'barcode_data'
  end
end
