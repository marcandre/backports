if (Backports::TARGET_VERSION rescue false) # Conf loaded at different times, not sure why
  FrozenError ||= RuntimeError

  class MSpecScript
    # The set of substitutions to transform a spec filename
    # into a tag filename.
    main_version = RUBY_VERSION
    unless File.exist?(File.expand_path("../lib/backports/#{main_version}.rb", __FILE__))
      main_version = main_version.sub(/\.\d+$/, '.0')
    end

    set :tags_patterns, [ [%r(rubyspec/), "tags/#{main_version}/"] ]
  end

  if Backports::TARGET_VERSION > RUBY_VERSION
    if SpecGuard.respond_to? :ruby_version_override=
     SpecGuard.ruby_version_override = Backports::TARGET_VERSION
    else
      class VersionGuard
        remove_const :FULL_RUBY_VERSION
        FULL_RUBY_VERSION = SpecVersion.new Backports::TARGET_VERSION
      end
    end
  end
end
