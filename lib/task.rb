class Task
  # @@all_tasks = []
  attr_reader(:description, :list_id)

  define_method(:initialize) do |attributes|
    @description = attributes.fetch(:description)
    @list_id = attributes.fetch(:list_id)
  end

  # Old way of doing it
  # define_singleton_method(:all) do
  #   @@all_tasks
  # end

  # New and improved all method
  define_singleton_method(:all) do
    # Contains all tasks from tasks table from DB
    returned_tasks = DB.exec("SELECT * FROM tasks;")
    # Empty array to store task(s)
    tasks = []
    # Loops through returned_tasks
    returned_tasks.each() do |task|
      # Takes description from each task, but not the ID
        # Example: Mow the Lawn, ID = 1
        # description = Mow the Lawn
      description = task.fetch('description')
    # The ID comes out of the database as a string.
      list_id = task.fetch("list_id").to_i()
      # Creates a task object and stores it in the tasks array
      tasks.push(Task.new({:description => description, :list_id => list_id}))
    end
    # Returns tasks
    tasks
  end

  # Old save method
  # define_method(:save) do
  #   @@all_tasks.push(self)
  # end

  # New and improved save method
  define_method(:save) do
    # Uses PG Gem to execute the argument
      # Adds an input, description, to the description column in the tasks table
    DB.exec("INSERT INTO tasks (description) VALUES ('#{@description}');")
  end

  # define_singleton_method(:clear) do
  #   @@all_tasks = []
  # end
  #
  # define_method(:delete) do
  #   task_index = @@all_tasks.index(self)
  #   @@all_tasks.delete_at(task_index)
  # end

  define_method(:==) do |another_task|
    self.description().==(another_task.description())
  end

end
