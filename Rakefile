##
# Rakefile
# 2017 - Timothée Moulin
##

# Default task
task :default => [:spell_check]

# Run spell checking on all markdown (.md) files
task :spell_check do
  sh '.aspell/spell-check.sh'
end


# Convert the markdown files to one PDF
task :md_pdf do
  MDFILES = FileList["*.md"]
	PDFS = MDFILES.ext(".pdf")

	sh 'pandoc --latex-engine=xelatex README.md -f markdown -o README.pdf'
end


# Use redcarpet to convert markdown to html
task :md_html do
  require 'redcarpet'
  # Initializes a Markdown parser
  options = {
    filter_html:     true,
    hard_wrap:       true,
    link_attributes: { rel: 'nofollow', target: "_blank" },
    space_after_headers: true,
    fenced_code_blocks: true,
    prettify: true
  }
  
  extensions = {
    autolink:           true,
    superscript:        true,
    disable_indented_code_blocks: true
  }
  renderer = Redcarpet::Render::HTML.new(options)
  markdown = Redcarpet::Markdown.new(renderer, extensions)

  markdown_content = File.open('README.md').read
  html = markdown.render(markdown_content)

  File.open('.redcarpet/build/README.html', 'w') {
    |file| file.write(html)
  }
end
