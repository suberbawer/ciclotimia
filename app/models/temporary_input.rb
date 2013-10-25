class TemporaryInput

  def initialize()

  end

  def self.type
    @type ||= "Sale"
  end

  # Changes type of the input
  def change_type(new_type)
  	@type = new_type
  end

  def add_input
    @session[:temporary_input][:num_items]
  end
end