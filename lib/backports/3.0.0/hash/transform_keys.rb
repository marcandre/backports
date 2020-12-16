class Hash
  unless ({}.transform_keys(:x => 1) rescue false)
    require 'backports/2.5.0/hash/transform_keys'
    require 'backports/tools/alias_method_chain'

    def transform_keys_with_hash_arg(hash = not_given = true, &block)
      return to_enum(:transform_keys) { size } if not_given && !block

      return transform_keys_without_hash_arg(&block) if not_given

      h = {}
      if block_given?
        each do |key, value|
          h[hash.fetch(key) { yield key }] = value
        end
      else
        each do |key, value|
          h[hash.fetch(key, key)] = value
        end
      end
      h
    end
    Backports.alias_method_chain self, :transform_keys, :hash_arg

    def transform_keys_with_hash_arg!(hash = not_given = true, &block)
      return enum_for(:transform_keys!) { size } if not_given && !block

      return transform_keys_without_hash_arg!(&block) if not_given

      h = {}
      begin
        if block_given?
          each do |key, value|
            h[hash.fetch(key) { yield key }] = value
          end
        else
          each do |key, value|
            h[hash.fetch(key, key)] = value
          end
        end
      ensure
        replace(h)
      end
      self
    end
    Backports.alias_method_chain self, :transform_keys!, :hash_arg
  end
end
