#
# Be sure to run `pod lib lint ModuleB.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ModuleB'
  s.version          = '0.1.0'
  s.summary          = '基础组件库'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = <<-DESC
  基础组件库
  DESC
  
  s.homepage         = 'https://github.com/Ming/ModuleB'
  s.author           = { 'Ming' => '13014795306@163.com' }
  s.source           = { :git => 'https://github.com/Ming/ModuleB.git', :tag => s.version.to_s }
  
  s.swift_version = '5.0'
  s.ios.deployment_target = '10.0'

  s.dependency 'ModuleServices'
  s.source_files = 'ModuleB/**/*'

end
