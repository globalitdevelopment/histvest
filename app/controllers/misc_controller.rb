class MiscController < ApplicationController

  before_filter :authenticate_user!

  def index
    @orphan_locations = Location.where("#{Location.table_name}.id NOT IN (SELECT location_id FROM locations_topics)").count
    @num_unknown_references = Reference.where(reference_type_id: ReferenceType.find_by(name: "Ukjent")).count
    @articles = Article.all
  end

  def set_article
  	Article.update_all(:article_type => '')
  	article = Article.find(params['article_id'])
  	article.article_type = 'front_page'
  	article.save!
  	redirect_to misc_path
  end

  def delete_orphan_locations
    Location.where("#{Location.table_name}.id NOT IN (SELECT location_id FROM locations_topics)").delete_all
    flash[:success] = I18n.t("misc.orphans_successfully_removed")
    redirect_to misc_path
  end

  def repair_references
    Reference.where(reference_type_id: ReferenceType.find_by(name: "Ukjent")).each { |ref| 
      ref.update_attribute(:reference_type_id, ReferenceType::determine_type_id_from_url(ref.url))
    }
    flash[:success] = I18n.t("misc.references_successfully_repaired")
    redirect_to misc_path
  end

end
