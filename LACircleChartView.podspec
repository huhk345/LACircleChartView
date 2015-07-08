#
# Be sure to run `pod lib lint LACircleChartView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LACircleChartView"
  s.version          = "1.0.0"
  s.summary          = "An Ios circle chart View"
  s.description      = <<-DESC
                       An circle view which can display part of circle

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/huhk345/LACircleChartView"
  s.license          = 'Apache 2.0'
  s.author           = { "LakeR" => "njlaker@gmail.com" }
  s.source           = { :git => "https://github.com/huhk345/LACircleChartView.git", :tag => s.version.to_s }


  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'LACircleChartView' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
