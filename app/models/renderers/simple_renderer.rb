require 'render_anywhere'
class SimpleRenderer
	include RenderAnywhere

	# my adding
	include ActionView::Helpers::FormHelper

	def self.self_instance
		@simple_renderer ||= SimpleRenderer.new
	end



	def self.render_to_js(args = {})
		instance = SimpleRenderer.self_instance
		rendered_source = instance.render(args)
		escaped_source = self.js_escape(rendered_source)

		escaped_source
	end


	def self.js_escape(str)
		html = str
		escaped_html = html.gsub(/\"/, "\\\"").gsub(/\'/, "\\\"")
		escaped_html
	end

	# def self._to_partial_path
 #        @_to_partial_path ||= name.demodulize.underscore.sub!(/_builder$/, '')
 #      end

 #      def to_partial_path
 #        self.class._to_partial_path
 #      end
end