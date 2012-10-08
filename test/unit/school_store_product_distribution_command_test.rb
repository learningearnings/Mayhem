require 'test_helper'
require_relative '../../app/models/school_store_product_distribution_command'

describe SchoolStoreProductDistributionCommand do
  subject { SchoolStoreProductDistributionCommand }

  before do

  end

  describe 'validations' do
    it "requires valid parameters" do
      subject.new.wont have_valid(:master_product).when(nil)
      subject.new.wont have_valid(:school).when(nil)
      subject.new.must have_valid(:retail_price).when(1)
      subject.new.must have_valid(:quantity).when(1)
    end
  end

  describe 'product copy' do
    it 'copies the master product when execute! is called and the retail product does not exist' do
      mock_master_product = mock "MasterProduct"
      mock_master_master_product = mock "MasterProduct#master"
      mock_image = mock "image"
      mock_attachment = mock "attachment"
      mock_attachment.expects(:path).returns(File.join(File.dirname(__FILE__), '../../app/assets/images/le_logo.png'))
      mock_image.expects(:attachment).returns(mock_attachment)
      mock_master_master_product.expects(:images).returns([mock_image])
      mock_master_product.expects(:master).returns(mock_master_master_product)
      mock_retail_product = mock "MasterProductCopy"
      mock_retail_master = mock "Retail Master"
      mock_retail_master.stubs(:images).returns([])
      mock_retail_product.stubs(:master).returns(mock_retail_master)
      mock_retail_products = mock "MasterProductCopies"
      mock_retail_product_master_variant = mock "RetailProductMasterVariant"
      mock_spree_property_class = mock "Spree::Property"
      mock_spree_product_filter_link_class = mock "SpreeProductFilterLink"
      mock_spree_product_person_link_class = mock "SpreeProductPersonLink"
      mock_spree_image_class = mock "Spree::Image"
      mock_image = mock "Spree::Image instance"
      mock_image.stubs(:attachment=)
      mock_image.stubs(:save)
      mock_spree_image_class.stubs(:new).returns(mock_image)
      mock_filter_conditions_class = "FilterConditions"
      mock_filter_factory_class = "FilterFactoryClass"
      mock_filter_factory = "FilterFactory"
      mock_filter = mock "Filter"
      mock_filter.stubs(:id).returns(1)
      mock_filter_factory_class = mock "FilterFactory"
      mock_filter_conditions_class.stubs(:new)
      mock_filter_factory_class.stubs(:new).returns(mock_filter_factory)
      mock_filter_factory.stubs(:find_or_create_filter).returns(mock_filter)
      mock_retail_price_property = mock "retail_price_property"
      mock_retail_quantity_property = mock "retail_quantity_property"
      mock_retail_product_relation = mock "retail_product_relation"
      mock_retail_product_properties = mock "retail_product_properties"
      mock_store_subdomain = mock "StoreSubdomain"
      mock_products = mock "StoreProducts"
      mock_spree_products = mock "Spree::Product"
      mock_spree_products.expects(:new).returns(mock_retail_product)
      mock_school = mock "School"
      mock_school.stubs(:id)
      mock_person = mock "Person"
      person_id = mock
      mock_person.stubs(:id).returns(person_id)
      mock_store = mock "Spree::Store"
      mock_store.expects(:id)
      mock_store.expects(:products).returns(mock_products)
      mock_products.expects(:with_property_value).returns(mock_retail_products)
      mock_retail_products.expects(:exists?).returns(false)
      mock_master_product.stubs(:id).returns(1)
      mock_master_product.expects(:taxons).returns(["master_taxons"])
      mock_master_product.expects(:name).returns("master_product_name")
      mock_master_product.expects(:permalink).returns("master-product-permalink")
      mock_master_product.expects(:description).returns("Master Product Description")
      product_id = mock
      mock_retail_product.stubs(:id).returns(product_id)
      mock_retail_product.stubs(:properties).returns(mock_retail_product_properties)
      mock_retail_product_properties.expects(:create).with(name: 'type', presentation: 'retail')
      mock_retail_product.expects(:name=)
      mock_retail_product.expects(:description=)
      mock_retail_product.expects(:available_on=)
      mock_retail_product.expects(:deleted_at=)
      mock_retail_product.expects(:permalink=)
      mock_retail_product.expects(:shipping_category=)
      mock_retail_product.expects(:master).returns(mock_retail_product_master_variant).times(3)
      mock_retail_product.expects(:taxons=)
      mock_retail_product.expects(:count_on_hand=)
      mock_retail_product.expects(:store_ids=)
      mock_retail_product.expects(:set_property)
      mock_retail_product.expects(:save)

      mock_retail_product_master_variant.expects(:price=)
      mock_retail_product_master_variant.stubs(:id).returns(1)
      mock_retail_product_master_variant.expects(:count_on_hand=)

      mock_spree_property_class.expects(:find_by_name).returns(mock_retail_price_property)
      mock_spree_property_class.expects(:find_by_name).returns(mock_retail_quantity_property)
      mock_spree_product_filter_link_class.expects(:create)
      mock_spree_product_person_link_class.expects(:create).with(person_id: person_id, product_id: product_id)
      mock_school.expects(:store).returns(mock_store)
      mock_school.expects(:store_subdomain).returns(mock_store_subdomain)
      mock_store_subdomain.expects(:+).returns("something")
      cmd = subject.new(:master_product => mock_master_product,
                        :school => mock_school,
                        :person => mock_person,
                        :quantity => 1,
                        :retail_price => 1
                        )
      cmd.expects(:spree_property_class).returns(mock_spree_property_class).times(2)
      cmd.spree_property_class = mock_spree_property_class
      cmd.spree_product_class = mock_spree_products
      cmd.spree_product_filter_link_class = mock_spree_product_filter_link_class
      cmd.spree_product_person_link_class = mock_spree_product_person_link_class
      cmd.spree_image_class = mock_spree_image_class
      cmd.filter_conditions_class = mock_filter_conditions_class
      cmd.filter_factory_class = mock_filter_factory_class
      cmd.execute!
    end

    it 'adds the quantity to the retail product quantity when execute! is called and the retail product does exist' do
      mock_master_product = mock "MasterProduct"
      mock_retail_product = mock "MasterProductCopy"
      mock_retail_products = mock "MasterProductCopies"
      mock_retail_product_master_variant = mock "RetailProductMasterVariant"
      mock_products = mock "StoreProducts"
      mock_school = mock "School"
      mock_store = mock "Spree::Store"
      mock_spree_product_filter_link_class = "SpreeProductFilterLink"
      mock_spree_product_person_link_class = "SpreeProductPersonLink"
      mock_filter_conditions_class = "FilterConditions"
      mock_filter_factory_class = "FilterFactory"
      mock_school.expects(:store).returns(mock_store)
      mock_store.expects(:products).returns(mock_products).times(2)
      mock_products.expects(:with_property_value).returns(mock_retail_products).times(2)
      mock_retail_products.expects(:exists?).returns(true)
      mock_retail_products.expects(:first).returns(mock_retail_product)
      mock_master_product.expects(:id).returns(1).times(2)
      mock_master_product.expects(:taxons).returns("master_taxons")
      mock_retail_product.expects(:master).returns(mock_retail_product_master_variant).times(2)
      mock_retail_product.expects(:taxons=)
      mock_retail_product_master_variant.expects(:count_on_hand=)
      mock_retail_product_master_variant.expects(:count_on_hand).returns(0)
      mock_retail_product_master_variant.expects(:save)

      cmd = subject.new(:master_product => mock_master_product,
                        :school => mock_school,
                        :quantity => 1,
                        :retail_price => 1
                        )
      cmd.spree_product_filter_link_class = mock_spree_product_filter_link_class
      cmd.spree_product_person_link_class = mock_spree_product_person_link_class
      cmd.filter_conditions_class = mock_filter_conditions_class
      cmd.filter_factory_class = mock_filter_factory_class
      cmd.execute!
    end
  end
end
