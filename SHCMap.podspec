Pod::Spec.new do |s|
  s.name             = 'SHCMap'
  s.version          = '0.1.0'
  s.summary          = '买家版高德地图的pod封装'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/578013836@qq.com/SHCMap'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '578013836@qq.com' => '578013836@qq.com' }
  s.source           = { :git => 'https://github.com/578013836@qq.com/SHCMap.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.dependency 'AMap2DMap'
  s.dependency 'AMapSearch'
  s.dependency 'AMapLocation'
  s.static_framework = true

  s.source_files = 'SHCMap/*'
end
