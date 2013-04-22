module DOCXReport

  module Fields

    def field_replace!(_node, data_item = nil)

      txt = _node.inner_html

      @fields.each do |f|
        val = f.get_value(data_item)
        txt.gsub!(f.to_placeholder, sanitize(val))
      end

      _node.inner_html = txt

    end

    private

    def sanitize(txt)
      txt = html_escape(txt)
      txt = odf_linebreak(txt)
      txt
    end

    HTML_ESCAPE = { '&' => '&amp;',  '>' => '&gt;',   '<' => '&lt;', '"' => '&quot;' }

    def html_escape(s)
      return "" unless s
      s.to_s.gsub(/[&"><]/) { |special| HTML_ESCAPE[special] }
    end

    def odf_linebreak(s)
      return "" unless s
      s.to_s.gsub("\n", "</w:t><w:br/><w:t xml:space='preserve'>")
    end

  end

end