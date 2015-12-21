Pod::Spec.new do |s|
  s.name         = "MYTableViewManager"
  s.version      = "0.0.1"
  s.summary      = "TableView 管理器"
  s.homepage     = "https://github.com/melvin7/MYTableViewManager"
  s.license      = "Copyright (C) 2015 TimeFace, Inc.  All rights reserved."
  s.author             = { "Melvin" => "yangmin@timeface.cn" }
  s.social_media_url   = "http://www.timeface.cn"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/melvin7/MYTableViewManager.git"}
  s.source_files  = "MYTableViewManager/MYTableViewManager/**/*.{h,m,c}"
  s.requires_arc = true
  s.dependency 'pop'
  s.dependency 'AsyncDisplayKit'
  s.dependency 'YYKit'
end
