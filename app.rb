require 'sinatra'
require 'i18n'
require 'better_errors' if development?


configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

# Configuracion
configure do
  I18n.enforce_available_locales = false
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
end

before '/:locale/*' do
   I18n.locale = params[:locale]
end

before '/' do
  I18n.locale = :es
end

before '/:locale' do
  I18n.locale = params[:locale]
end

# Filtros para el idioma
before '/:locale/*' do
  I18n.locale = (params[:locale].eql?('es') || params[:locale].eql?('en')) ? params[:locale] : :es
end

configure do
  set :show_exceptions, false
#    set :show_exceptions, :after_handler
end


# Globales

get '/' do
  @IRmenu = 0
  erb (I18n.locale.to_s + '/vistas/index').to_sym
end

get '/en' do
  @IRmenu = 0
  erb (I18n.locale.to_s + '/vistas/index').to_sym
end

get '/es' do
  @IRmenu = 0
  erb (I18n.locale.to_s + '/vistas/index').to_sym
end

# error do
#   @titulo = " Error 404"
#   erb (I18n.locale.to_s + '/vistas/independientes/page-404').to_sym, :layout => ("global/layouts/content").to_sym
# end

# not_found do
#   # status 404
#   @titulo = " Error 404"
#   erb (I18n.locale.to_s + '/vistas/independientes/page-404').to_sym, :layout => ("global/layouts/content").to_sym
# end

get '/:locale/nosotros' do
  @titulo = "Cifras Relevantes"
  #erb :"#{I18n.locale}/vistas/cifras-relevantes", :layout => ("global/layouts/content").to_sym
end
