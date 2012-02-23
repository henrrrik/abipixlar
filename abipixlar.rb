require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'active_record'
require 'nokogiri'
require 'open-uri'
require 'uri'


configure do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/abipixlar')

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
  begin
    ActiveRecord::Schema.define do
      create_table :sizes do |t|
        t.integer :size
        t.string :headline
        t.timestamps
      end
    end
  rescue ActiveRecord::StatementInvalid
    # Do nothing, since the schema already exists
  end

end


class Size < ActiveRecord::Base
end


get '/' do
  @sizes = Size.find(:all, :order => "id desc", :limit => 50).reverse
  erb :index
end


__END__

@@ index

<html>
  <head>
    <meta charset="utf-8" />
    <title>abipixlar</title>
  </head>
  <body>
    <% if @sizes.blank? %>
      <p>Inga storlekar har hämtats ännu.</p>
    <% else %>
    <ul id="sizes">
    <% @sizes.each do |size| %>
      <li>Tidpunkt: <%= size.created_at %>, Storlek: <%= size.size %>px</li>
    <% end %>
    </ul>
    <% end %>
  </body>
</html>
