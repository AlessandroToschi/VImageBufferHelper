Pod::Spec.new do |spec|
  spec.name         = 'VImageBufferHelper'
  spec.version      = '1.0'
  spec.homepage     = 'https://github.com/AlessandroToschi/VImageBufferHelper'
  spec.author       = 'Alessandro Toschi'
  spec.source       = { :git => 'git://github.com/AlessandroToschi/VImageBufferHelper.git'}
  spec.source_files = 'VImageBufferHelper/*'
  spec.requires_arc = true
  spec.dependency 'Accelerate'
end