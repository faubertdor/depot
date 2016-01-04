require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  
  def setup
    @product = products(:sample)
  end
  
  test "product attributes should not be empty" do
    product = Product.new
    assert_not product.valid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end
  
  test "price should be greater or equal to 0.01" do
    product = Product.new(title:       'A sample title',
                          description: 'The content of description',
                          image_url:   'cs.png')
    product.price = -1
    assert_not product.valid?
    assert_equal ['must be greater than or equal to 1 cent'], product.errors[:price]
    
    product.price = 0
    assert_not product.valid?
    assert_equal ['must be greater than or equal to 1 cent'], product.errors[:price]
    
    product.price = 1
    assert product.valid?
  end
  
  def new_product(image_url)
    Product.new(title:       'A sample title',
                description: 'The content of description',
                price:       1,
                image_url:   image_url)
  end
  
  test "image url" do
    good = %w{ img.gif img.png img.jpg IMG.JPG IMG.Jpg http://a.bc./x/y/z/img.png }
    bad  = %w{ img.doc img.docx img.gig/more img.gif.more }
    
    good.each do |img_url|
      assert new_product(img_url).valid?, "#{img_url} should be valid"
    end
    
    bad.each do |img_url|
      assert_not new_product(img_url).valid?, "#{img_url} should not be valid"
    end
  end
  
  test "product is not valid without a unique title - i18n" do
    product = Product.new(title:       @product.title,
                          description: 'An example',
                          image_url:   'cs.png',
                          price:       1)
    assert_not product.valid?
    assert_equal ['has already been taken'], product.errors[:title]
    #assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
  
  test "title length should 10 characters minimum" do
    @product.title = 'a' * 9
    assert_not @product.valid?
    assert_equal ['is too short (minimum is 10 characters)'], @product.errors[:title]
  end
end