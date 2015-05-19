Pod::Spec.new do |s|
  s.name         = "AITwitterAuth"
  s.version      = "0.0.5"
  s.summary      = "A library for twitter authentication"
  s.homepage     = "https://github.com/aibrahim16/AITwitterAuth"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author    = "aibrahim16"
  s.social_media_url   = "https://twitter.com/aibrahim16189"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/aibrahim16/AITwitterAuth.git", :commit => "efc1c5b", :tag => "0.0.6" }

  s.source_files  = 'Classes/*.{h,m}'

  s.requires_arc = true

  s.dependency "STTwitter", "~> 0.2.0"
end
