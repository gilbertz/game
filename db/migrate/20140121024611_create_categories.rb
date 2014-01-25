class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.text     :re_js                                                             
      t.text     :re_css                                                            
      t.text     :re_html                                                           
      t.text     :meta                                                              
      t.integer  :category_id                                                       
      t.text     :html                                                              
      t.string   :name                                                              
      t.integer  :state                                                             
      t.text     :js                                                                
      t.text     :css 

      t.timestamps
    end
  end
end
