Pod::Spec.new do |spec|
  spec.name         = 'VImageBufferHelper'
  spec.version      = '1.0'
  spec.summary      = 'An helper library to deal with vImage_Buffer'
  spec.homepage     = 'https://github.com/AlessandroToschi/VImageBufferHelper'
  spec.author       = 'Alessandro Toschi'
  spec.source       = { :git => 'git://github.com/AlessandroToschi/VImageBufferHelper.git'}
  spec.source_files = 'VImageBufferHelper/*'
  spec.ios.deployment_target = '13.0'
end
