require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'roo'
require 'axlsx'
## doc = Nokogiri::HTML(open("http://www.radec.com.mx/catalogo?type=&brand=AUDI&model=&year=&search=&product_type=&new=&promo=&coming=&view=&btn_search=Buscar")) do |config|
# #	config.noblanks
# #endr


# http://www.radec.com.mx/sites/all/files/productos/207-0202-01.jpg

# 'CHEVROLET' => ['AVEO','CAMARO','CAPTIVA','CHEVY','CHEVY%20C2','CHEVY%20C3','CORSA','CRUZE','EPICA','EQUINOX','HHR','EXPRESS%20VAN','CORVETTE','MALIBU','MATIZ','MERIVA','OPTRA', 'SONIC','SPARK','SUBURBAN','TAHOE','TRACKER','TRAIL%20BRAZER','TRAVERSE','TRAX','UPLANDER','VECTRA','VENTURE','AVALANCHE','CHEYENNE','COLORADO','SILVERADO','TORNADO']
# 'CHRYSLER' => ['300', 'PACIFICA', 'TOWN%20COUNTRY', 'ASPEN', 'CIRRUS']
# 'DODGE' => ['ATTITUDE','CHALLENGER','CHARGER','DART','ATOS','AVENGER','CALIBER','CROSSFIRE','I10','JOURNEY']
# 'FORD' => ['ECOSPORT','ECONOLINE','EDGE','EXPEDITION','EXPLORER','ESCAPE','FIESTA','FIVE%20HUNDRED','FOCUS','FREESTAR','FUSION','IKON','MONDEO','KA','MUSTANG','TRANSIT','RANGER','TRANSIT','LOBO']
# 'HONDA' => ['ACCORD','CIVIC','CROSSSTOUR','CRZ','FIT','ODYSSEY','PILOT','CRV','CITY']
# 'JEEP' => ['COMMANDER','CHEROKEE','COMPASS','GRAND%20CHEROKEE','LIBERTY','WRANGLER','NITRO']
# 'MAZDA' => ['MAZDA%202','MAZDA%203', 'MAZDA%205','CX5','CX7','CX9','MX5']
# 'NISSAN' => ['350Z','370Z','ALTIMA','ARMADA','MAXIMA','MURANO','NOTE','PATHFINDER','PLATINA','SENTRA','TSURU','ALMERA','APRIO','JUKE','MARCH','MICRA','QUEST','ROGUE','TIIDA','URVAN','VERSA','X-TRAIL']
# 'RENAULT' => ['CLIO','DUSTER','FLUENCE','KANGOO','KOLEOS','LOGAN','MEGANE','SAFRANE','SANDERO','SCALA','SCENIC','STEPWAY']
# 'SEAT' => ['ALTEA','CORDOBA','EXEO','IBIZA','LEON','TOLEDO']
# 'TOYOTA' => ['4RUNNER','AVANZA','CAMRY','COROLLA','FJ%20CRUISER','HIGHLANDER','SIENNA','MATRIX','TUNDRA','HILUX','TACOMA','MR2%20SPYDER','YARIS','RAV4','HIACE','SEQUOIA','LAND%20CRUISER','RUSH','PRIUS']
# 'VOLKSWAGEN' => ['EUROVAN','JETTA','NUEVO%20JETTA','SHARAN','DERBY','LUPO','BORA','SPORTVAN','CRAFTER','ROUTAN','PASSAT%20CC', 'PASAT','GOL','TIGUAN','EOS','TRANSPORTER','SAVEIRO','CROSSFOX','TOUAREG','AMAROCK','BEETLE','POLO','VENTO','CADDY']

brands_models = {
	'CHEVROLET' => ['AVEO','CAMARO','CAPTIVA','CHEVY','CHEVY%20C2','CHEVY%20C3','CORSA','CRUZE','EPICA','EQUINOX','HHR','EXPRESS%20VAN','CORVETTE','MALIBU','MATIZ','MERIVA','OPTRA', 'SONIC','SPARK','SUBURBAN','TAHOE','TRACKER','TRAIL%20BRAZER','TRAVERSE','TRAX','UPLANDER','VECTRA','VENTURE','AVALANCHE','CHEYENNE','COLORADO','SILVERADO','TORNADO'],
	'CHRYSLER' => ['300', 'PACIFICA', 'TOWN%20COUNTRY', 'ASPEN', 'CIRRUS'],
	'DODGE' => ['ATTITUDE','CHALLENGER','CHARGER','DART','ATOS','AVENGER','CALIBER','CROSSFIRE','I10','JOURNEY'],
	'FORD' => ['ECOSPORT','ECONOLINE','EDGE','EXPEDITION','EXPLORER','ESCAPE','FIESTA','FIVE%20HUNDRED','FOCUS','FREESTAR','FUSION','IKON','MONDEO','KA','MUSTANG','TRANSIT','RANGER','TRANSIT','LOBO'],
	'HONDA' => ['ACCORD','CIVIC','CROSSSTOUR','CRZ','FIT','ODYSSEY','PILOT','CRV','CITY'],
	'JEEP' => ['COMMANDER','CHEROKEE','COMPASS','GRAND%20CHEROKEE','LIBERTY','WRANGLER','NITRO'],
	'MAZDA' => ['MAZDA%202','MAZDA%203', 'MAZDA%205','CX5','CX7','CX9','MX5'],
	'NISSAN' => ['350Z','370Z','ALTIMA','ARMADA','MAXIMA','MURANO','NOTE','PATHFINDER','PLATINA','SENTRA','TSURU','ALMERA','APRIO','JUKE','MARCH','MICRA','QUEST','ROGUE','TIIDA','URVAN','VERSA','X-TRAIL'],
	'RENAULT' => ['CLIO','DUSTER','FLUENCE','KANGOO','KOLEOS','LOGAN','MEGANE','SAFRANE','SANDERO','SCALA','SCENIC','STEPWAY'],
	'SEAT' => ['ALTEA','CORDOBA','EXEO','IBIZA','LEON','TOLEDO'],
	'TOYOTA' => ['4RUNNER','AVANZA','CAMRY','COROLLA','FJ%20CRUISER','HIGHLANDER','SIENNA','MATRIX','TUNDRA','HILUX','TACOMA','MR2%20SPYDER','YARIS','RAV4','HIACE','SEQUOIA','LAND%20CRUISER','RUSH','PRIUS'],
	'VOLKSWAGEN' => ['EUROVAN','JETTA','NUEVO%20JETTA','SHARAN','DERBY','LUPO','BORA','SPORTVAN','CRAFTER','ROUTAN','PASSAT%20CC', 'PASAT','GOL','TIGUAN','EOS','TRANSPORTER','SAVEIRO','CROSSFOX','TOUAREG','AMAROCK','BEETLE','POLO','VENTO','CADDY']
}


rowN = 1
brands_models.each do |brand, models|
	models.each do |model|
		position = 0
		p = Axlsx::Package.new
		wb = p.workbook
		wb.add_worksheet(:name => "Spares") do |sheet|
			while 1 do
				url = "http://www.radec.com.mx/catalogo?type\=\&brand\=#{brand}\&model\=#{model}\&year\=\&search\=\&product_type\=\&new\=\&promo\=\&coming\=\&view\=\&btn_search\=Buscar\&page\=#{position}"
				# puts "URL: #{url}"
				doc = Nokogiri::HTML(open(url)) do |config|
					config.noblanks
				end
				if doc.css('div.no-products').text != ''
					rowN = 1
					break
				end
				internal = 0
				# code = ""
				sheet.add_row ["Codigo Radec 1", "Codigo Radec 2", "Descripcion", "Precio", "Imagen"]
				doc.css('table.catalog_table').css('td').each do |node|
					sheet.add_row [nil, nil, nil, nil,nil]
					unless node.text == ""
						if internal == 0
							code = node.text
						end
						sheet.rows[rowN].cells[internal].value = node.text
						internal += 1
					end
					if internal == 4
						sheet.rows[rowN].cells[internal].value = "http://www.radec.com.mx/sites/all/files/productos/#{code}.jpg"
						rowN +=1
						internal = 0
					end

				end
				position += 1
			end
		end
		p.serialize("#{brand}_#{model}.xls")
	end
end



# no-products

# doc.css('tr')
# doc.css('tr').css('td').each do |node|
# 	puts node.text
# end


# Loop URL hasta que no haya mas pages


# Dentro de la pagina loop a los td, se mete la info de cada uno

# Se mete la imagen