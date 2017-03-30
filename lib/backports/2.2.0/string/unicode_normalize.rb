# Adapted from CRuby
# Copyright Ayumu Nojima (野島 歩) and Martin J. Dürst (duerst@it.aoyama.ac.jp)

unless String.method_defined? :unicode_normalize
  class String
    def unicode_normalize(form = :nfc)
      require 'backports/tools/normalize.rb' unless defined? UnicodeNormalize
      ## The following line can be uncommented to avoid repeated checking for
      ## UnicodeNormalize. However, tests didn't show any noticeable speedup
      ## when doing this. This comment also applies to the commented out lines
      ## in String#unicode_normalize! and String#unicode_normalized?.
      # String.send(:define_method, :unicode_normalize, ->(form = :nfc) { UnicodeNormalize.normalize(self, form) } )
      UnicodeNormalize.normalize(self, form)
    end

    def unicode_normalize!(form = :nfc)
      require 'backports/tools/normalize.rb' unless defined? UnicodeNormalize
      # String.send(:define_method, :unicode_normalize!, ->(form = :nfc) { replace(unicode_normalize(form)) } )
      replace(unicode_normalize(form))
    end

    def unicode_normalized?(form = :nfc)
      require 'backports/tools/normalize.rb' unless defined? UnicodeNormalize
      # String.send(:define_method, :unicode_normalized?, ->(form = :nfc) { UnicodeNormalize.normalized?(self, form) } )
      UnicodeNormalize.normalized?(self, form)
    end
  end
end
