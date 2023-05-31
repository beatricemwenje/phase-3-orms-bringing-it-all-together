class Dog
    attr_accessor :name, :breed, :id

end
    def initialize(name:, breed:, id: nil)
      @id = id
      @name = name
      @breed = breed
    end

    def self.drop_table
        sql = <<-SQL
          DROP TABLE IF EXISTS dogs
        SQL

        DB[:conn].execute(sql)
    end

    def self.create_table
        sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (
          id INTEGER PRIMARY KEY,
          name TEXT,
          breed TEXT
        )
      SQL

      DB[:conn].execute(sql)        
    end

    def save 

      sql = <<-SQL
          INSERT INTO dogs (name, breed)
          VALUES (?, ?)
      SQL

      # insert the new dog
      DB[:conn].execute(sql, self.name, self.breed)

      # get the dog ID from the db and save it to a Ruby instance
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]

      # return the Ruby instance
      self
    end

    def self.update(id, name, breed)
      sql = <<-SQL 
        UPDATE dogs SET name = ?, breed = ? WHERE id = ?
      SQL

      DB[:conn].execute(sql, name, breed, id)
    end 


    def self.create (name:, breed:)
      dog = Dog.new(name: name, breed: breed)
      dog.save
    end 

    def self.new_from_db(row)
      new_dog = self.new(id: row[0], name: row[1], breed: row[2])
      new_dog
    end  

    # define new method that returns an instance of a dog that matches the name from the DB
    def self.find_by_name(name)
      sql = <<-SQL 
        SELECT * FROM dogs WHERE name = ? LIMIT 1
      SQL

      DB[:conn].execute(sql, name).map do |row|
        self.new_from_db(row)
      end.first 
    end 

    def self.find(id)
      sql = <<-SQL 
        SELECT * FROM dogs WHERE id = ? LIMIT 1
      SQL

      DB[:conn].execute(sql, id).map do |row|
        self.new_from_db(row)
      end.first
    end

    def self.all
      sql = <<-SQL
        SELECT * FROM dogs
      SQL

      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end
    end 


end 




# Dog.create_table

end
