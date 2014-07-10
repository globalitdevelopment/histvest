class DatagridExtended
	include Datagrid

	PAGE_SIZE = 20

	def last_page
		assets.length > PAGE_SIZE ? assets.length / PAGE_SIZE + (assets.length % PAGE_SIZE > 0 ? 1 : 0) : 1
	end
end
