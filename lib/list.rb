class List

  attr_reader(:name, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  # New and improved all method
  define_singleton_method(:all) do
    # Contains all list names from lists table from DB
    returned_lists = DB.exec("SELECT * FROM lists;")
    # Empty array to store list name(s)
    lists = []
    #loops through returned_lists
    returned_lists.each do |list|
      # Takes name from each list
        # Example: Yardwork, ID = 1
        # name = Yardwork
      name = list.fetch('name')
      #fetches id and converts to integer
      id = list.fetch("id").to_i()
      # Creates a list object and stores it in the lists array
      lists.push(List.new({:name => name, :id => id}))
    end
    # Returns lists
    lists
  end

  define_method(:save) do
    # Adds name to lists table, returns ID
    result = DB.exec("INSERT INTO lists (name) VALUES ('#{@name}') RETURNING id;")
    # Gets returned ID, converts it to integer
    @id = result.first().fetch("id").to_i()
  end
  #overrides the == operator
  define_method(:==) do |another_list|
    #compares names and ids of same class and returns true
    self.name().==(another_list.name()).&(self.id().==(another_list.id()))
  end

end
