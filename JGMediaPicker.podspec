#
# Be sure to run `pod spec lint JGMediaPicker.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "JGMediaPicker"
  s.version      = "0.0.1"
  s.summary      = ""
  s.homepage     = "https://github.com/jaminguy/JGMediaPicker"
  s.license      = 'mit'
  s.author       = "jaminguy"
  s.source       = { :git => "https://github.com/jaminguy/JGMediaPicker.git" }
  s.platform     = :ios, '6.1'
  s.source_files = 'Classes/*.{h,m,c}'
  s.resources = 'Nibs/*.{png,nib,xib}', 'Images/*.png'
  #s.frameworks   = ''
  s.requires_arc = true
end

