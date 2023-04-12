Pod::Spec.new do |s|

  s.name    = 'Voodu'
  s.version = '1.1.0'
  s.summary = 'Swift context menu library for iOS. Powered by magic.'

  s.description = <<-DESC
  Voodu is a Swift context menu library for iOS that simplifies the creation,
  presentation, & interaction of menus, context menus, & shortcut menus.
  Powered completely by magic. 
  DESC

  s.homepage                = 'https://github.com/mitchtreece/Voodu'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = { 'Mitch Treece' => 'mitchtreece@me.com' }
  s.source                  = { :git => 'https://github.com/mitchtreece/Voodu.git', :tag => s.version.to_s }
  s.social_media_url        = 'https://twitter.com/mitchtreece'

  s.swift_version           = '5'
  s.ios.deployment_target   = '13.0'
  s.source_files            = 'Sources/Core/**/*'

end