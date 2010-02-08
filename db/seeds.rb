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

# Functions
Function.create :name => 'Affisch', :function_category => FunctionCategory.find_by_name('Annat')
Function.create :name => 'Altsaxofon', :function_category => FunctionCategory.find_by_name('Bandet')
Function.create :name => 'Arkitekt', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Arrangör', :function_category => FunctionCategory.find_by_name('Annat')
Function.create :name => 'Bas', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Bas', :function_category => FunctionCategory.find_by_name('Bandet')
Function.create :name => 'Basklarinett', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Bastuba', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Blockflöjt', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Casseur', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Cello', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Cello 1', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Cello 2', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Dekoratör', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Designer', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Directeur', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Directeursassistent', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Elfiol', :function_category => FunctionCategory.find_by_name('Bandet')
Function.create :name => 'Ensemblist', :function_category => FunctionCategory.find_by_name('Ensemble')
Function.create :name => 'Exspextor', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Fagott', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Festdirecteur', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Festroddare', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Flöjt', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Fotografiker', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Författare', :function_category => FunctionCategory.find_by_name('Annat')
Function.create :name => 'Gitarr', :function_category => FunctionCategory.find_by_name('Bandet')
Function.create :name => 'Horn', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Info-chef', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Inspextor', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Inspextris', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Inspicient', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Inspicientassistent', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Kapellmästare', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Klarinett', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Klarinett', :function_category => FunctionCategory.find_by_name('Bandet')
Function.create :name => 'Kommittéledamot', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Kontrabas', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Koreograf', :function_category => FunctionCategory.find_by_name('Annat')
Function.create :name => 'Ljudmästare', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Ljusmästare', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Ljudroddare', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Ljusroddare', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Mediamästare', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Musikproducent', :function_category => FunctionCategory.find_by_name('Annat')
Function.create :name => 'Oboe', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Oboeflöjt', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Okänt', :function_category => FunctionCategory.find_by_name('Annat')
Function.create :name => 'Okänt', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Okänt', :function_category => FunctionCategory.find_by_name('Bandet')
Function.create :name => 'Organisateur', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Orkester', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'PR-chef', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'PR/Info-stab', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Panblåsare', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Pianör', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Pianör', :function_category => FunctionCategory.find_by_name('Bandet')
Function.create :name => 'Producent', :function_category => FunctionCategory.find_by_name('Annat')
Function.create :name => 'Regisseur', :function_category => FunctionCategory.find_by_name('Annat')
Function.create :name => 'Saxofon', :function_category => FunctionCategory.find_by_name('Bandet')
Function.create :name => 'Saxofon', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Scen', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Scenmästare', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Scenograf', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Scenroddare', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Sekreterare', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Skivkommitté', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Skräddare', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Slagverk', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Sopransaxofon', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Sufflör', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Sömmerska', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Tenorsaxofon', :function_category => FunctionCategory.find_by_name('Bandet')
Function.create :name => 'Trombon', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Trombon', :function_category => FunctionCategory.find_by_name('Bandet')
Function.create :name => 'Trummor', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Trummor', :function_category => FunctionCategory.find_by_name('Bandet')
Function.create :name => 'Trumpet', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Trumpet', :function_category => FunctionCategory.find_by_name('Bandet')
Function.create :name => 'Tvärflöjt', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Upplysare', :function_category => FunctionCategory.find_by_name('Kommitté')
Function.create :name => 'Valthorn', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Viola', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Violacello', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Violin', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Violin 1', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Violin 2', :function_category => FunctionCategory.find_by_name('Orkester')
Function.create :name => 'Vistextförfattare', :function_category => FunctionCategory.find_by_name('Annat')

bob_spex_category = SpexCategory.find_by_name('Bobspexet')
vera_spex_category = SpexCategory.find_by_name('Veraspexet')
chalmers_spex_category = SpexCategory.find_by_name('Chalmersspexet')

# Spex
Spex.create :year => '1948', :title => 'Bojan', :spex_category => chalmers_spex_category
Spex.create :year => '1949', :title => 'Erik XIV', :spex_category => chalmers_spex_category
Spex.create :year => '1950', :title => 'Caesarion', :spex_category => chalmers_spex_category
Spex.create :year => '1951', :title => 'Scheherazade', :spex_category => chalmers_spex_category
Spex.create :year => '1952', :title => 'Anna', :spex_category => chalmers_spex_category
Spex.create :year => '1953', :title => 'Ceasarion', :spex_category => chalmers_spex_category
Spex.create :year => '1954', :title => 'Henrik VIII', :spex_category => chalmers_spex_category
Spex.create :year => '1955', :title => 'Gustav E:son Vasa', :spex_category => chalmers_spex_category
Spex.create :year => '1956', :title => 'Napoleon', :spex_category => chalmers_spex_category
Spex.create :year => '1957', :title => 'Statyerna', :spex_category => chalmers_spex_category
Spex.create :year => '1958', :title => 'Lucrezia', :spex_category => chalmers_spex_category
Spex.create :year => '1959', :title => 'Katarina II', :spex_category => chalmers_spex_category
Spex.create :year => '1960', :title => 'Starke August', :spex_category => chalmers_spex_category
Spex.create :year => '1961', :title => 'Klodvig', :spex_category => chalmers_spex_category
Spex.create :year => '1962', :title => 'Don Pedro', :spex_category => chalmers_spex_category
Spex.create :year => '1963', :title => 'Charles II', :spex_category => chalmers_spex_category
Spex.create :year => '1964', :title => 'Nebukadnessar', :spex_category => chalmers_spex_category
Spex.create :year => '1965', :title => 'Sven Duva', :spex_category => chalmers_spex_category
Spex.create :year => '1966', :title => 'Montezuma', :spex_category => chalmers_spex_category
Spex.create :year => '1967', :title => 'Alexander', :spex_category => chalmers_spex_category
Spex.create :year => '1968', :title => 'Richard III', :spex_category => chalmers_spex_category
Spex.create :year => '1969', :title => 'Margareta', :spex_category => chalmers_spex_category
Spex.create :year => '1970', :title => 'George Washington', :spex_category => chalmers_spex_category
Spex.create :year => '1971', :title => 'Noak', :spex_category => chalmers_spex_category
Spex.create :year => '1972', :title => 'Turandot', :spex_category => chalmers_spex_category
Spex.create :year => '1973', :title => 'Fredrik den Store', :spex_category => chalmers_spex_category
Spex.create :year => '1974', :title => 'Sherlock Holmes', :spex_category => chalmers_spex_category
Spex.create :year => '1975', :title => 'Lionardo da Vinci', :spex_category => chalmers_spex_category
Spex.create :year => '1976', :title => 'Ludvig XIV', :spex_category => chalmers_spex_category
Spex.create :year => '1977', :title => 'Nils Dacke', :spex_category => chalmers_spex_category
Spex.create :year => '1978', :title => 'Dr Livingstone', :spex_category => chalmers_spex_category
Spex.create :year => '1979', :title => 'Nero', :spex_category => chalmers_spex_category
Spex.create :year => '1980', :title => 'Tutankhamon', :spex_category => chalmers_spex_category
Spex.create :year => '1981', :title => 'Ludwig van Beethoven', :spex_category => chalmers_spex_category
Spex.create :year => '1982', :title => 'John Ericsson', :spex_category => chalmers_spex_category
Spex.create :year => '1983', :title => 'Filip II', :spex_category => chalmers_spex_category
Spex.create :year => '1984', :title => 'Lasse-Maja', :spex_category => chalmers_spex_category
Spex.create :year => '1985', :title => 'Olof Skötkonung', :spex_category => chalmers_spex_category
Spex.create :year => '1986', :title => 'Victoria', :spex_category => chalmers_spex_category
Spex.create :year => '1987', :title => 'Montgomery', :spex_category => chalmers_spex_category
Spex.create :year => '1988', :title => 'Svartskägg', :spex_category => chalmers_spex_category
Spex.create :year => '1989', :title => 'Christina', :spex_category => chalmers_spex_category
Spex.create :year => '1990', :title => 'Klondike', :spex_category => chalmers_spex_category
Spex.create :year => '1991', :title => 'Gutenberg', :spex_category => chalmers_spex_category
Spex.create :year => '1992', :title => 'Krösus', :spex_category => chalmers_spex_category
Spex.create :year => '1993', :title => 'Stradivarius', :spex_category => chalmers_spex_category
Spex.create :year => '1994', :title => 'Ivan den förskräcklige', :spex_category => chalmers_spex_category
Spex.create :year => '1995', :title => 'Snorre', :spex_category => chalmers_spex_category
Spex.create :year => '1996', :title => 'Nobel', :spex_category => chalmers_spex_category
Spex.create :year => '1997', :title => 'Ali Baba', :spex_category => chalmers_spex_category
Spex.create :year => '1998', :title => 'Sköna Hélena', :spex_category => chalmers_spex_category
Spex.create :year => '1999', :title => 'Nostradamus', :spex_category => chalmers_spex_category
Spex.create :year => '2000', :title => 'Mose', :spex_category => chalmers_spex_category
Spex.create :year => '2001', :title => 'Marco Polo', :spex_category => chalmers_spex_category
Spex.create :year => '2002', :title => 'Dracula', :spex_category => chalmers_spex_category
Spex.create :year => '2003', :title => 'Gagarin', :spex_category => bob_spex_category
Spex.create :year => '2003', :title => 'Mata Hari', :spex_category => vera_spex_category
Spex.create :year => '2004', :title => 'Heliga Birgitta', :spex_category => bob_spex_category
Spex.create :year => '2004', :title => 'Phileas Fogg', :spex_category => vera_spex_category
Spex.create :year => '2005', :title => 'Gustav II Adolf', :spex_category => bob_spex_category
Spex.create :year => '2005', :title => 'Arthur', :spex_category => vera_spex_category
Spex.create :year => '2006', :title => 'Casanova', :spex_category => bob_spex_category
Spex.create :year => '2006', :title => 'Amelia Earhart', :spex_category => vera_spex_category
Spex.create :year => '2007', :title => 'Hannibal', :spex_category => bob_spex_category
Spex.create :year => '2007', :title => 'Frankenstein', :spex_category => vera_spex_category
Spex.create :year => '2008', :title => 'Picasso', :spex_category => bob_spex_category
Spex.create :year => '2008', :title => 'Wyatt Earp & Doc Holiday', :spex_category => vera_spex_category
Spex.create :year => '2009', :title => 'Newton', :spex_category => bob_spex_category
Spex.create :year => '2009', :title => 'Taj Mahal', :spex_category => vera_spex_category

# Revivals
Spex.create :year => '1968', :title => 'Henrik VIII', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1971', :title => 'Montezuma', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1972', :title => 'Alexander', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1973', :title => 'Richard III', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1974', :title => 'Nebukadnessar', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1975', :title => 'Margareta', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1976', :title => 'Charles II', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1977', :title => 'Katarina II', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1978', :title => 'Ceasarion', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1979', :title => 'Knappt ett Chalmersspex', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1980', :title => 'George Washington', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1981', :title => 'Don Pedro', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1982', :title => 'Lionardo da Vinci', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1983', :title => 'Anna', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1984', :title => 'Lasse-Maja', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1985', :title => 'Napoleon', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1986', :title => 'Noak', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1987', :title => 'Nero', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1988', :title => 'Gustav E:son Vasa', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1989', :title => 'Turandot', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1990', :title => 'Nils Dacke', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1991', :title => 'Sherlock Holmes', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1992', :title => 'Ludwig van Beethoven', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1993', :title => 'Sven Duva', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1994', :title => 'Lasse-Maja', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1995', :title => 'Dr Livingstone', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1996', :title => 'Victoria', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1997', :title => 'Tutankhamon', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1998', :title => 'Henrik VIII', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1998', :title => 'Klondike', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1998', :title => 'George Washington', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1998', :title => 'Ludwig van Beethoven', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '1999', :title => 'John Ericsson', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '2000', :title => 'Bojan', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '2001', :title => 'Ludvig XIV', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '2002', :title => 'Anna', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '2005', :title => 'Montgomery', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '2006', :title => 'Stradivarius', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '2007', :title => 'Filip II', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '2008', :title => 'Svartskägg', :is_revival => true, :spex_category => chalmers_spex_category
Spex.create :year => '2008', :title => 'Tender Bar', :is_revival => true, :spex_category => chalmers_spex_category
