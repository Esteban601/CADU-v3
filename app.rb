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
get '/:locale/estrategia' do
  @titulo = "Estrategia"
  @menuNum= 1
  @menuName= "Nosotros"
  erb :"#{I18n.locale}/vistas/menu1/estrategia", :layout => ("global/layouts/content").to_sym
end

get '/:locale/modelo-negocio' do
  @titulo = "Modelo de negocio"
  @menuNum= 1
  @menuName= "Nosotros"
  erb :"#{I18n.locale}/vistas/menu1/modelo-negocio", :layout => ("global/layouts/content").to_sym
end

get '/:locale/cadu-numeros' do
  @titulo = "Cadu en Números"
  @menuNum= 1
  @menuName= "Nosotros"
  erb :"#{I18n.locale}/vistas/menu1/cadu-numeros", :layout => ("global/layouts/content").to_sym
end

get '/:locale/panorama' do
  @titulo = "Panorama"
  @menuNum= 1
  @menuName= "Nosotros"
  erb :"#{I18n.locale}/vistas/menu1/panorama", :layout => ("global/layouts/content").to_sym
end

get '/:locale/perfil' do
  @titulo = "Perfil"
  @menuNum= 1
  @menuName= "Nosotros"
  erb :"#{I18n.locale}/vistas/menu1/perfil", :layout => ("global/layouts/content").to_sym
end

get '/:locale/directivos' do
  @titulo = "Directivos"
  @menuNum= 1
  @menuName= "Nosotros"
  erb :"#{I18n.locale}/vistas/menu1/directivos", :layout => ("global/layouts/content").to_sym
end

get '/:locale/historia' do
  @titulo = "Historia"
  @menuNum= 1
  @menuName= "Nosotros"
  erb :"#{I18n.locale}/vistas/menu1/historia", :layout => ("global/layouts/content").to_sym
end
                                                #Menu2
get '/:locale/codigos-estatutos' do
  @titulo = "Códigos y Estatutos"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/codigos-estatutos", :layout => ("global/layouts/content").to_sym
end

get '/:locale/comites' do
  @titulo = "Comités"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/comites", :layout => ("global/layouts/content").to_sym
end

get '/:locale/consejo-administracion' do
  @titulo = "Consejo de Administración"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/consejo-administracion", :layout => ("global/layouts/content").to_sym
end

get '/:locale/informacion-corporativa' do
  @titulo = "Información corporativa"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/informacion-corporativa", :layout => ("global/layouts/content").to_sym
end
                                                  #Menu3
get '/:locale/comunicados' do
  @titulo = "Comunicados"
  @menuNum= 3
  @menuName= "Información financiera"
  erb :"#{I18n.locale}/vistas/menu3/comunicados", :layout => ("global/layouts/content").to_sym
end

get '/:locale/fundamentales' do
  @titulo = "Fundamentales"
  @menuNum= 3
  @menuName= "Información financiera"
  erb :"#{I18n.locale}/vistas/menu3/fundamentales", :layout => ("global/layouts/content").to_sym
end

get '/:locale/registros-otc' do
  @titulo = "Registros OTC"
  @menuNum= 3
  @menuName= "Información financiera"
  erb :"#{I18n.locale}/vistas/menu3/registros-otc", :layout => ("global/layouts/content").to_sym
end

get '/:locale/registros-sec' do
  @titulo = "Registros SEC"
  @menuNum= 3
  @menuName= "Información financiera"
  erb :"#{I18n.locale}/vistas/menu3/registros-sec", :layout => ("global/layouts/content").to_sym
end

get '/:locale/reportes-anuales' do
  @titulo = "Reportes anuales"
  @menuNum= 3
  @menuName= "Información financiera"
  erb :"#{I18n.locale}/vistas/menu3/reportes-anuales", :layout => ("global/layouts/content").to_sym
end

get '/:locale/reportes-trimestrales' do
  @titulo = "Reportes trimestrales"
  @menuNum= 3
  @menuName= "Información financiera"
  erb :"#{I18n.locale}/vistas/menu3/reportes-trimestrales", :layout => ("global/layouts/content").to_sym
end

get '/:locale/teleconferencias' do
  @titulo = "Teleconferencias"
  @menuNum= 3
  @menuName= "Información financiera"
  erb :"#{I18n.locale}/vistas/menu3/teleconferencias", :layout => ("global/layouts/content").to_sym
end
                                                #Menu4
get '/:locale/analistas' do
  @titulo = "Analistas"
  @menuNum= 4
  @menuName= "Información Bursátil"
  erb :"#{I18n.locale}/vistas/menu4/analistas", :layout => ("global/layouts/content").to_sym
end

get '/:locale/bono' do
  @titulo = "Informacion del bono"
  @menuNum= 4
  @menuName= "Información Bursátil"
  erb :"#{I18n.locale}/vistas/menu4/bono", :layout => ("global/layouts/content").to_sym
end

get '/:locale/cotizacion' do
  @titulo = "Cotización de la acción"
  @menuNum= 4
  @menuName= "Información Bursátil"
  erb :"#{I18n.locale}/vistas/menu4/cotizacion", :layout => ("global/layouts/content").to_sym
end

get '/:locale/ibursatil' do
  @titulo = "Información buisátil"
  @menuNum= 4
  @menuName= "Información Bursátil"
  erb :"#{I18n.locale}/vistas/menu4/ibursatil", :layout => ("global/layouts/content").to_sym
end

