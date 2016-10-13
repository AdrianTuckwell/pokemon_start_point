require_relative("../db/sql_runner")

class Pokemon 

  attr_reader( :id, :name )

  def initialize( options )
    @id = options['id'].to_i
    @name = options['name']
  end

  def save()
    sql = "INSERT INTO pokemons (name) VALUES ('#{ @name }') RETURNING *"
    pokemon = SqlRunner.run( sql ).first
    @id = pokemon['id'].to_i
  end

  # --- Select all Trainers from Trainers table via Joined table OwnedPokemons trainer ID = trainer id where owned pokemon_id = id
  # ------------------------------------------------
  def trainers()
    sql = "SELECT t.* FROM trainers t INNER Join ownedpokemons o ON o.trainer_id = t.id WHERE o.Pokemon_id = #{id};"
    return Trainer.map_items(sql)
  end

  def self.all()
    sql = "SELECT * FROM pokemons"
    pokemons = Pokemon.map_items(sql)
    return pokemons
  end

  def self.delete_all() 
    sql = "DELETE FROM pokemons"
    SqlRunner.run(sql)
  end

  def self.map_items(sql)
    pokemons = SqlRunner.run(sql)
    result = pokemons.map { |pokemon| Pokemon.new( pokemon ) }
    return result
  end

  def self.map_item(sql)
    result = Pokemon.map_items(sql)
    return result.first
  end
end