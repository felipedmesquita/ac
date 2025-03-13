require "ac"
module Ac
  class AcObjectTest < TLDR
    def test_access_options
      item = AcObject.new(meli_hash)
      assert_equal 'MLB', item.site_id
      assert_equal 'MLB', item[:site_id]
      assert_equal 'MLB', item['site_id']
    end

    def test_nesting
      item = AcObject.new(meli_hash)
      first_picture_size = item.pictures.first.size
      assert_equal '500x422', first_picture_size
    end

    def test_double_nesting
      heard_you_like_arrays = {
        'list' => [[{ 'level' => 2 }]]
      }
      levels = AcObject.new(heard_you_like_arrays)
      assert_equal 2, levels.list.first.first.level
    end

    def test_no_overides
      troublesome_keys = AcObject.new({ 'class' => 'no dot' })
      assert_equal 'no dot', troublesome_keys[:class]
      assert_equal AcObject, troublesome_keys.class
    end

    def test_to_s_runs
      AcObject.new('pretty' => 'print').to_s
    end

    def test_inspect
      product = AcObject.new({ 'id' => 44 })
      expected = <<~TEXT
        #<Ac::AcObject:0x#{product.object_id.to_s(16)} id=44> JSON: {
          "id": 44
        }
      TEXT
      assert_equal expected.chomp, product.inspect
    end

    def test_input_with_symbol_keys
      why = AcObject.new({ not_a_string: true })
      assert_equal true, why.not_a_string
    end

    def test_equality
      a = AcObject.new a: 1
      b = AcObject.new a: 1
      assert a == b
      assert a.eql?(b)
      c = AcObject.new a: 2
      refute c == a
      refute c.eql? a
    end

    def test_keys_and_values
      color = AcObject.new r: 102, g: 51, b: 153
      assert_equal ["r", "g", "b"], color.keys
      assert_equal [102, 51, 153], color.values
    end

    def test_array_at_root_level
      root_array = AcObject.new([1, 2, 3])
      assert_equal 1, root_array.first
    end

    def test_nested_arrays_at_root_level
      root_array = AcObject.new([[{nested: "level 2"}], 2, 3])
      assert_equal "level 2", root_array.first.first.nested
    end

    def meli_hash
      {
        'id' => 'MLB1578157865',
        'site_id' => 'MLB',
        'title' => 'Kit C/100 Envelope Embalagem Segurança Envio Correio 20x32',
        'seller_id' => 161_497_576,
        'category_id' => 'MLB270586',
        'official_store_id' => nil,
        'price' => 58.47,
        'base_price' => 58.47,
        'original_price' => nil,
        'currency_id' => 'BRL',
        'initial_quantity' => 1644,
        'sale_terms' => [],
        'buying_mode' => 'buy_it_now',
        'listing_type_id' => 'gold_special',
        'condition' => 'new',
        'permalink' => 'https://produto.mercadolivre.com.br/MLB-1578157865-kit-c100-envelope-embalagem-seguranca-envio-correio-20x32-_JM',
        'thumbnail_id' => '757425-MLB80428682692_112024',
        'thumbnail' => 'http://http2.mlstatic.com/D_757425-MLB80428682692_112024-I.jpg',
        'pictures' => [{ 'id' => '757425-MLB80428682692_112024',
                        'url' => 'http://http2.mlstatic.com/D_757425-MLB80428682692_112024-O.jpg', 'secure_url' => 'https://http2.mlstatic.com/D_757425-MLB80428682692_112024-O.jpg', 'size' => '500x422', 'max_size' => '1200x1014', 'quality' => '' }]
      }
    end
  end
end
