module GTD
  module EVENTS
    Dir[ File.dirname(__FILE__)+"/*.rb"].each {|file| require file }
  end
end
