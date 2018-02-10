# Initializes a Markdown parser
markdown = Redcarpet::Markdown.new()
html = markdown.render("This is *bongos*, indeed.")


p html