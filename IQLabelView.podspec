Pod::Spec.new do |spec|
  spec.name               = "IQLabelView"
  spec.version            = "0.1.2"
  spec.summary            = "IQLabelView is used to add text overlay and resize and rotate it with single finger."

  spec.homepage           = "https://github.com/kcandr/IQLabelView"

  spec.author             = { "kcandr" => "romanchev.aleksandr@gmail.com" }
  spec.social_media_url   = "http://twitter.com/kcandr_"
  spec.license            = { :type => "MIT", :file => "LICENSE" }
 
  spec.source             = { :git => "https://github.com/kcandr/IQLabelView.git", :tag => "0.1.2" }
  spec.source_files       = "IQLabelView/*.{h,m}"
  spec.resource           = "IQLabelView/IQLabelView.bundle"

  spec.platform           = :ios, "7.0"
  spec.framework          = "QuartzCore"
  spec.requires_arc       = true

end
