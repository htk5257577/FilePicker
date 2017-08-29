
Pod::Spec.new do |s|
  s.name         = "FilePicker"
  s.version      = "0.0.1"
  s.summary      = "A FilePicker in iOS."
  s.description  = <<-DESC
                    to help you select file in Documents
                   DESC

  s.homepage     = "https://github.com/htk5257577/FilePicker"
  s.license      = "MIT "
  s.author       = { "htk5257577" => "280071019@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/htk5257577/FilePicker.git", :tag => "#{s.version}" }

  s.source_files  = "Class", "FilePicker/Class/*.{h,m}"
  s.resources    = "FilePicker/Resource/*.png"
  s.frameworks   = 'Foundation', 'UIKit'
  s.dependency "Masonry", "~> 1.0.2"

end
