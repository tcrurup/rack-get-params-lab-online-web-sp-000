class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      if self.class.cart.length == 0
        resp.write "Your cart is empty"
      else
        self.class.cart.each{ |item| resp.write "#{item}\n" }
      end
    elsif req.path.match(/add/)
      item = req.params["item"]
      if self.class.items.include?(item)
        self.class.cart << item
        resp.write "added #{item}"
      else
        resp.write "We don't have that item"
      end
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
  
  def self.cart
    @@cart
  end
  
  def self.items
    @@items
  end
end
