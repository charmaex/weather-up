platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'git@gitlab.com:charmaex/JDPodSpec.git'

target 'WeatherUp' do
  use_frameworks!

  pod 'Alamofire', '~> 4.0'
  pod 'JDCoordinator'

  target 'WeatherUpTests' do
    inherit! :search_paths
  end

  target 'WeatherUpUITests' do
    inherit! :search_paths
  end

end