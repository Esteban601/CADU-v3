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

#Configuracion de email
post '/es/boletinsubscripcion' do
  require 'pony'

  from = "boletin@cadu.com"
  subject = "Nuevo mensaje de contacto a CADU"

  Pony.mail(
      :from => from,
      :to => 'lovera@irstrat.com',
      :subject => subject,
      :headers => { 'Content-Type' => 'text/html' },
      :body => erb(:"global/bloques/mail"),
      :via => :smtp,
      :via_options => {
          :address              => 'smtp.mailgun.org',
          :port                 => '587',
          :enable_starttls_auto => true,
          :user_name            => 'postmaster@irstrat.com',
          :password             => '5ptmod-dfz40',
          :authentication       => :plain,
          :domain               => "irstrat.com"
      })
  redirect '/'
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
# get '/:locale/codigos-estatutos' do
#   @titulo = "Códigos y Estatutos"
#   @menuNum= 2
#   @menuName= "Gobierno corporativo"
#   erb :"#{I18n.locale}/vistas/menu2/codigos-estatutos", :layout => ("global/layouts/content").to_sym
# end

get '/:locale/auditor-externo' do
  @titulo = "Auditor externo"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/auditor-externo", :layout => ("global/layouts/content").to_sym
end

get '/:locale/estructura-accionaria' do
  @titulo = "Estrucura Accionaria"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/estructura-accionaria", :layout => ("global/layouts/content").to_sym
end

get '/:locale/estructura-corporativa' do
  @titulo = "Estrucura Corporativa"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/estructura-corporativa", :layout => ("global/layouts/content").to_sym
end

get '/:locale/practicas' do
  @titulo = "Mejores prácticas corporativas"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/practicas", :layout => ("global/layouts/content").to_sym
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

# get '/:locale/informacion-corporativa' do
#   @titulo = "Información corporativa"
#   @menuNum= 2
#   @menuName= "Gobierno corporativo"
#   erb :"#{I18n.locale}/vistas/menu2/informacion-corporativa", :layout => ("global/layouts/content").to_sym
# end
#                                                   #Menu3
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

get '/:locale/faqs' do
  @titulo = "FAQs"
  @menuNum= 3
  @menuName= "Información financiera"
  erb :"#{I18n.locale}/vistas/menu3/faqs", :layout => ("global/layouts/content").to_sym
end

get '/:locale/registros-otc' do
  @titulo = "Registros OTC"
  @menuNum= 3
  @menuName= "Información financiera"
  erb :"#{I18n.locale}/vistas/menu3/registros-otc", :layout => ("global/layouts/content").to_sym
end

get '/:locale/glosario' do
  @titulo = "Glosario"
  @menuNum= 3
  @menuName= "Información financiera"
  erb :"#{I18n.locale}/vistas/menu3/glosario", :layout => ("global/layouts/content").to_sym
end

get '/:locale/registros-sec' do
  @titulo = "Registros SEC"
  @menuNum= 3
  @menuName= "Información financiera"
  erb :"#{I18n.locale}/vistas/menu3/registros-sec", :layout => ("global/layouts/content").to_sym
end

get '/:locale/reportes-financieros' do
  @titulo = "Reportes financieros"
  @menuNum= 3
  @menuName= "Información financiera"
  erb :"#{I18n.locale}/vistas/menu3/reportes-financieros", :layout => ("global/layouts/content").to_sym
end
                                                #Menu4
get '/:locale/analistas' do
  @titulo = "Analistas"
  @menuNum= 4
  @menuName= "Información Bursátil"
  erb :"#{I18n.locale}/vistas/menu4/analistas", :layout => ("global/layouts/content").to_sym
end

get '/:locale/acuerdos-asambleas' do
  @titulo = "Acuerdos y Asambleas"
  @menuNum= 4
  @menuName= "Información Bursátil"
  erb :"#{I18n.locale}/vistas/menu4/acuerdos-asambleas", :layout => ("global/layouts/content").to_sym
end

get '/:locale/dividendos' do
  @titulo = "Dividendos"
  @menuNum= 4
  @menuName= "Información Bursátil"
  erb :"#{I18n.locale}/vistas/menu4/dividendos", :layout => ("global/layouts/content").to_sym
end



get '/:locale/renta-fija-credito' do
  @titulo = "Renta Fija y Crédito"
  @menuNum= 4
  @menuName= "Información Bursátil"
  erb :"#{I18n.locale}/vistas/menu4/renta-fija-credito", :layout => ("global/layouts/content").to_sym
end

# get '/:locale/bono' do
#   @titulo = "Informacion del bono"
#   @menuNum= 4
#   @menuName= "Información Bursátil"
#   erb :"#{I18n.locale}/vistas/menu4/bono", :layout => ("global/layouts/content").to_sym
# end

get '/:locale/cotizacion' do
  @titulo = "Cotización de la acción"
  @menuNum= 4
  @menuName= "Información Bursátil"
  erb :"#{I18n.locale}/vistas/menu4/cotizacion", :layout => ("global/layouts/content").to_sym
end

# get '/:locale/ibursatil' do
#   @titulo = "Información Bursátil"
#   @menuNum= 4
#   @menuName= "Información Bursátil"
#   erb :"#{I18n.locale}/vistas/menu4/ibursatil", :layout => ("global/layouts/content").to_sym
# end

# HELPER

#Independientes
get '/:locale/resultados' do
  @titulo = "Resultados"
  @menuNum= 0
  erb :"#{I18n.locale}/vistas/independientes/resultados", :layout => ("global/layouts/content").to_sym
end

helpers do
  # Cambiar idioma

  def change_language
    if request.path_info=="/"
      return "/en"

    elsif I18n.locale == :es
      return request.path_info.sub('es', 'en')

    elsif  I18n.locale == :en
      return request.path_info.sub('en', 'es')

    end
  end

end
