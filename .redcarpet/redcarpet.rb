#!/usr/bin/env ruby

gem 'redcarpet'
gem 'coderay'

require 'redcarpet'
require 'coderay'

class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language)
        CodeRay.scan(code, language).div
    end
end

# Initializes a Markdown parser
options = {
    filter_html:     true,
    hard_wrap:       true,
    link_attributes: { rel: 'nofollow', target: "_blank" },
    space_after_headers: true,
    prettify: true
}

extensions = {
    autolink:           true,
    superscript:        true,
    fenced_code_blocks: true,
    disable_indented_code_blocks: true
}
renderer = CodeRayify.new(options)
markdown = Redcarpet::Markdown.new(renderer, extensions)

markdown_content = File.open('.redcarpet/github.md').read
html = markdown.render(markdown_content)

File.open('.redcarpet/build/README.html', 'w') {
    |file| file.write(html)
}