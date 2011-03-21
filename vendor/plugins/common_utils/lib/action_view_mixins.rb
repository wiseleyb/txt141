module ActionView
  module Helpers
    module PrototypeHelper
      def link_to_remote(name, options = {}, html_options = nil)
         html_options ||= {}
         html_options[:href] ||= options[:url]
         link_to_function(name, remote_function(options), html_options || options.delete(:html))
      end
    end
  end
end