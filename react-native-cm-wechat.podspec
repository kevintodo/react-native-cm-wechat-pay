Pod::Spec.new do |s|
  s.name             = "react-native-cm-wechat"
  s.version          = "1.0.8"
  s.summary          = "A project committed to make file acess and data transfer easier, effiecient for React Native developers."
  s.requires_arc = true
  s.license      = 'MIT'
  s.homepage     = 'n/a'
  s.source       = { :git => "https://github.com/kevintodo/react-native-cm-wechat-pay"}
  s.author       = 'Kyle'
  s.source_files = 'ios/**/*.{h,m}'
  s.platform     = :ios, "8.0"
  s.dependency 'React-Core'
end
