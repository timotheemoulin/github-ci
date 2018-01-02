##
# Rakefile
# 2017 - Timothée Moulin
##

# Default task
task :default => [:spell_check]

# Run spell checking on all markdown (.md) files
task :spell_check do
  sh './bin/spell-check.sh'
end


# Convert the markdown files to one PDF
task :md_pdf do
  MDFILES = FileList["*.md"]
	PDFS = MDFILES.ext(".pdf")

	sh 'pandoc --latex-engine=xelatex README.md -f markdown -o README.pdf'
end
