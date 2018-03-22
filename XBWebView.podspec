Pod::Spec.new do |s|
  s.name         = "XBWebView"
  s.version      = "0.0.1"
  s.summary      = "A short description of XBWebView."
  s.homepage     = "https://github.com/ChenXingBinInAnXi/XBWebController"
  s.license      = "MIT (example)"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "binchen" => "635824674@qq.com" }
  s.source       = { :git => "https://github.com/ChenXingBinInAnXi/XBWebController.git", :tag => “#{1.1.0}” }
  s.requires_arc = true
  s.ios.deployment_target = ‘8.0’
  s.source_files = 'XBWebControllerDemo/XBWebView/*.{h,m}'
end
