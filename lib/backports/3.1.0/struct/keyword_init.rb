unless Struct.respond_to?(:keyword_init?)
  def Struct.keyword_init?
    new(1) && false rescue true
  end
end
