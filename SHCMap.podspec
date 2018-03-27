#
# Be sure to run `pod lib lint SHCMap.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SHCMap'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SHCMap.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/578013836@qq.com/SHCMap'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '578013836@qq.com' => '578013836@qq.com' }
  s.source           = { :git => 'https://github.com/578013836@qq.com/SHCMap.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'SHCMap/*'
end
