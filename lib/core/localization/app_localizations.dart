import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum AppLanguage { english, spanish, french }

/// Manages active language state with Hive-backed persistence.
class LocalizationNotifier extends StateNotifier<AppLanguage> {
  LocalizationNotifier() : super(AppLanguage.english) {
    _loadLanguage();
  }

  static const _boxName = 'settings';
  static const _langKey = 'selectedLanguage';

  void _loadLanguage() {
    try {
      final box = Hive.box(_boxName);
      final savedLangIndex = box.get(_langKey, defaultValue: 0) as int;
      state = AppLanguage.values[savedLangIndex];
    } catch (_) {
      state = AppLanguage.english;
    }
  }

  Future<void> setLanguage(AppLanguage lang) async {
    state = lang;
    try {
      final box = Hive.box(_boxName);
      await box.put(_langKey, lang.index);
    } catch (_) {}
  }
}

/// Global localization provider.
final localizationProvider = StateNotifierProvider<LocalizationNotifier, AppLanguage>((ref) {
  return LocalizationNotifier();
});

/// A lightweight catalog mapping keys to English, Spanish, and French strings.
class AppLocalizations {
  final AppLanguage language;
  AppLocalizations(this.language);

  static final Map<AppLanguage, Map<String, String>> _localizedValues = {
    AppLanguage.english: {
      // ── Auth ───────────────────────────────────────────────
      'login': 'Log in',
      'signup': 'Sign Up',
      'welcome': 'Welcome back',
      'email': 'Email id',
      'password': 'Password',
      'forgot_password': 'Forgot password?',
      'dont_have_account': "Don't have an account? ",
      'already_have_account': 'Already have an account? ',
      'register_title': 'Create Account',
      'register_subtitle': 'Sign up to get started with CRM Dashboard App',
      'full_name': 'Full Name',
      'confirm_password': 'Confirm Password',
      'crm_app': 'CRM APP',
      'email_char_limit': 'Email exceeds 23 characters limit',
      'name_required': 'Name is required',
      'passwords_do_not_match': 'Passwords do not match',
      'email_address': 'Email Address',
      'password_reset': 'Password Reset',
      'trouble_logging_in': 'Trouble logging in?',
      'reset_email_desc': "Enter your email and we'll send you a link to get back into your account.",
      'send_reset_link': 'Send Reset Link',
      'back_to_login': 'Back to Login',
      'email_sent': 'Email Sent',
      'email_sent_desc': 'We sent an email to {email} with a link to get back into your account.',
      'return_to_login': 'Return to Login',
      'login_dot': 'Log in.',

      // ── Dashboard ──────────────────────────────────────────
      'dashboard': 'Dashboard',
      'overview': 'Overview',
      'good_morning': 'Good morning',
      'good_afternoon': 'Good afternoon',
      'good_evening': 'Good evening',
      'total_companies': 'Total Companies',
      'total_revenue': 'Total Revenue',
      'active_leads': 'Active Leads',
      'conversion_rate': 'Conversion Rate',
      'recent_activities': 'Recent Activities',
      'recent_activity': 'Recent Activity',
      'upcoming_meetings': 'Upcoming Meetings',
      'quick_actions': 'Quick Actions',
      'revenue_analytics': 'Revenue Analytics',
      'view_all': 'View All',
      'no_recent_activities': 'No recent activities',
      'no_upcoming_meetings': 'No upcoming meetings scheduled',
      'activity_synced': 'Activity logs are fully synchronized!',
      'error_loading_kpis': 'Error loading KPIs',

      // ── Quick Actions ──────────────────────────────────────
      'add_company': 'Add Company',
      'add_company_desc': 'Register new client',
      'schedule_meeting': 'Schedule Meeting',
      'schedule_meeting_desc': 'Book a video call',
      'schedule_meeting_snack': 'Simulating Schedule Meeting workflow...',
      'generate_report': 'Generate Report',
      'generate_report_desc': 'Export pipeline data',
      'report_generated': 'Report generated successfully!',
      'view_analytics': 'View Analytics',
      'view_analytics_desc': 'Open growth charts',
      'navigating_analytics': 'Navigating to full Revenue Analytics...',
      'active_pipeline_revenue': 'Active Pipeline Revenue',

      // ── Companies ──────────────────────────────────────────
      'companies': 'Companies',
      'search_company_hint': 'Search by company, name or email...',
      'no_companies_found': 'No companies found',
      'no_results_matching': 'No results found matching',
      'try_adjusting_search': 'Try adjusting your search query',

      // ── Company Details ────────────────────────────────────
      'contact_information': 'Contact Information',
      'email_label': 'Email',
      'phone': 'Phone',
      'website': 'Website',
      'address': 'Address',
      'street': 'Street',
      'city': 'City',
      'zipcode': 'Zipcode',
      'business_details': 'Business Details',
      'company': 'Company',
      'catch_phrase': 'Catch Phrase',
      'bs': 'BS',
      'notes': 'Notes',
      'loading': 'Loading...',
      'error': 'Error',
      'active_client': 'Active Client',
      'pending_review': 'Pending Review',
      'active': 'Active',
      'value': 'Value',
      'contact': 'Contact',
      'send_email': 'Send Email',

      // ── Settings ───────────────────────────────────────────
      'settings': 'Settings',
      'account': 'ACCOUNT',
      'appearance': 'APPEARANCE',
      'theme_mode': 'Theme Mode',
      'theme_light': 'Light',
      'theme_dark': 'Dark',
      'theme_system': 'System',
      'language': 'LANGUAGE',
      'about': 'ABOUT',
      'about_crm': 'About CRM Dashboard App',
      'version': 'Version',
      'terms': 'Terms of Service',
      'privacy': 'Privacy Policy',
      'actions': 'ACTIONS',
      'logout': 'Logout',
      'confirm_logout_title': 'Confirm Sign Out',
      'confirm_logout_desc': 'Are you sure you want to end your current active dashboard session?',
      'cancel': 'Cancel',

      // ── Profile ────────────────────────────────────────────
      'profile_details': 'Profile Details',
      'account_information': 'ACCOUNT INFORMATION',
      'user_id': 'User ID',
      'organization': 'Organization',
      'member_since': 'Member Since',
      'security': 'SECURITY',
      'active_session': 'Active Session Status',
      'secure_device': 'Device authenticated & Hive DB encrypted',
      'sign_out_btn': 'Sign Out of CRM Dashboard App',
      'sign_out': 'Sign Out',

      // ── About App ──────────────────────────────────────────
      'about_dashboard_title': 'About CRM Dashboard app',
      'crm_dashboard': 'CRM Dashboard',
      'core_capabilities': 'CORE CAPABILITIES',
      'tech_stack': 'THE TECH STACK',
      'about_dashboard_desc': 'A state-of-the-art relationship management dashboard providing deep insight into client structures, responsive analytical pipelines, and decoupled caching engines.',
      'cap_analytics': 'Unified Sales Analytics',
      'cap_analytics_desc': 'Interactive analytics showing total volume, pipeline values, and growth parameters in real-time.',
      'cap_companies': 'Dynamic Companies Registry',
      'cap_companies_desc': 'Lazy-loaded paginated company grids reading dynamic details with simulated networks.',
      'cap_loading': 'Simultaneous Loading Architecture',
      'cap_loading_desc': 'Integrated dual animation pipelines combining pull-to-refresh indicators with realistic shimmering.',
      'cap_layouts': 'Hybrid Responsive Layouts',
      'cap_layouts_desc': 'Smooth sidebar collapsing and floating action elements with deep black and light theme engines.',

      // ── Document Viewer ────────────────────────────────────
      'crm_terms': 'CRM Dashboard App Terms',
      'crm_privacy': 'CRM Dashboard App Privacy',
      'last_updated': 'Last updated: May 24, 2026',

      // ── Custom AppBar ──────────────────────────────────────
      'search_hint': 'Search...',
      'profile_settings': 'Profile Settings',
      'notifications': 'Notifications',
      'close': 'Close',
      'new_lead_title': 'New lead registered',
      'new_lead_desc': 'Clementine Bauch created Romaguera-Jacobson deal.',
      'time_10_min': '10 min ago',
      'meeting_title': 'Meeting Scheduled',
      'meeting_desc': 'Video call with John Smith at 2:00 PM today.',
      'time_1_hour': '1 hour ago',

      // ── Side Navigation ────────────────────────────────────
      'collapse_sidebar': 'Collapse Sidebar',
      'expand_sidebar': 'Expand Sidebar',
      'switch_to_light': 'Switch to Light',
      'switch_to_dark': 'Switch to Dark',

      // ── Global Search ──────────────────────────────────────
      'search_global_hint': 'Search companies, emails, catchphrases...',
      'type_to_search': 'Type to search...',
      'no_matches_found': 'No matches found',
      'results': 'results',

      // ── Error & Offline ────────────────────────────────────
      'something_went_wrong': 'Something went wrong',
      'try_again': 'Try Again',
      'simulated_offline': 'Simulated Offline Mode Active. API calls will fail.',
      'simulated_restored': 'Simulated connection restored!',
      'restore': 'Restore',

      // ── Status Badges ──────────────────────────────────────
      'status_active': 'Active',
      'status_inactive': 'Inactive',
      'status_pending': 'Pending',
      'status_priority': 'Priority',
      'status_info': 'Info',
    },

    AppLanguage.spanish: {
      // ── Auth ───────────────────────────────────────────────
      'login': 'Iniciar sesión',
      'signup': 'Registrarse',
      'welcome': 'Bienvenido de nuevo',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'forgot_password': '¿Olvidó su contraseña?',
      'dont_have_account': '¿No tiene una cuenta? ',
      'already_have_account': '¿Ya tiene una cuenta? ',
      'register_title': 'Crear Cuenta',
      'register_subtitle': 'Regístrese para comenzar con CRM Dashboard App',
      'full_name': 'Nombre Completo',
      'confirm_password': 'Confirmar Contraseña',
      'crm_app': 'CRM APP',
      'email_char_limit': 'El correo supera el límite de 23 caracteres',
      'name_required': 'El nombre es obligatorio',
      'passwords_do_not_match': 'Las contraseñas no coinciden',
      'email_address': 'Correo Electrónico',
      'password_reset': 'Restablecer Contraseña',
      'trouble_logging_in': '¿Problemas para iniciar sesión?',
      'reset_email_desc': 'Ingrese su correo electrónico y le enviaremos un enlace para recuperar su cuenta.',
      'send_reset_link': 'Enviar Enlace de Restablecimiento',
      'back_to_login': 'Volver a Iniciar Sesión',
      'email_sent': 'Correo Enviado',
      'email_sent_desc': 'Enviamos un correo a {email} con un enlace para recuperar su cuenta.',
      'return_to_login': 'Volver al Inicio de Sesión',
      'login_dot': 'Iniciar sesión.',

      // ── Dashboard ──────────────────────────────────────────
      'dashboard': 'Panel',
      'overview': 'Resumen',
      'good_morning': 'Buenos días',
      'good_afternoon': 'Buenas tardes',
      'good_evening': 'Buenas noches',
      'total_companies': 'Empresas Totales',
      'total_revenue': 'Ingresos Totales',
      'active_leads': 'Prospectos Activos',
      'conversion_rate': 'Tasa de Conversión',
      'recent_activities': 'Actividades Recientes',
      'recent_activity': 'Actividad Reciente',
      'upcoming_meetings': 'Próximas Reuniones',
      'quick_actions': 'Acciones Rápidas',
      'revenue_analytics': 'Análisis de Ingresos',
      'view_all': 'Ver Todo',
      'no_recent_activities': 'Sin actividades recientes',
      'no_upcoming_meetings': 'Sin reuniones programadas',
      'activity_synced': '¡Los registros de actividad están sincronizados!',
      'error_loading_kpis': 'Error al cargar KPIs',

      // ── Quick Actions ──────────────────────────────────────
      'add_company': 'Agregar Empresa',
      'add_company_desc': 'Registrar nuevo cliente',
      'schedule_meeting': 'Programar Reunión',
      'schedule_meeting_desc': 'Reservar una videollamada',
      'schedule_meeting_snack': 'Simulando flujo de Programar Reunión...',
      'generate_report': 'Generar Informe',
      'generate_report_desc': 'Exportar datos del pipeline',
      'report_generated': '¡Informe generado exitosamente!',
      'view_analytics': 'Ver Analíticas',
      'view_analytics_desc': 'Abrir gráficos de crecimiento',
      'navigating_analytics': 'Navegando a Análisis de Ingresos completo...',
      'active_pipeline_revenue': 'Ingresos del Pipeline Activo',

      // ── Companies ──────────────────────────────────────────
      'companies': 'Empresas',
      'search_company_hint': 'Buscar por empresa, nombre o correo...',
      'no_companies_found': 'No se encontraron empresas',
      'no_results_matching': 'Sin resultados que coincidan con',
      'try_adjusting_search': 'Intente ajustar su búsqueda',

      // ── Company Details ────────────────────────────────────
      'contact_information': 'Información de Contacto',
      'email_label': 'Correo',
      'phone': 'Teléfono',
      'website': 'Sitio Web',
      'address': 'Dirección',
      'street': 'Calle',
      'city': 'Ciudad',
      'zipcode': 'Código Postal',
      'business_details': 'Detalles del Negocio',
      'company': 'Empresa',
      'catch_phrase': 'Eslogan',
      'bs': 'Estrategia',
      'notes': 'Notas',
      'loading': 'Cargando...',
      'error': 'Error',
      'active_client': 'Cliente Activo',
      'pending_review': 'Revisión Pendiente',
      'active': 'Activo',
      'value': 'Valor',
      'contact': 'Contacto',
      'send_email': 'Enviar Correo',

      // ── Settings ───────────────────────────────────────────
      'settings': 'Configuración',
      'account': 'CUENTA',
      'appearance': 'APARIENCIA',
      'theme_mode': 'Modo de Tema',
      'theme_light': 'Claro',
      'theme_dark': 'Oscuro',
      'theme_system': 'Sistema',
      'language': 'IDIOMA',
      'about': 'ACERCA DE',
      'about_crm': 'Acerca de CRM Dashboard App',
      'version': 'Versión',
      'terms': 'Términos de Servicio',
      'privacy': 'Política de Privacidad',
      'actions': 'ACCIONES',
      'logout': 'Cerrar Sesión',
      'confirm_logout_title': 'Confirmar Salida',
      'confirm_logout_desc': '¿Está seguro de que desea finalizar su sesión activa en el panel?',
      'cancel': 'Cancelar',

      // ── Profile ────────────────────────────────────────────
      'profile_details': 'Detalles de Perfil',
      'account_information': 'INFORMACIÓN DE CUENTA',
      'user_id': 'ID de Usuario',
      'organization': 'Organización',
      'member_since': 'Miembro desde',
      'security': 'SEGURIDAD',
      'active_session': 'Estado de Sesión Activa',
      'secure_device': 'Dispositivo autenticado y Hive DB encriptado',
      'sign_out_btn': 'Cerrar Sesión en CRM Dashboard App',
      'sign_out': 'Cerrar Sesión',

      // ── About App ──────────────────────────────────────────
      'about_dashboard_title': 'Acerca del Panel CRM',
      'crm_dashboard': 'Panel CRM',
      'core_capabilities': 'CAPACIDADES PRINCIPALES',
      'tech_stack': 'TECNOLOGÍAS UTILIZADAS',
      'about_dashboard_desc': 'Un panel de gestión de relaciones de última generación que proporciona información profunda sobre estructuras de clientes, canales analíticos adaptables y motores de caché desacoplados.',
      'cap_analytics': 'Análisis de Ventas Unificado',
      'cap_analytics_desc': 'Analíticas interactivas que muestran volumen total, valores de pipeline y parámetros de crecimiento en tiempo real.',
      'cap_companies': 'Registro Dinámico de Empresas',
      'cap_companies_desc': 'Cuadrículas de empresas paginadas con carga diferida y detalles dinámicos con redes simuladas.',
      'cap_loading': 'Arquitectura de Carga Simultánea',
      'cap_loading_desc': 'Canalizaciones de animación dual integradas que combinan indicadores de actualización con efectos de brillo realistas.',
      'cap_layouts': 'Diseños Responsivos Híbridos',
      'cap_layouts_desc': 'Barra lateral plegable y elementos de acción flotantes con motores de tema claro y oscuro profundo.',

      // ── Document Viewer ────────────────────────────────────
      'crm_terms': 'Términos de CRM Dashboard App',
      'crm_privacy': 'Privacidad de CRM Dashboard App',
      'last_updated': 'Última actualización: 24 de mayo de 2026',

      // ── Custom AppBar ──────────────────────────────────────
      'search_hint': 'Buscar...',
      'profile_settings': 'Configuración de Perfil',
      'notifications': 'Notificaciones',
      'close': 'Cerrar',
      'new_lead_title': 'Nuevo prospecto registrado',
      'new_lead_desc': 'Clementine Bauch creó el trato Romaguera-Jacobson.',
      'time_10_min': 'hace 10 min',
      'meeting_title': 'Reunión Programada',
      'meeting_desc': 'Videollamada con John Smith a las 2:00 PM hoy.',
      'time_1_hour': 'hace 1 hora',

      // ── Side Navigation ────────────────────────────────────
      'collapse_sidebar': 'Contraer Barra Lateral',
      'expand_sidebar': 'Expandir Barra Lateral',
      'switch_to_light': 'Cambiar a Claro',
      'switch_to_dark': 'Cambiar a Oscuro',

      // ── Global Search ──────────────────────────────────────
      'search_global_hint': 'Buscar empresas, correos, eslóganes...',
      'type_to_search': 'Escriba para buscar...',
      'no_matches_found': 'Sin coincidencias',
      'results': 'resultados',

      // ── Error & Offline ────────────────────────────────────
      'something_went_wrong': 'Algo salió mal',
      'try_again': 'Intentar de Nuevo',
      'simulated_offline': 'Modo sin conexión simulado activo. Las llamadas API fallarán.',
      'simulated_restored': '¡Conexión simulada restaurada!',
      'restore': 'Restaurar',

      // ── Status Badges ──────────────────────────────────────
      'status_active': 'Activo',
      'status_inactive': 'Inactivo',
      'status_pending': 'Pendiente',
      'status_priority': 'Prioritario',
      'status_info': 'Info',
    },

    AppLanguage.french: {
      // ── Auth ───────────────────────────────────────────────
      'login': 'Se connecter',
      'signup': "S'inscrire",
      'welcome': 'Bon retour',
      'email': 'E-mail',
      'password': 'Mot de passe',
      'forgot_password': 'Mot de passe oublié?',
      'dont_have_account': "N'avez-vous pas de compte? ",
      'already_have_account': 'Avez-vous déjà un compte? ',
      'register_title': 'Créer un Compte',
      'register_subtitle': 'Inscrivez-vous pour démarrer avec CRM Dashboard App',
      'full_name': 'Nom Complet',
      'confirm_password': 'Confirmer le Mot de passe',
      'crm_app': 'CRM APP',
      'email_char_limit': "L'e-mail dépasse la limite de 23 caractères",
      'name_required': 'Le nom est obligatoire',
      'passwords_do_not_match': 'Les mots de passe ne correspondent pas',
      'email_address': 'Adresse E-mail',
      'password_reset': 'Réinitialisation du Mot de passe',
      'trouble_logging_in': 'Problème de connexion?',
      'reset_email_desc': 'Entrez votre e-mail et nous vous enverrons un lien pour récupérer votre compte.',
      'send_reset_link': 'Envoyer le Lien',
      'back_to_login': 'Retour à la Connexion',
      'email_sent': 'E-mail Envoyé',
      'email_sent_desc': 'Nous avons envoyé un e-mail à {email} avec un lien pour récupérer votre compte.',
      'return_to_login': 'Retour à la Connexion',
      'login_dot': 'Se connecter.',

      // ── Dashboard ──────────────────────────────────────────
      'dashboard': 'Tableau de Bord',
      'overview': 'Aperçu',
      'good_morning': 'Bonjour',
      'good_afternoon': 'Bon après-midi',
      'good_evening': 'Bonsoir',
      'total_companies': 'Total des Entreprises',
      'total_revenue': 'Revenu Total',
      'active_leads': 'Prospects Actifs',
      'conversion_rate': 'Taux de Conversion',
      'recent_activities': 'Activités Récentes',
      'recent_activity': 'Activité Récente',
      'upcoming_meetings': 'Réunions à Venir',
      'quick_actions': 'Actions Rapides',
      'revenue_analytics': 'Analyse des Revenus',
      'view_all': 'Voir Tout',
      'no_recent_activities': 'Aucune activité récente',
      'no_upcoming_meetings': 'Aucune réunion programmée',
      'activity_synced': "Les journaux d'activité sont synchronisés!",
      'error_loading_kpis': 'Erreur de chargement des KPIs',

      // ── Quick Actions ──────────────────────────────────────
      'add_company': 'Ajouter une Entreprise',
      'add_company_desc': 'Enregistrer un nouveau client',
      'schedule_meeting': 'Planifier une Réunion',
      'schedule_meeting_desc': 'Réserver un appel vidéo',
      'schedule_meeting_snack': 'Simulation du flux de Planification de Réunion...',
      'generate_report': 'Générer un Rapport',
      'generate_report_desc': 'Exporter les données du pipeline',
      'report_generated': 'Rapport généré avec succès!',
      'view_analytics': 'Voir les Analytiques',
      'view_analytics_desc': 'Ouvrir les graphiques de croissance',
      'navigating_analytics': "Navigation vers l'Analyse des Revenus complète...",
      'active_pipeline_revenue': 'Revenus du Pipeline Actif',

      // ── Companies ──────────────────────────────────────────
      'companies': 'Entreprises',
      'search_company_hint': 'Rechercher par entreprise, nom ou e-mail...',
      'no_companies_found': 'Aucune entreprise trouvée',
      'no_results_matching': 'Aucun résultat correspondant à',
      'try_adjusting_search': 'Essayez de modifier votre recherche',

      // ── Company Details ────────────────────────────────────
      'contact_information': 'Informations de Contact',
      'email_label': 'E-mail',
      'phone': 'Téléphone',
      'website': 'Site Web',
      'address': 'Adresse',
      'street': 'Rue',
      'city': 'Ville',
      'zipcode': 'Code Postal',
      'business_details': "Détails de l'Entreprise",
      'company': 'Entreprise',
      'catch_phrase': 'Slogan',
      'bs': 'Stratégie',
      'notes': 'Notes',
      'loading': 'Chargement...',
      'error': 'Erreur',
      'active_client': 'Client Actif',
      'pending_review': 'En Attente de Révision',
      'active': 'Actif',
      'value': 'Valeur',
      'contact': 'Contact',
      'send_email': 'Envoyer Email',

      // ── Settings ───────────────────────────────────────────
      'settings': 'Paramètres',
      'account': 'COMPTE',
      'appearance': 'APPARENCE',
      'theme_mode': 'Mode Thème',
      'theme_light': 'Clair',
      'theme_dark': 'Sombre',
      'theme_system': 'Système',
      'language': 'LANGUE',
      'about': 'À PROPOS',
      'about_crm': 'À Propos de CRM Dashboard App',
      'version': 'Version',
      'terms': "Conditions d'Utilisation",
      'privacy': 'Politique de Confidentialité',
      'actions': 'ACTIONS',
      'logout': 'Se Déconnecter',
      'confirm_logout_title': 'Confirmer la Déconnexion',
      'confirm_logout_desc': 'Êtes-vous sûr de vouloir mettre fin à votre session active?',
      'cancel': 'Annuler',

      // ── Profile ────────────────────────────────────────────
      'profile_details': 'Détails du Profil',
      'account_information': 'INFORMATIONS DU COMPTE',
      'user_id': "ID de l'Utilisateur",
      'organization': 'Organisation',
      'member_since': 'Membre Depuis',
      'security': 'SÉCURITÉ',
      'active_session': 'Statut de Session Active',
      'secure_device': 'Appareil authentifié et Hive DB crypté',
      'sign_out_btn': 'Se déconnecter de CRM Dashboard App',
      'sign_out': 'Se Déconnecter',

      // ── About App ──────────────────────────────────────────
      'about_dashboard_title': "À Propos du Tableau de Bord CRM",
      'crm_dashboard': 'Tableau de Bord CRM',
      'core_capabilities': 'CAPACITÉS PRINCIPALES',
      'tech_stack': 'TECHNOLOGIES UTILISÉES',
      'about_dashboard_desc': "Un tableau de bord de gestion des relations de pointe offrant un aperçu approfondi des structures clients, des pipelines analytiques adaptatifs et des moteurs de cache découplés.",
      'cap_analytics': 'Analyse des Ventes Unifiée',
      'cap_analytics_desc': "Analytiques interactives montrant le volume total, les valeurs du pipeline et les paramètres de croissance en temps réel.",
      'cap_companies': 'Registre Dynamique des Entreprises',
      'cap_companies_desc': "Grilles d'entreprises paginées avec chargement différé et détails dynamiques avec des réseaux simulés.",
      'cap_loading': 'Architecture de Chargement Simultané',
      'cap_loading_desc': "Pipelines d'animation doubles intégrés combinant des indicateurs d'actualisation avec des effets de miroitement réalistes.",
      'cap_layouts': 'Mises en Page Responsives Hybrides',
      'cap_layouts_desc': "Barre latérale pliable et éléments d'action flottants avec des moteurs de thème clair et sombre.",

      // ── Document Viewer ────────────────────────────────────
      'crm_terms': 'Conditions de CRM Dashboard App',
      'crm_privacy': 'Confidentialité de CRM Dashboard App',
      'last_updated': 'Dernière mise à jour: 24 mai 2026',

      // ── Custom AppBar ──────────────────────────────────────
      'search_hint': 'Rechercher...',
      'profile_settings': 'Paramètres du Profil',
      'notifications': 'Notifications',
      'close': 'Fermer',
      'new_lead_title': 'Nouveau prospect enregistré',
      'new_lead_desc': 'Clementine Bauch a créé le deal Romaguera-Jacobson.',
      'time_10_min': 'il y a 10 min',
      'meeting_title': 'Réunion Planifiée',
      'meeting_desc': 'Appel vidéo avec John Smith à 14h00 aujourd\'hui.',
      'time_1_hour': 'il y a 1 heure',

      // ── Side Navigation ────────────────────────────────────
      'collapse_sidebar': 'Réduire la Barre Latérale',
      'expand_sidebar': 'Développer la Barre Latérale',
      'switch_to_light': 'Passer au Clair',
      'switch_to_dark': 'Passer au Sombre',

      // ── Global Search ──────────────────────────────────────
      'search_global_hint': 'Rechercher entreprises, e-mails, slogans...',
      'type_to_search': 'Tapez pour rechercher...',
      'no_matches_found': 'Aucune correspondance',
      'results': 'résultats',

      // ── Error & Offline ────────────────────────────────────
      'something_went_wrong': "Quelque chose s'est mal passé",
      'try_again': 'Réessayer',
      'simulated_offline': "Mode hors ligne simulé actif. Les appels API échoueront.",
      'simulated_restored': 'Connexion simulée restaurée!',
      'restore': 'Restaurer',

      // ── Status Badges ──────────────────────────────────────
      'status_active': 'Actif',
      'status_inactive': 'Inactif',
      'status_pending': 'En Attente',
      'status_priority': 'Prioritaire',
      'status_info': 'Info',
    },
  };

  String translate(String key) {
    return _localizedValues[language]?[key] ?? key;
  }

  /// Translate with placeholder replacement. E.g. translate('email_sent_desc').replaceAll('{email}', email)
  String translateWith(String key, Map<String, String> params) {
    var result = _localizedValues[language]?[key] ?? key;
    params.forEach((placeholder, value) {
      result = result.replaceAll('{$placeholder}', value);
    });
    return result;
  }
}

/// Helper extension to easily access translations inside build contexts.
extension LocalizationExtension on BuildContext {
  AppLocalizations tr(WidgetRef ref) {
    final lang = ref.watch(localizationProvider);
    return AppLocalizations(lang);
  }
}
