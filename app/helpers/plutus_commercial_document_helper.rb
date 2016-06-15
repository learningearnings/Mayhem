module PlutusCommercialDocumentHelper
  def commercial_document_name transaction
    return "" unless transaction && transaction.commercial_document
    case transaction.commercial_document_type
      when 'Spree::Product'
      prod = transaction.spree_product
      if prod
        prod.name
      else
        ""
      end
      when "OtuCode"
        transaction.commercial_document.otu_code_category.name rescue ""
    else
      if transaction.commercial_document.respond_to?(name)
        transaction.commercial_document.name
      else
        ""
      end
    end    
  end
  
  def commercial_document_link transaction
    return unless transaction && transaction.commercial_document
    case transaction.commercial_document_type
      when 'Spree::Product'
      prod = transaction.spree_product
      if prod && !(prod.available_on.nil? || prod.available_on.future?)
        link_to(prod.name,spree.product_path(prod))
      elsif prod
        prod.name
      else
        ""
      end
      when "OtuCode"
        transaction.commercial_document.otu_code_category.name rescue nil
    else
      if transaction.commercial_document.respond_to?(name)
        transaction.commercial_document.name
      end
    end
  end
end
