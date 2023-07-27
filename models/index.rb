module Modusynth
  module Models
    autoload :Account, './models/account'
    autoload :AudioProcessor, './models/audio_processor'
    autoload :Category, './models/category'
    autoload :Concerns, './models/concerns/index'
    autoload :Link, './models/link'
    autoload :Module, './models/module'
    autoload :Modules, './models/modules/index'
    autoload :OAuth, './models/oauth/index'
    autoload :Permissions, './models/permissions/index'
    autoload :Synthesizer, './models/synthesizer'
    autoload :Session, './models/session'
    autoload :Social, './models/social/index'
    autoload :Tools, './models/tools/index'
    autoload :Tool, './models/tool'
  end
end