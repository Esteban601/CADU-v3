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
                                                #Menu1
get '/:locale/perfil' do
  @titulo = "Perfil"
  @menuNum= "1"
  erb :"#{I18n.locale}/vistas/menu1/perfil", :layout => ("global/layouts/content").to_sym
end

get '/:locale/directivos' do
  @titulo = "Directivos"
  @menuNum= "1"
  erb :"#{I18n.locale}/vistas/menu1/directivos", :layout => ("global/layouts/content").to_sym
end

get '/:locale/historia' do
  @titulo = "Historia"
  @menuNum= "1"
  erb :"#{I18n.locale}/vistas/menu1/historia", :layout => ("global/layouts/content").to_sym
end
                                                #Menu2
get '/:locale/codigos-estatutos' do
  @titulo = "Códigos y Estatutos"
  @menuNum= "2"
  erb :"#{I18n.locale}/vistas/menu2/codigos-estatutos", :layout => ("global/layouts/content").to_sym
end

get '/:locale/comites' do
  @titulo = "Comités"
  @menuNum= "2"
  erb :"#{I18n.locale}/vistas/menu2/comites", :layout => ("global/layouts/content").to_sym
end

get '/:locale/consejo-administracion' do
  @titulo = "Consejo de Administración"
  @menuNum= "2"
  erb :"#{I18n.locale}/vistas/menu2/consejo-administracion", :layout => ("global/layouts/content").to_sym
end

get '/:locale/informacion-corporativa' do
  @titulo = "Información corporativa"
  @menuNum= "2"
  erb :"#{I18n.locale}/vistas/menu2/informacion-corporativa", :layout => ("global/layouts/content").to_sym
end

