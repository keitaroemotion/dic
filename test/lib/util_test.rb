require "minitest/autorun"
require "./test/test_helper.rb"
require "./lib/util.rb"
require 'FileUtils'

class Lib::UtilTest < Minitest::Test
  def setup
    @util = Lib::Util
  end

  def test_nasty_format?
    assert Lib::Util.nasty_format?("oppai.xlsx")    
    assert Lib::Util.nasty_format?("xxvideo.ahan.xls")    
    assert Lib::Util.nasty_format?("korakora.docx")    
    refute Lib::Util.nasty_format?("sigoto-chu.dc")    
    refute Lib::Util.nasty_format?("yanke.txt")    
  end

  def test_parse_link
   assert_equal(
     "./etc/moomin_valley/ahomiyu.csv",
     Lib::Util.parse_link("[manuke](./etc/moomin_valley/ahomiyu.csv)")[1]
   )  
  end

  def test_ask
    assert_equal "boiiin", @util.ask("oppai", "boiiin")
  end

  def test_assure_file
    # TBD
  end

  def test_copy
    # TBD
  end

  def test_desterisk
    # TBD
  end

  def test_include_all?
    files = %w(
      moomin_daisuki
      hoahoa_moomoo
      moeeee_akiba
    )
    assert @util.include_all?("moe_aaa_akiba", %w(moe akiba))
    refute @util.include_all?("yayayaya", %w(moo moea))
    refute @util.include_all?("xxxbinini", %w(xxx moea))
  end

  def test_files_contains_keywords
    files = %w(
      moomin_daisuki
      hoahoa_moomoo
      moeeee_akiba
    )
    assert ["moeeee_akiba"], @util.files_contains_keywords(files, %w(moe akiba))
    assert files, @util.files_contains_keywords(files, %w(mo))
    assert files[1], @util.files_contains_keywords(files, %w(hoahoa))
  end

  def test_get_files
    # TBD
  end

  def test_http
    assert_equal(
      "http://oppai.com/oppai/boiin/moiin.php",
      @util.http("http://oppai.com/oppai/boiin/moiin.php").to_s
    )
    assert_equal(
      "http://oppai.com/oppai/boiin/moiin.php",
      @util.http("(http://oppai.com/oppai/boiin/moiin.php)").to_s
    )
    assert_equal(
      "http://oppai.com/oppai/boiin/moiin.php",
      @util.http("[oppao](http://oppai.com/oppai/boiin/moiin.php)").to_s
    )
    assert_equal(
      "https://oppai.com/oppai/boiin/moiin.php",
      @util.http("The United Nations announces yesterday: " +
                  "Please see the link here: " +
                  "[oppao](https://oppai.com/oppai/boiin/moiin.php) Okay?" +
                  "Your boobs are really really good!"
                  ).to_s
      )
    assert_equal(
      "",
      @util.http("[oppao](oppai.com/oppai/boiin/moiin.php) Okay?").to_s
    )  
  end

  def test_image_link?
    assert @util.image_link?("![oppai](boinboin/bakunyu/gyaru)")
    refute @util.image_link?("[oppai](boinboin/bakunyu/gyaru)")
    refute @util.image_link?("oppai](boinboin/bakunyu/gyaru)")
    refute @util.image_link?("[oppai(boinboin/bakunyu/gyaru)")
    refute @util.image_link?("![oppai]boinboin/bakunyu/gyaru")
  end

  def test_is_link?
    assert @util.is_link?("[oppai](/boinboin/bakunyu/gyaru)")
    refute @util.is_link?("![oppai](/boinboin/bakunyu/gyaru)")
    refute @util.is_link?("oppai](/boinboin/bakunyu/gyaru)")
    refute @util.is_link?("[oppai(/boinboin/bakunyu/gyaru)")
    refute @util.is_link?("[oppai]/boinboin/bakunyu/gyaru")
  end

  def test_match_image_pattern
    assert  @util.match_image_pattern("![matrix.png](images/201771815003690881matrix.png.png 500)")
  end

  def test_md_image_link
   root  = "/usr/local/etc/vol"
   shelf = "/usr/local/etc/vol/raw"
   link  = "[aaa](/usr/local/etc/raw/image/oppai.jpg)"  
   assert_equal "![aaa](/usr/local/etc/raw/image/oppai.jpg)", @util.md_image_link(link, root, shelf)
  end

  def test_pict_link?
    assert @util.pict_link?("![image](/aaa/bbb/ccc.jpg)")
    refute @util.pict_link?("[image](/aaa/bbb/ccc.jpg)")
  end

  def test_push_as_link
    dir  = "./etc/moomin_valley"

    def assert_suru(file, content, dir)
      require "colorize"
      puts file.green
      write(file, content)
      content = @util.push_as_link(dir, "floren", File.basename(file).gsub(".md", ""))
      FileUtils.rm file
      refute File.exist?(file)
      content
    end

    content = assert_suru("#{dir}/Links.md",    "\n# Links\n[oppai](boin)\n", dir)
    assert_equal "\n# Links\n[oppai](boin)\n- [floren](#{dir}/floren.md)\n", content

    content = assert_suru("#{dir}/links.md",    "\n# links\n[oppai](boin)\n", dir)
    assert_equal "\n# links\n[oppai](boin)\n- [floren](#{dir}/floren.md)\n", content

    content = assert_suru("#{dir}/Link.md",     "\n# Link\n[oppai](boin)\n", dir)
    assert_equal "\n# Link\n[oppai](boin)\n- [floren](#{dir}/floren.md)\n", content

    content = assert_suru("#{dir}/link.md",     "\n# link\n[oppai](boin)\n", dir)
    assert_equal "\n# link\n[oppai](boin)\n- [floren](#{dir}/floren.md)\n", content

    content = assert_suru("#{dir}/no_sharp.md", "\nlink\n[oppai](boin)\n", dir)

    assert_equal(
      "\nlink\n[oppai](boin)\n\n# Link\n- [floren](./etc/moomin_valley/floren.md)\n",
      content
    )  

    content = assert_suru("#{dir}/missing.md",  "\n[oppai](boin)\n", dir)
    assert_equal(
      "\n[oppai](boin)\n\n# Link\n- [floren](./etc/moomin_valley/floren.md)\n",
      content
    )
  end

  def test_regex_okay?
    # TBD
  end

  def test_remove_markdown?
    assert_equal "moeee", @util.remove_markdown("[tsukasa](/hiiragi/moeee.md)")
  end

  def test_markdown_link_format?
    assert @util.markdown_link_format?("[izumi konata](/lucky/star/kagamin.md)")
    refute @util.markdown_link_format?("[izumi konata](/lucky/star/kagamin.md")
    # refute @util.markdown_link_format?("izumi konata](/lucky/star/kagamin.md)")
  end

  def test_match?
    refute @util.match?("precur*", "aprecure")
    assert @util.match?("precur*", "precure")
    assert @util.match?("pr*re", "precure")
    assert @util.match?("prec+re", "preccre")
    assert @util.match?("recur", "precure")
    assert @util.match?("*recure", "precure")
    refute @util.match?("*recu", "precure")
    assert @util.match?("p[a-z][eE0]cu[rR]e", "precure")
    assert @util.match?("*recur*", "precure")
    refute @util.match?("*racur*", "precure")
    assert @util.match?("p(recu|rocu)re", "precure")
    assert @util.match?("prec[^i]re", "precure")
  end

  def test_option?
    assert @util.option?("-a") 
    refute @util.option?("aa-") 
  end

  def test_show
    # TBD
  end

  def test_vim_prone_format?
    assert Lib::Util.vim_prone_format?("oppai.txt")    
    assert Lib::Util.vim_prone_format?("puriketsu.csv")    
    refute Lib::Util.vim_prone_format?("puriketsu.md")    
    refute Lib::Util.vim_prone_format?("puriketsu")    
    refute Lib::Util.vim_prone_format?("puriketsu.xlsx")    
  end

  private

  def write(file, content)
    f = File.open(file, "w")
    f.puts content
    f.close
  end
end
