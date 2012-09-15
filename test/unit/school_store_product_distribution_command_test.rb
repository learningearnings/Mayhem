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
      mock_retail_product = mock "MasterProductCopy"
      mock_retail_products = mock "MasterProductCopies"
      mock_retail_product_master_variant = mock "RetailProductMasterVariant"
      mock_spree_property_class = mock "Spree::Property"
      mock_retail_price_property = mock "retail_price_property"
      mock_retail_quantity_property = mock "retail_quantity_property"
      mock_retail_product_relation = mock "retail_product_relation"
      mock_retail_product_properties = mock "retail_product_properties"
      mock_store_subdomain = mock "StoreSubdomain"
      mock_products = mock "StoreProducts"
      mock_school = mock "School"
      mock_school.stubs(:id)
      mock_store = mock "Spree::Store"
      mock_store.expects(:id)
      mock_store.expects(:products).returns(mock_products)
      mock_products.expects(:with_property_value).returns(mock_retail_products)
      mock_retail_products.expects(:exists?).returns(false)
      mock_master_product.stubs(:id).returns(1)
      mock_master_product.expects(:taxons).returns("master_taxons")
      mock_master_product.expects(:name).returns("master_product_name")
      mock_master_product.expects(:permalink).returns("master-product-permalink")
      mock_master_product.expects(:duplicate).returns(mock_retail_product)
      mock_master_product.expects(:description).returns("Master Product Description")
      mock_retail_product.stubs(:id).returns(2)
      mock_retail_product.expects(:name=)
      mock_retail_product.expects(:description=)
      mock_retail_product.expects(:available_on=)
      mock_retail_product.expects(:deleted_at=)
      mock_retail_product.expects(:permalink=)
      mock_retail_product.expects(:master).returns(mock_retail_product_master_variant).times(3)
      mock_retail_product.expects(:taxons=)
      mock_retail_product.expects(:count_on_hand=)
      mock_retail_product.expects(:store_ids=)
      mock_retail_product.expects(:set_property)
      mock_retail_product.expects(:save)
      mock_retail_product.expects(:product_properties).returns(mock_retail_product_properties).times(2)
      mock_retail_product_properties.expects(:where).returns(mock_retail_product_relation).times(2)
      mock_retail_product_relation.expects(:each).returns(mock_retail_price_property)
      mock_retail_product_relation.expects(:each).returns(mock_retail_quantity_property)
      mock_retail_price_property.expects(:id)
      mock_retail_quantity_property.expects(:id)

      mock_retail_product_master_variant.expects(:price=)
      mock_retail_product_master_variant.expects(:count_on_hand=)
      mock_retail_product_master_variant.expects(:save)

      mock_spree_property_class.expects(:find_by_name).returns(mock_retail_price_property)
      mock_spree_property_class.expects(:find_by_name).returns(mock_retail_quantity_property)
      mock_school.expects(:store).returns(mock_store)
      mock_school.expects(:store_subdomain).returns(mock_store_subdomain)
      mock_store_subdomain.expects(:+).returns("something")
      cmd = subject.new(:master_product => mock_master_product,
                        :school => mock_school,
                        :quantity => 1,
                        :retail_price => 1
                        )
      cmd.expects(:spree_property_class).returns(mock_spree_property_class).times(2)
      cmd.spree_property_class = mock_spree_property_class
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
      cmd.execute!
    end
  end
end
