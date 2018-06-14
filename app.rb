require 'sinatra'
require 'i18n'
require 'raven'
require 'better_errors' if development?


configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
  set :show_exceptions, :after_handler
end
# Variables globales
before do

@investor_cloud_path ="http://cdn.investorcloud.net/cadu/"
@gobierno_corporatico_path="http://cdn.investorcloud.net/cadu/GobiernoCorporativo/"
@comunicados_path = "http://cdn.investorcloud.net/cadu/Comunicados/"
@reportes_anuales_path = "http://cdn.investorcloud.net/cadu/InformacionFinanciera/ReportesAnuales/"
@reportes_trimestrales_path = "http://cdn.investorcloud.net/cadu/InformacionFinanciera/ReportesTrimestrales/"
@registros_bmv_path = ""
end

# Configuracion
configure do
  I18n.enforce_available_locales = false
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
end

# sentry error tracking
Raven.configure do |config|
  config.dsn = 'https://0e223e3c7c8149b3b0778eb64bb57a01:d1b75e6dc4994541809e383ad55577c8@app.getsentry.com/78146'
end
use Raven::Rack
# end sentry

before '/:locale/*' do
if params[:locale] == "en"
   I18n.locale = params[:locale]
 else
    I18n.locale = :es
  end
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



#Configuracion de email
post '/es/boletinsubscripcion' do
  require 'pony'
  require 'firebase'

  from = "boletin@cadu.com"
  subject = "Nuevo subscriptor a lista CADU"

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
          :user_name            => "postmaster@sandbox37424.mailgun.org",
          :password             => "7pl8f5goquf8",
          :authentication       => :plain,
          :domain               => "irstrat.com"
      })

  name = ""
  email = params[:email]
  email.each_char do |letra|
    if letra!="@" && letra!="."
      name+=letra
    end
  end

  firebase_uri = 'https://iredge.firebaseio.com'
  @firebase = Firebase::Client.new(firebase_uri)
  response =  @firebase.set("listas_distribucion/cadu/suscripcion/#{name}", {:email => email})
  if response.success? && response.code == 200
    redirect '/es'
  else
    puts "I am sorry an error occurred saving to the database"
  end
  redirect '/es'
end

# Globales

get '/' do
  @titulo = "Relación con inversionistas"
  @IRmenu = 0
  erb (I18n.locale.to_s + '/vistas/index').to_sym
end

get '/en' do
  @IRmenu = 0
  erb (I18n.locale.to_s + '/vistas/index').to_sym
end

get '/es' do
  @titulo = "Relación con inversionistas"
  @IRmenu = 0
  erb (I18n.locale.to_s + '/vistas/index').to_sym
end

# marcando excepciones
error do
  status 500
  @titulo = " Error 500"
  erb ('es/vistas/independientes/page-404').to_sym, :layout => ("global/layouts/content").to_sym
end
#paginas no existentes
not_found do
  status 404
  @titulo = " Error 404"
  erb ('es/vistas/independientes/page-404').to_sym, :layout => ("global/layouts/content").to_sym
end
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
  @titulo = "Cadu en números"
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
#

get '/:locale/responsabilidad-social' do
  @titulo = "Responsabilidad Social"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/responsabilidad-social", :layout => ("global/layouts/content").to_sym
end

get '/:locale/medio-ambiente' do
  @titulo = "Medio Ambiente"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/medio-ambiente", :layout => ("global/layouts/content").to_sym
end

get '/:locale/informes-sustentables' do
  @titulo = "Informes Sustentables"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/informes-sustentables", :layout => ("global/layouts/content").to_sym
end


get '/:locale/informacion-corporativa' do
  @titulo = "Información corporativa"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/informacion-corporativa", :layout => ("global/layouts/content").to_sym
end

get '/:locale/auditor-externo' do
  @titulo = "Auditor externo"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/auditor-externo", :layout => ("global/layouts/content").to_sym
end

get '/:locale/estructura' do
  @titulo = "Estructura accionaria"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/estructura-accionaria", :layout => ("global/layouts/content").to_sym
end

get '/:locale/estructura-corporativa' do
  @titulo = "Estructura corporativa"
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
  @titulo = "Consejo de administración"
  @menuNum= 2
  @menuName= "Gobierno corporativo"
  erb :"#{I18n.locale}/vistas/menu2/consejo-administracion", :layout => ("global/layouts/content").to_sym
end

                                                 #Menu3
get '/:locale/comunicados' do
  @titulo = "Comunicados y eventos relevantes"
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
  @titulo = "Preguntas frecuentes"
  @menuNum= 3
  @menuName= "Información financiera"
  erb :"#{I18n.locale}/vistas/menu3/faqs", :layout => ("global/layouts/content").to_sym
end

get '/:locale/glosario' do
  @titulo = "Glosario"
  @menuNum= 3
  @menuName= "Información financiera"
  erb :"#{I18n.locale}/vistas/menu3/glosario", :layout => ("global/layouts/content").to_sym
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

get '/:locale/cotizacion' do
  @titulo = "Cotización de la acción"
  @menuNum= 4
  @menuName= "Información Bursátil"
  erb :"#{I18n.locale}/vistas/menu4/cotizacion", :layout => ("global/layouts/content").to_sym
end

get '/:locale/prospectos' do
  @titulo = "Prospectos de colocación"
  @menuNum= 4
  @menuName= "Información Bursátil"
  erb :"#{I18n.locale}/vistas/menu4/prospectos", :layout => ("global/layouts/content").to_sym
end

#Global
get '/:locale/sala-prensa' do
  @titulo = "Sala de prensa"
  @menuNum= 0
  @menuName= "Sala de prensa"
  erb :"#{I18n.locale}/vistas/independientes/sala-prensa", :layout => ("global/layouts/content").to_sym
end
# HELPER

#Independientes
get '/:locale/resultados' do
  @titulo = "Resultados"
  @menuNum= 0
  erb :"#{I18n.locale}/vistas/independientes/resultados", :layout => ("global/layouts/content").to_sym
end

get '/:locale/video' do
  @titulo = "Video corporativo"
  @menuNum= 0
  erb :"#{I18n.locale}/vistas/independientes/video", :layout => ("global/layouts/content-full").to_sym
end

get '/testerror' do
1/0
end
#
# get '/:locale/terminos-condiciones' do
#   @titulo = "Términos y Condiciones"
#   @menuNum= 0
#   erb :"#{I18n.locale}/vistas/independientes/terminos-condiciones", :layout => ("global/layouts/content").to_sym
# end



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
