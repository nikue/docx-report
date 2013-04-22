module DOCXReport

  class Text < Field

    attr_accessor :parser

    def replace!(doc, data_item = nil)

      return unless node = find_text_node(doc)

      text_value = get_value(data_item)

      @parser = Parser::Default.new(text_value, node)

      @parser.paragraphs.each do |p|
        node.before(p)
      end

      node.remove

    end

    private

    def find_text_node(doc)
      texts = doc.xpath(".//text:p[text()='#{to_placeholder}']")
      texts.empty? ? nil : texts.first
    end

  end

end