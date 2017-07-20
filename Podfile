platform :ios, '9.0'

target 'waterapp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  if ['ctslin'].include?(ENV['USER'])
    pod 'SwiftEasyKit', :path => '../SwiftEasyKit'
    else
    pod 'SwiftEasyKit', :git => 'https://github.com/cactis/SwiftEasyKit.git'
  end

  target 'waterappTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'waterappUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
