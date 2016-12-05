class Task

  # Update specs once attr_reader is added
  attr_reader(:description, :list_id)

  define_method(:initialize) do |attributes|
    @description = attributes.fetch(:description)
    @list_id = attributes.fetch(:list_id)
  end

  # Update double equals to compare objects more intuitively
    # rspec uses double equals for comparison
  define_method(:==) do |other_task|
    # Compares Task objects by description attribute
    self.description().==(other_task.description())
  end

  define_method(:description) do
    @description
  end

  define_singleton_method(:all) do
    # Get all of 'tasks' table from DB into array
    db_all_tasks = DB.exec("SELECT * FROM tasks")
    # Empty array for gathering each task description
    tasks = []
    # Iterate through the tasks database array to push
    db_all_tasks.each() do |task|
      # Takes description from each task, but not the ID
        # Example: description = Feed the Dog, ID = 1
        # description = Feed the Dog
      description = task.fetch('description')
      # Fetches id and converts to integer
      list_id = task.fetch("list_id").to_i()
      # Creates a task object with DB information, stores it in the tasks array
      tasks.push(Task.new({:description => description, :list_id => list_id}))
    end
    # Returns tasks array
    tasks
  end

  # Old all method
  # define_singleton_method(:all) do
  #   @@all_tasks
  # end

  # New and improved save method
  define_method(:save) do
    # Uses PG Gem to execute the argument
      # Adds an input, description, to the description column in the tasks table
    DB.exec("INSERT INTO tasks (description, list_id) VALUES ('#{@description}', '#{@list_id}');")
  end

  # Old save method
  # define_method(:save) do
  #   @@all_tasks.push(self)
  # end
end
