require 'sinatra'
require 'i18n'
require 'raven'
require 'better_errors' if development?

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
  set :show_exceptions, :after_handler
  set :force_ssl, false
end

# forcing https
configure :production do
  set :force_ssl, true
end

# Variables globales
before do

  if settings.force_ssl
    redirect request.url.sub('http', 'https') unless request.secure?
  end

  @investor_cloud_path = "http://cdn.investorcloud.net/cadu/"
  @gobierno_corporatico_path = "http://cdn.investorcloud.net/cadu/GobiernoCorporativo/"
  @comunicados_path = "http://cdn.investorcloud.net/cadu/Comunicados/"
  @reportes_anuales_path = "http://cdn.investorcloud.net/cadu/InformacionFinanciera/ReportesAnuales/"
  @reportes_trimestrales_path = "http://cdn.investorcloud.net/cadu/InformacionFinanciera/ReportesTrimestrales/"
  @registros_bmv_path = ""
  @presentaciones_path = "http://cdn.investorcloud.net/cadu/Presentaciones/"
end

# Configuracion
configure do
  I18n.enforce_available_locales = false
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  set :port, 3008
  set :bind, '0.0.0.0'
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

post '/es/boletinsubscripcion' do
  require 'pony'
  require 'dotenv/load'

  if params[:g_recaptcha_response] != ""
    require 'firebase'
    require 'uri'
    require 'net/https'
    require 'json'

    require "net/http"
    require "uri"
    uri = URI.parse("https://www.google.com/recaptcha/api/siteverify")
    # Full control
    request = Net::HTTP::Post.new(uri.request_uri)
    request.form_data = {
      "secret" => "6LcBrscUAAAAAKiL2CCutwlzsVWcimLjf1f4T_a2",
      "response" => params[:g_recaptcha_response],
    }
    res = Net::HTTP.start(
      uri.host, uri.port,
      :use_ssl => uri.scheme == 'https',
      :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|

      https.request(request)
    end

    verify = JSON.parse(res.body)

    if verify["success"] == true && verify["score"] >= 0.5
      from = "cadu-lista@investorcloud.net"
      subject = "Nuevo subscriptor a lista CADU"
      Pony.mail(
        :from => from,
        :to => 'it@irstrat.com',
        :subject => subject,
        :headers => { 'Content-Type' => 'text/html' },
        :body => erb(:"global/bloques/mail"),
        :via => :smtp,
        :via_options => {
          :address => 'smtp.mailgun.org',
          :port => '587',
          :enable_starttls_auto => true,
          :user_name => ENV['EMAIL_HOST_USER'],
          :password => ENV['EMAIL_HOST_PASSWORD'],
          :authentication => :plain,
          :domain => "investorcloud.net"
        })

      name = ""
      email = params[:email]
      email.each_char do |letra|
        if letra != "@" && letra != "."
          name += letra
        end
      end

      firebase_uri = 'https://iredge.firebaseio.com'
      @firebase = Firebase::Client.new(firebase_uri)
      response = @firebase.set("listas_distribucion/cadu/suscripcion/#{name}", { :email => email })
      if response.success? && response.code == 200
        redirect '/'
      else
        puts "I am sorry an error occurred saving to the database"
      end

      redirect "/"
    else
      redirect "/"
    end
  end
end

#Configuracion de email
# post '/es/boletinsubscripcion' do
#   require 'pony'
#   require 'firebase'
#   if verify_recaptcha
#     print('************ OK **************')
#     from = "boletin@cadu.com"
#     subject = "Nuevo subscriptor a lista CADU"
#     Pony.mail(
#         :from => from,
#         :to => 'lovera@irstrat.com',
#         :subject => subject,
#         :headers => {'Content-Type' => 'text/html'},
#         :body => erb(:"global/bloques/mail"),
#         :via => :smtp,
#         :via_options => {
#             :address => 'smtp.mailgun.org',
#             :port => '587',
#             :enable_starttls_auto => true,
#             :user_name => "reoki@sandbox37424.mailgun.org",
#             :password => "Katmandu321$",
#             :authentication => :plain,
#             :domain => "sandbox37424.mailgun.org"
#         })
#
#     name = ""
#     email = params[:email]
#     email.each_char do |letra|
#       if letra != "@" && letra != "."
#         name += letra
#       end
#     end
#
#     firebase_uri = 'https://iredge.firebaseio.com'
#     @firebase = Firebase::Client.new(firebase_uri)
#     response = @firebase.set("listas_distribucion/cadu/suscripcion/#{name}", {:email => email})
#     if response.success? && response.code == 200
#       redirect '/'
#     else
#       puts "I am sorry an error occurred saving to the database"
#     end
#   end
#   redirect '/'
# end

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
  @titulo = I18n.t 'Estrategia'
  @menuNum = 1
  @menuName = I18n.t 'Nosotros'
  erb :"#{I18n.locale}/vistas/menu1/estrategia", :layout => ("global/layouts/content").to_sym
end

get '/:locale/modelo-negocio' do
  @titulo = I18n.t 'modelo_n'
  @menuNum = 1
  @menuName = I18n.t 'Nosotros'
  erb :"#{I18n.locale}/vistas/menu1/modelo-negocio", :layout => ("global/layouts/content").to_sym
end

get '/:locale/cadu-numeros' do
  @titulo = "Cadu en números"
  @menuNum = 1
  @menuName = I18n.t 'Nosotros'
  erb :"#{I18n.locale}/vistas/menu1/cadu-numeros", :layout => ("global/layouts/content").to_sym
end

get '/:locale/panorama' do
  @titulo = I18n.t 'Panorama'
  @menuNum = 1
  @menuName = I18n.t 'Nosotros'
  erb :"#{I18n.locale}/vistas/menu1/panorama", :layout => ("global/layouts/content").to_sym
end

get '/:locale/perfil' do
  @titulo = I18n.t 'Perfil'
  @menuNum = 1
  @menuName = I18n.t 'Nosotros'
  erb :"#{I18n.locale}/vistas/menu1/perfil", :layout => ("global/layouts/content").to_sym
end

get '/:locale/directivos' do
  @titulo = I18n.t 'Directivos'
  @menuNum = 1
  @menuName = I18n.t 'Nosotros'
  erb :"#{I18n.locale}/vistas/menu1/directivos", :layout => ("global/layouts/content").to_sym
end

get '/:locale/historia' do
  @titulo = I18n.t 'Historia'
  @menuNum = 1
  @historia = true
  @menuName = I18n.t 'Nosotros'
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
  @titulo = I18n.t 'responsabilidad_s'
  @menuNum = 2
  @menuName = I18n.t 'sustentabilidad'
  erb :"#{I18n.locale}/vistas/menu2/responsabilidad-social", :layout => ("global/layouts/content").to_sym
end

get '/:locale/colaboradores' do
  @titulo = I18n.t 'colaboradores'
  @menuNum = 2
  @menuName = I18n.t 'sustentabilidad'
  erb :"#{I18n.locale}/vistas/menu2/responsabilidad_social/colaboradores", :layout => ("global/layouts/content").to_sym
end
get '/:locale/comunidades' do
  @titulo = I18n.t 'comunidades'
  @menuNum = 2
  @menuName = I18n.t 'sustentabilidad'
  erb :"#{I18n.locale}/vistas/menu2/responsabilidad_social/comunidades", :layout => ("global/layouts/content").to_sym
end
get '/:locale/valor_social' do
  @titulo = I18n.t 'valor_social_compartido'
  @menuNum = 2
  @menuName = I18n.t 'sustentabilidad'
  erb :"#{I18n.locale}/vistas/menu2/responsabilidad_social/valor_social", :layout => ("global/layouts/content").to_sym
end

get '/:locale/medio-ambiente' do
  @titulo = I18n.t 'medio_a'
  @menuNum = 2
  @menuName = I18n.t 'sustentabilidad'
  erb :"#{I18n.locale}/vistas/menu2/medio-ambiente", :layout => ("global/layouts/content").to_sym
end
get '/:locale/biodiversidad' do
  @titulo = I18n.t 'biodiversidad'
  @menuNum = 2
  @menuName = I18n.t 'medio_a'
  erb :"#{I18n.locale}/vistas/menu2/medio_ambiente/biodiversidad", :layout => ("global/layouts/content").to_sym
end
get '/:locale/construccion_verde' do
  @titulo = I18n.t 'construccion_verde'
  @menuNum = 2
  @menuName = I18n.t 'medio_a'
  erb :"#{I18n.locale}/vistas/menu2/medio_ambiente/construccion_verde", :layout => ("global/layouts/content").to_sym
end
get '/:locale/emisiones' do
  @titulo = I18n.t 'emisiones'
  @menuNum = 2
  @menuName = I18n.t 'medio_a'
  erb :"#{I18n.locale}/vistas/menu2/medio_ambiente/emisiones", :layout => ("global/layouts/content").to_sym
end
get '/:locale/politica_medio_ambiente' do
  @titulo = I18n.t 'politica_medio_ambiente'
  @menuNum = 2
  @menuName = I18n.t 'medio_a'
  erb :"#{I18n.locale}/vistas/menu2/medio_ambiente/politica_medio", :layout => ("global/layouts/content").to_sym
end
get '/:locale/residuos' do
  @titulo = I18n.t 'residuos'
  @menuNum = 2
  @menuName = I18n.t 'medio_a'
  erb :"#{I18n.locale}/vistas/menu2/medio_ambiente/residuos", :layout => ("global/layouts/content").to_sym
end
get '/:locale/codigo_etica' do
  @titulo = I18n.t 'codigo_etica'
  @menuNum = 2
  @menuName = I18n.t 'etica'
  erb :"#{I18n.locale}/vistas/menu2/etica/codigo_etica", :layout => ("global/layouts/content").to_sym
end
get '/:locale/comite_etica' do
  @titulo = I18n.t 'comite_etica'
  @menuNum = 2
  @menuName = I18n.t 'etica'
  erb :"#{I18n.locale}/vistas/menu2/etica/comite_etica", :layout => ("global/layouts/content").to_sym
end
get '/:locale/sistema_denuncias' do
  @titulo = I18n.t 'sistema_denuncias'
  @menuNum = 2
  @menuName = I18n.t 'etica'
  erb :"#{I18n.locale}/vistas/menu2/etica/sistema_denuncias", :layout => ("global/layouts/content").to_sym
end
get '/:locale/politica_anticorrupcion' do
  @titulo = I18n.t 'politica_anticorrupcion'
  @menuNum = 2
  @menuName = I18n.t 'etica'
  erb :"#{I18n.locale}/vistas/menu2/etica/politica_anticorrupcion", :layout => ("global/layouts/content").to_sym
end
get '/:locale/estrategia_sustentabilidad' do
  @titulo = I18n.t 'estrategia_sustentabilidad'
  @menuNum = 2
  @menuName = I18n.t 'estrategia_modelo'
  erb :"#{I18n.locale}/vistas/menu2/estrategia_modelo/estrategia_sustentabilidad", :layout => ("global/layouts/content").to_sym
end
get '/:locale/comite_sustentabilidad' do
  @titulo = I18n.t 'comite_sustentabilidad'
  @menuNum = 2
  @menuName = I18n.t 'estrategia_modelo'
  erb :"#{I18n.locale}/vistas/menu2/estrategia_modelo/comite", :layout => ("global/layouts/content").to_sym
end
get '/:locale/estudio_materialidad' do
  @titulo = I18n.t 'estudio_materialidad'
  @menuNum = 2
  @menuName = I18n.t 'estrategia_modelo'
  erb :"#{I18n.locale}/vistas/menu2/estrategia_modelo/estudio_materialidad", :layout => ("global/layouts/content").to_sym
end

get '/:locale/objetivos_desarrollo_sostenible' do
  @titulo = I18n.t 'objetivos_desarrollo_sostenible'
  @menuNum = 2
  @menuName = I18n.t 'sustentabilidad'
  erb :"#{I18n.locale}/vistas/menu2/objetivos_desarrollo", :layout => ("global/layouts/content").to_sym
end

get '/:locale/reporte_2017' do
  @titulo = I18n.t 'reporte_2017'
  @menuNum = 2
  @menuName = I18n.t 'sustentabilidad'
  erb :"#{I18n.locale}/vistas/menu2/reporte_2017", :layout => ("global/layouts/content").to_sym
end
get '/:locale/reporte_2018' do
  @titulo = I18n.t 'reporte_2018'
  @menuNum = 2
  @menuName = I18n.t 'sustentabilidad'
  erb :"#{I18n.locale}/vistas/menu2/reporte_2018", :layout => ("global/layouts/content").to_sym
end
get '/:locale/informes-sustentables' do
  @titulo = I18n.t 'informe_s'
  @menuNum = 2
  @menuName = I18n.t 'sustentabilidad'
  erb :"#{I18n.locale}/vistas/menu2/informes-sustentables", :layout => ("global/layouts/content").to_sym
end

get '/:locale/informacion-corporativa' do
  @titulo = "Información corporativa"
  @menuNum = 2
  @menuName = I18n.t 'Gobierno_corporativo'
  erb :"#{I18n.locale}/vistas/menu2/informacion-corporativa", :layout => ("global/layouts/content").to_sym
end

get '/:locale/auditor-externo' do
  @titulo = I18n.t 'Auditor_externo'
  @menuNum = 2
  @menuName = I18n.t 'Gobierno_corporativo'
  erb :"#{I18n.locale}/vistas/menu2/auditor-externo", :layout => ("global/layouts/content").to_sym
end

get '/:locale/estructura' do
  @titulo = I18n.t 'Estructura_accionaria'
  @menuNum = 2
  @menuName = I18n.t 'Gobierno_corporativo'
  erb :"#{I18n.locale}/vistas/menu2/estructura-accionaria", :layout => ("global/layouts/content").to_sym
end

get '/:locale/estructura-corporativa' do
  @titulo = I18n.t 'estructura_c'
  @menuNum = 2
  @menuName = I18n.t 'Gobierno_corporativo'
  erb :"#{I18n.locale}/vistas/menu2/estructura-corporativa", :layout => ("global/layouts/content").to_sym
end

get '/:locale/practicas' do
  @titulo = I18n.t 'practicas'
  @menuNum = 2
  @menuName = I18n.t 'Gobierno_corporativo'
  erb :"#{I18n.locale}/vistas/menu2/practicas", :layout => ("global/layouts/content").to_sym
end

get '/:locale/comites' do
  @titulo = I18n.t 'Comites'
  @menuNum = 2
  @menuName = I18n.t 'Gobierno_corporativo'
  erb :"#{I18n.locale}/vistas/menu2/comites", :layout => ("global/layouts/content").to_sym
end

get '/:locale/consejo-administracion' do
  @titulo = I18n.t 'Consejo_de_Administracion'
  @menuNum = 2
  @menuName = I18n.t 'Gobierno_corporativo'
  erb :"#{I18n.locale}/vistas/menu2/consejo-administracion", :layout => ("global/layouts/content").to_sym
end

get '/:locale/figuras_destacadas' do
  @titulo = I18n.t 'figuras_destacadas'
  @menuNum = 2
  @menuName = I18n.t 'Gobierno_corporativo'
  erb :"#{I18n.locale}/vistas/menu2/figuras_destacadas", :layout => ("global/layouts/content").to_sym
end
#Menu3
get '/:locale/comunicados' do
  @titulo = I18n.t 'comunicados'
  @menuNum = 3
  @menuName = I18n.t 'Informacion_financiera'
  erb :"#{I18n.locale}/vistas/menu3/comunicados", :layout => ("global/layouts/content").to_sym
end

get '/:locale/fundamentales' do
  @titulo = I18n.t 'Fundamentales'
  @menuNum = 3
  @menuName = I18n.t 'Informacion_financiera'
  erb :"#{I18n.locale}/vistas/menu3/fundamentales", :layout => ("global/layouts/content").to_sym
end

get '/:locale/faqs' do
  @titulo = I18n.t 'Preguntas_frecuentes'
  @menuNum = 3
  @menuName = I18n.t 'Informacion_financiera'
  erb :"#{I18n.locale}/vistas/menu3/faqs", :layout => ("global/layouts/content").to_sym
end

get '/:locale/glosario' do
  @titulo = I18n.t 'Glosario'
  @menuNum = 3
  @menuName = I18n.t 'Informacion_financiera'
  erb :"#{I18n.locale}/vistas/menu3/glosario", :layout => ("global/layouts/content").to_sym
end

get '/:locale/reportes-financieros' do
  @titulo = I18n.t 'reportes_f'
  @menuNum = 3
  @menuName = I18n.t 'Informacion_financiera'
  erb :"#{I18n.locale}/vistas/menu3/reportes-financieros", :layout => ("global/layouts/content").to_sym
end
get '/:locale/presentaciones' do
  @titulo = I18n.t 'presentaciones'
  @menuNum = 3
  @menuName = I18n.t 'Informacion_financiera'
  erb :"#{I18n.locale}/vistas/menu3/presentaciones", :layout => ("global/layouts/content").to_sym
end
#Menu4
get '/:locale/analistas' do
  @titulo = I18n.t 'Cobertura_de_analistas'
  @menuNum = 4
  @menuName = I18n.t 'Informacion_bursatil'
  erb :"#{I18n.locale}/vistas/menu4/analistas", :layout => ("global/layouts/content").to_sym
end

get '/:locale/calificaciones' do
  @titulo = I18n.t 'Calificaciones'
  @menuNum = 4
  @menuName = I18n.t 'Informacion_bursatil'
  erb :"#{I18n.locale}/vistas/menu4/calificaciones", :layout => ("global/layouts/content").to_sym
end

get '/:locale/acuerdos-asambleas' do
  @titulo = I18n.t 'acuerdos_a'
  @menuNum = 4
  @menuName = I18n.t 'Informacion_bursatil'
  erb :"#{I18n.locale}/vistas/menu4/acuerdos-asambleas", :layout => ("global/layouts/content").to_sym
end

get '/:locale/dividendos' do
  @titulo = I18n.t 'dividendos'
  @menuNum = 4
  @menuName = I18n.t 'Informacion_bursatil'
  erb :"#{I18n.locale}/vistas/menu4/dividendos", :layout => ("global/layouts/content").to_sym
end

get '/:locale/renta-fija-credito' do
  @titulo = I18n.t 'renta_f'
  @menuNum = 4
  @menuName = I18n.t 'Informacion_bursatil'
  erb :"#{I18n.locale}/vistas/menu4/renta-fija-credito", :layout => ("global/layouts/content").to_sym
end

get '/:locale/cotizacion' do
  @titulo = I18n.t 'Cotizacion_de_la_accion'
  @menuNum = 4
  @menuName = I18n.t 'Informacion_bursatil'
  erb :"#{I18n.locale}/vistas/menu4/cotizacion", :layout => ("global/layouts/content").to_sym
end

get '/:locale/prospectos' do
  @titulo = I18n.t 'Prospectos'
  @menuNum = 4
  @menuName = I18n.t 'Informacion_bursatil'
  erb :"#{I18n.locale}/vistas/menu4/prospectos", :layout => ("global/layouts/content").to_sym
end

get '/:locale/calculadora' do
  @titulo = "Calculadora de Rendimientos"
  @menuNum = 4
  @menuName = I18n.t 'Informacion_bursatil'
  erb :"#{I18n.locale}/vistas/menu4/calculadora", :layout => ("global/layouts/content").to_sym
end

#Global
get '/:locale/sala-prensa' do
  @titulo = I18n.t 'Sala'
  @menuNum = 0
  @menuName = I18n.t 'Sala'
  erb :"#{I18n.locale}/vistas/independientes/sala-prensa", :layout => ("global/layouts/content").to_sym
end
# HELPER

#Independientes
get '/:locale/resultados' do
  @titulo = "Resultados"
  @menuNum = 0
  erb :"#{I18n.locale}/vistas/independientes/resultados", :layout => ("global/layouts/content").to_sym
end

get '/:locale/video' do
  @titulo = "Video corporativo"
  @menuNum = 0
  erb :"#{I18n.locale}/vistas/independientes/video", :layout => ("global/layouts/content-full").to_sym
end

get '/testerror' do
  1 / 0
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
    if request.path_info == "/"
      return "/en"

    elsif I18n.locale == :es
      return request.path_info.sub('es', 'en')

    elsif I18n.locale == :en
      return request.path_info.sub('en', 'es')

    end
  end

end
