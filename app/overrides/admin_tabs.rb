Deface::Override.new(:virtual_path      => "spree/layouts/admin",
                     :name              => "rewards_admin_tab",
                     :insert_bottom     => "[data-hook='admin_tabs']",
                     :text              => "<%= tab(:rewards) %>")

Deface::Override.new(:virtual_path      => "spree/layouts/admin",
                     :name              => "shipments_admin_tab",
                     :insert_bottom     => "[data-hook='admin_tabs']",
                     :text              => "<%= tab(:shipments) %>")

