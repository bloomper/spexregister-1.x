# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Users
user = User.new :username => 'admin@chalmersspexet.se', :password => 'admin99', :password_confirmation => 'admin99', :user_groups => [ UserGroup.find_by_name('Administrators'), UserGroup.find_by_name('Users') ], :state => 'active'
user.save(false)
user = User.new :username => 'user@chalmersspexet.se', :password => 'user99', :password_confirmation => 'user99', :user_groups => [ UserGroup.find_by_name('Users') ], :state => 'active'
user.save(false)

# Tags
Tag.create :name => 'Info-spex'
Tag.create :name => 'Prat-spex'

# Function categories
FunctionCategory.create :name => 'Kommitté'
FunctionCategory.create :name => 'Orkester'
FunctionCategory.create :name => 'Ensemble', :has_actor => true
FunctionCategory.create :name => 'Bandet'
FunctionCategory.create :name => 'Annat'

# Spex categories
SpexCategory.create :name => 'Bobspexet', :first_year => '2003'
SpexCategory.create :name => 'Veraspexet', :first_year => '2003'
SpexCategory.create :name => 'Chalmersspexet', :first_year => '1948'
SpexCategory.create :name => 'Jubileumsspex', :first_year => '1948'

annat_function_category = FunctionCategory.find_by_name('Annat')
bandet_function_category = FunctionCategory.find_by_name('Bandet')
orkester_function_category = FunctionCategory.find_by_name('Orkester')
kommitte_function_category = FunctionCategory.find_by_name('Kommitté')
ensemble_function_category = FunctionCategory.find_by_name('Ensemble')

# Functions
Function.create :name => 'Affisch', :function_category => annat_function_category
Function.create :name => 'Altsaxofon', :function_category => bandet_function_category
Function.create :name => 'Arkitekt', :function_category => kommitte_function_category
Function.create :name => 'Arrangör', :function_category => annat_function_category
Function.create :name => 'Bas', :function_category => orkester_function_category
Function.create :name => 'Bas', :function_category => bandet_function_category
Function.create :name => 'Basklarinett', :function_category => orkester_function_category
Function.create :name => 'Bastuba', :function_category => orkester_function_category
Function.create :name => 'Blockflöjt', :function_category => orkester_function_category
Function.create :name => 'Casseur', :function_category => kommitte_function_category
Function.create :name => 'Cello', :function_category => orkester_function_category
Function.create :name => 'Cello 1', :function_category => orkester_function_category
Function.create :name => 'Cello 2', :function_category => orkester_function_category
Function.create :name => 'Dekoratör', :function_category => kommitte_function_category
Function.create :name => 'Designer', :function_category => kommitte_function_category
Function.create :name => 'Directeur', :function_category => kommitte_function_category
Function.create :name => 'Directeursassistent', :function_category => kommitte_function_category
Function.create :name => 'Elfiol', :function_category => bandet_function_category
Function.create :name => 'Ensemblist', :function_category => ensemble_function_category
Function.create :name => 'Exspextor', :function_category => kommitte_function_category
Function.create :name => 'Fagott', :function_category => orkester_function_category
Function.create :name => 'Festdirecteur', :function_category => kommitte_function_category
Function.create :name => 'Festroddare', :function_category => kommitte_function_category
Function.create :name => 'Flöjt', :function_category => orkester_function_category
Function.create :name => 'Fotografiker', :function_category => kommitte_function_category
Function.create :name => 'Författare', :function_category => annat_function_category
Function.create :name => 'Gitarr', :function_category => bandet_function_category
Function.create :name => 'Horn', :function_category => orkester_function_category
Function.create :name => 'Info-chef', :function_category => kommitte_function_category
Function.create :name => 'Inspextor', :function_category => kommitte_function_category
Function.create :name => 'Inspextris', :function_category => kommitte_function_category
Function.create :name => 'Inspicient', :function_category => kommitte_function_category
Function.create :name => 'Inspicientassistent', :function_category => kommitte_function_category
Function.create :name => 'Kapellmästare', :function_category => orkester_function_category
Function.create :name => 'Klarinett', :function_category => orkester_function_category
Function.create :name => 'Klarinett', :function_category => bandet_function_category
Function.create :name => 'Kommittéledamot', :function_category => kommitte_function_category
Function.create :name => 'Kontrabas', :function_category => orkester_function_category
Function.create :name => 'Koreograf', :function_category => annat_function_category
Function.create :name => 'Ljudmästare', :function_category => kommitte_function_category
Function.create :name => 'Ljusmästare', :function_category => kommitte_function_category
Function.create :name => 'Ljudroddare', :function_category => kommitte_function_category
Function.create :name => 'Ljusroddare', :function_category => kommitte_function_category
Function.create :name => 'Mandolin', :function_category => bandet_function_category
Function.create :name => 'Mediamästare', :function_category => kommitte_function_category
Function.create :name => 'Musikproducent', :function_category => annat_function_category
Function.create :name => 'Oboe', :function_category => orkester_function_category
Function.create :name => 'Oboeflöjt', :function_category => orkester_function_category
Function.create :name => 'Okänt', :function_category => annat_function_category
Function.create :name => 'Okänt', :function_category => orkester_function_category
Function.create :name => 'Okänt', :function_category => bandet_function_category
Function.create :name => 'Organisateur', :function_category => kommitte_function_category
Function.create :name => 'Orkester', :function_category => orkester_function_category
Function.create :name => 'PR-chef', :function_category => kommitte_function_category
Function.create :name => 'PR/Info-stab', :function_category => kommitte_function_category
Function.create :name => 'PR-roddare', :function_category => kommitte_function_category
Function.create :name => 'Panblåsare', :function_category => orkester_function_category
Function.create :name => 'Pianör', :function_category => orkester_function_category
Function.create :name => 'Pianör', :function_category => bandet_function_category
Function.create :name => 'Producent', :function_category => annat_function_category
Function.create :name => 'Regisseur', :function_category => annat_function_category
Function.create :name => 'Saxofon', :function_category => bandet_function_category
Function.create :name => 'Saxofon', :function_category => orkester_function_category
Function.create :name => 'Scen', :function_category => kommitte_function_category
Function.create :name => 'Scenmästare', :function_category => kommitte_function_category
Function.create :name => 'Scenograf', :function_category => kommitte_function_category
Function.create :name => 'Scenroddare', :function_category => kommitte_function_category
Function.create :name => 'Sekreterare', :function_category => kommitte_function_category
Function.create :name => 'Skivkommitté', :function_category => kommitte_function_category
Function.create :name => 'Skräddare', :function_category => kommitte_function_category
Function.create :name => 'Slagverk', :function_category => orkester_function_category
Function.create :name => 'Sopransaxofon', :function_category => orkester_function_category
Function.create :name => 'Sufflör', :function_category => kommitte_function_category
Function.create :name => 'Sömmerska', :function_category => kommitte_function_category
Function.create :name => 'Tenorsaxofon', :function_category => bandet_function_category
Function.create :name => 'Trombon', :function_category => orkester_function_category
Function.create :name => 'Trombon', :function_category => bandet_function_category
Function.create :name => 'Trummor', :function_category => orkester_function_category
Function.create :name => 'Trummor', :function_category => bandet_function_category
Function.create :name => 'Trumpet', :function_category => orkester_function_category
Function.create :name => 'Trumpet', :function_category => bandet_function_category
Function.create :name => 'Tvärflöjt', :function_category => orkester_function_category
Function.create :name => 'Upplysare', :function_category => kommitte_function_category
Function.create :name => 'Valthorn', :function_category => orkester_function_category
Function.create :name => 'Viola', :function_category => orkester_function_category
Function.create :name => 'Violacello', :function_category => orkester_function_category
Function.create :name => 'Violin', :function_category => orkester_function_category
Function.create :name => 'Violin 1', :function_category => orkester_function_category
Function.create :name => 'Violin 2', :function_category => orkester_function_category
Function.create :name => 'Vistextförfattare', :function_category => annat_function_category

bob_spex_category = SpexCategory.find_by_name('Bobspexet')
vera_spex_category = SpexCategory.find_by_name('Veraspexet')
chalmers_spex_category = SpexCategory.find_by_name('Chalmersspexet')
jubileums_spex_category = SpexCategory.find_by_name('Jubileumsspex')

# Spex and their revivals
spex = Spex.create :year => '1948', :spex_detail_attributes => {:title => 'Bojan'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '2000', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

Spex.create :year => '1949', :spex_detail_attributes => {:title => 'Erik XIV'}, :spex_category => chalmers_spex_category

spex = Spex.create :year => '1950', :spex_detail_attributes => {:title => 'Caesarion'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1953', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)
revival = Spex.create(:year => '1978', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)
revival_2 = Spex.create(:year => '2008', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival_2.move_to_left_of(revival)
revival_3 = Spex.create(:year => '2010', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival_3.move_to_left_of(revival_2)

Spex.create :year => '1951', :spex_detail_attributes => {:title => 'Scheherazade'}, :spex_category => chalmers_spex_category

spex = Spex.create :year => '1952', :spex_detail_attributes => {:title => 'Anna'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1983', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)
revival_2 = Spex.create(:year => '2002', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival_2.move_to_left_of(revival)

spex = Spex.create :year => '1954', :spex_detail_attributes => {:title => 'Henrik VIII'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1968', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)
revival_2 = Spex.create(:year => '1998', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival_2.move_to_left_of(revival)

spex = Spex.create :year => '1955', :spex_detail_attributes => {:title => 'Gustav E:son Vasa'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1988', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1956', :spex_detail_attributes => {:title => 'Napoleon'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1985', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

Spex.create :year => '1957', :spex_detail_attributes => {:title => 'Statyerna'}, :spex_category => chalmers_spex_category

Spex.create :year => '1958', :spex_detail_attributes => {:title => 'Lucrezia'}, :spex_category => chalmers_spex_category

spex = Spex.create :year => '1959', :spex_detail_attributes => {:title => 'Katarina II'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1977', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

Spex.create :year => '1960', :spex_detail_attributes => {:title => 'Starke August'}, :spex_category => chalmers_spex_category

Spex.create :year => '1961', :spex_detail_attributes => {:title => 'Klodvig'}, :spex_category => chalmers_spex_category

spex = Spex.create :year => '1962', :spex_detail_attributes => {:title => 'Don Pedro'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1981', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1963', :spex_detail_attributes => {:title => 'Charles II'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1976', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1964', :spex_detail_attributes => {:title => 'Nebukadnessar'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1974', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1965', :spex_detail_attributes => {:title => 'Sven Duva'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1993', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1966', :spex_detail_attributes => {:title => 'Montezuma'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1971', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1967', :spex_detail_attributes => {:title => 'Alexander'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1972', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1968', :spex_detail_attributes => {:title => 'Richard III'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1973', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1969', :spex_detail_attributes => {:title => 'Margareta'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1975', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1970', :spex_detail_attributes => {:title => 'George Washington'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1980', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)
revival_2 = Spex.create(:year => '1998', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival_2.move_to_left_of(revival)

spex = Spex.create :year => '1971', :spex_detail_attributes => {:title => 'Noak'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1986', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1972', :spex_detail_attributes => {:title => 'Turandot'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1989', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

Spex.create :year => '1973', :spex_detail_attributes => {:title => 'Fredrik den Store'}, :spex_category => chalmers_spex_category

spex = Spex.create :year => '1974', :spex_detail_attributes => {:title => 'Sherlock Holmes'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1991', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1975', :spex_detail_attributes => {:title => 'Lionardo da Vinci'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1982', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1976', :spex_detail_attributes => {:title => 'Ludvig XIV'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '2001', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1977', :spex_detail_attributes => {:title => 'Nils Dacke'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1990', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1978', :spex_detail_attributes => {:title => 'Dr Livingstone'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1995', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1979', :spex_detail_attributes => {:title => 'Nero'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1987', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

Spex.create :year => '1979', :spex_detail_attributes => {:title => 'Knappt ett Chalmersspex'}, :spex_category => jubileums_spex_category

spex = Spex.create :year => '1980', :spex_detail_attributes => {:title => 'Tutankhamon'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1997', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1981', :spex_detail_attributes => {:title => 'Ludwig van Beethoven'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1992', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)
revival_2 = Spex.create(:year => '1998', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival_2.move_to_left_of(revival)

spex = Spex.create :year => '1982', :spex_detail_attributes => {:title => 'John Ericsson'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1999', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1983', :spex_detail_attributes => {:title => 'Filip II'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '2007', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1984', :spex_detail_attributes => {:title => 'Lasse-Maja'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1994', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

Spex.create :year => '1985', :spex_detail_attributes => {:title => 'Olof Skötkonung'}, :spex_category => chalmers_spex_category

spex = Spex.create :year => '1986', :spex_detail_attributes => {:title => 'Victoria'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1996', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1987', :spex_detail_attributes => {:title => 'Montgomery'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '2005', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

spex = Spex.create :year => '1988', :spex_detail_attributes => {:title => 'Svartskägg'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '2008', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

Spex.create :year => '1989', :spex_detail_attributes => {:title => 'Christina'}, :spex_category => chalmers_spex_category

spex = Spex.create :year => '1990', :spex_detail_attributes => {:title => 'Klondike'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '1998', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

Spex.create :year => '1991', :spex_detail_attributes => {:title => 'Gutenberg'}, :spex_category => chalmers_spex_category

Spex.create :year => '1992', :spex_detail_attributes => {:title => 'Krösus'}, :spex_category => chalmers_spex_category

Spex.create :year => '1993', :spex_detail_attributes => {:title => 'Stradivarius'}, :spex_category => chalmers_spex_category
revival = Spex.create(:year => '2006', :spex_detail => spex.spex_detail, :spex_category => spex.spex_category)
revival.move_to_child_of(spex)

Spex.create :year => '1994', :spex_detail_attributes => {:title => 'Ivan den förskräcklige'}, :spex_category => chalmers_spex_category

Spex.create :year => '1995', :spex_detail_attributes => {:title => 'Snorre'}, :spex_category => chalmers_spex_category

Spex.create :year => '1996', :spex_detail_attributes => {:title => 'Nobel'}, :spex_category => chalmers_spex_category

Spex.create :year => '1997', :spex_detail_attributes => {:title => 'Ali Baba'}, :spex_category => chalmers_spex_category

Spex.create :year => '1998', :spex_detail_attributes => {:title => 'Sköna Hélena'}, :spex_category => chalmers_spex_category

Spex.create :year => '1999', :spex_detail_attributes => {:title => 'Nostradamus'}, :spex_category => chalmers_spex_category

Spex.create :year => '2000', :spex_detail_attributes => {:title => 'Mose'}, :spex_category => chalmers_spex_category

Spex.create :year => '2001', :spex_detail_attributes => {:title => 'Marco Polo'}, :spex_category => chalmers_spex_category

Spex.create :year => '2002', :spex_detail_attributes => {:title => 'Dracula'}, :spex_category => chalmers_spex_category

Spex.create :year => '2003', :spex_detail_attributes => {:title => 'Gagarin'}, :spex_category => bob_spex_category

Spex.create :year => '2003', :spex_detail_attributes => {:title => 'Mata Hari'}, :spex_category => vera_spex_category

Spex.create :year => '2004', :spex_detail_attributes => {:title => 'Heliga Birgitta'}, :spex_category => bob_spex_category

Spex.create :year => '2004', :spex_detail_attributes => {:title => 'Phileas Fogg'}, :spex_category => vera_spex_category

Spex.create :year => '2005', :spex_detail_attributes => {:title => 'Gustav II Adolf'}, :spex_category => bob_spex_category

Spex.create :year => '2005', :spex_detail_attributes => {:title => 'Arthur'}, :spex_category => vera_spex_category

Spex.create :year => '2006', :spex_detail_attributes => {:title => 'Casanova'}, :spex_category => bob_spex_category

Spex.create :year => '2006', :spex_detail_attributes => {:title => 'Amelia Earhart'}, :spex_category => vera_spex_category

Spex.create :year => '2007', :spex_detail_attributes => {:title => 'Hannibal'}, :spex_category => bob_spex_category

Spex.create :year => '2007', :spex_detail_attributes => {:title => 'Frankenstein'}, :spex_category => vera_spex_category

Spex.create :year => '2008', :spex_detail_attributes => {:title => 'Picasso'}, :spex_category => bob_spex_category

Spex.create :year => '2008', :spex_detail_attributes => {:title => 'Wyatt Earp & Doc Holiday'}, :spex_category => vera_spex_category

Spex.create :year => '2008', :spex_detail_attributes => {:title => 'Tender Bar'}, :spex_category => jubileums_spex_category

Spex.create :year => '2009', :spex_detail_attributes => {:title => 'Newton'}, :spex_category => bob_spex_category

Spex.create :year => '2009', :spex_detail_attributes => {:title => 'Taj Mahal'}, :spex_category => vera_spex_category

Spex.create :year => '2010', :spex_detail_attributes => {:title => 'Kristian Tyrann'}, :spex_category => bob_spex_category

Spex.create :year => '2010', :spex_detail_attributes => {:title => 'Lucia'}, :spex_category => vera_spex_category

Spex.create :year => '2011', :spex_detail_attributes => {:title => 'Marie Curie'}, :spex_category => bob_spex_category

Spex.create :year => '2011', :spex_detail_attributes => {:title => 'Karl XII'}, :spex_category => vera_spex_category

Spex.create :year => '2012', :spex_detail_attributes => {:title => 'Christofer Columbus'}, :spex_category => bob_spex_category

Spex.create :year => '2012', :spex_detail_attributes => {:title => 'Bröderna Lumière'}, :spex_category => vera_spex_category
