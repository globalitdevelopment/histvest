class ArticleReport < DatagridExtended
	scope do
		Article.order("articles.created_at desc")
	end

	filter(:title, :string) {|value| where("title ilike '#{value}%'")}
	filter(:content, :string) {|value| where("content ilike '#{value}%'")}  
	#date_range_filters(:updated_at)

	column(:actions, :html => true) { |article| render :partial => "/shared/check_box",:locals => { :s => article }}
	column(:title, :html => true ) { |article| can?(:update, Article) ? link_to(article.title, edit_article_path(article)) : article.title }
	column(:content)
	column(:created_at)
	column(:updated_at)  
	column(:published, :html => true) { |asset| asset.published? ? "<span style='padding:0 20px 0 30px;'>  #{image_tag('checked.png')} </span>" : "<span style='padding:0 20px 0 30px;'>  #{image_tag('checkbox.png')} </span>" }
end