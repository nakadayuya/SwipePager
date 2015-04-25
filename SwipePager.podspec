Pod::Spec.new do |s|
  s.name         = "SwipePager"
  s.version      = "1.0.0"
  s.summary      = "SwipePager is UIPageViewController wrapper like Gunosy, SmartNews UI."
  s.homepage     = "https://github.com/naoto0822/SwipePager"
  s.license      = 'MIT'
  s.author       = { "naoto0822" => "n.h.in.m.h@gmail.com" }
  s.source       = { :git => "https://github.com/naoto0822/SwipePager.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Source/*.{swift}'
end
