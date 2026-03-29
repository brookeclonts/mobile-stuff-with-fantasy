// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'StuffWithFantasy';

  @override
  String get bookSingular => 'libro';

  @override
  String get bookPlural => 'libros';

  @override
  String booksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count libros',
      one: '1 libro',
    );
    return '$_temp0';
  }

  @override
  String get catalogSignUpPrompt =>
      'Crea una cuenta para guardar libros en tu lista de lectura.';

  @override
  String get catalogSnackbarActionProfile => 'Perfil';

  @override
  String get catalogTooltipLibrary => 'Biblioteca';

  @override
  String get catalogTooltipProfile => 'Perfil';

  @override
  String get catalogFiltersUnavailable =>
      'Los filtros no están disponibles hasta que la taxonomía se cargue correctamente.';

  @override
  String get catalogRetry => 'Reintentar';

  @override
  String get catalogEmptyFiltered => 'Ningún libro coincide con tus filtros';

  @override
  String get catalogEmptyNoBooks => 'Aún no hay libros';

  @override
  String get catalogClearFilters => 'Limpiar filtros';

  @override
  String get bookDetailSignUpPrompt =>
      'Crea una cuenta desde tu perfil para guardar libros en tu lista de lectura.';

  @override
  String bookDetailByAuthor(String author) {
    return 'de $author';
  }

  @override
  String get bookDetailSectionSubgenres => 'Subgéneros';

  @override
  String get bookDetailSectionTropes => 'Tropos';

  @override
  String get bookDetailSectionRepresentation => 'Representación';

  @override
  String get bookDetailSectionAbout => 'Sobre este libro';

  @override
  String get bookDetailReadMore => 'Leer más';

  @override
  String get bookDetailSectionSimilar => 'También te podría gustar';

  @override
  String get bookDetailBadgeKu => 'KU';

  @override
  String get bookDetailUpdating => 'Actualizando...';

  @override
  String get bookDetailRemoveFromList => 'Quitar de la lista de lectura';

  @override
  String get bookDetailSaving => 'Guardando...';

  @override
  String get bookDetailSaveToList => 'Guardar en la lista de lectura';

  @override
  String get bookDetailOpening => 'Abriendo...';

  @override
  String get bookDetailReadInApp => 'Leer en la App';

  @override
  String get bookDetailGetBook => 'Obtener este libro';

  @override
  String get bookDetailAmazon => 'Amazon US';

  @override
  String get bookDetailAllRetailers => 'Ver todas las tiendas';

  @override
  String get bookDetailAudiobook => 'Audiolibro';

  @override
  String get filterSearchHint => 'Buscar por título o autor...';

  @override
  String get filterChipKu => 'KU';

  @override
  String get filterChipAudiobook => 'Audiolibro';

  @override
  String get filterClearAll => 'Limpiar todo';

  @override
  String get filterSheetTitle => 'Filtros';

  @override
  String get filterSheetReset => 'Restablecer';

  @override
  String get filterSheetSubgenres => 'Subgéneros';

  @override
  String get filterSheetTropes => 'Tropos';

  @override
  String get filterSheetSpiceLevel => 'Nivel de picante';

  @override
  String get filterSheetAgeCategory => 'Categoría de edad';

  @override
  String get filterSheetRepresentation => 'Representación';

  @override
  String get filterSheetLanguageLevel => 'Nivel de lenguaje';

  @override
  String filterSheetApplyWithCount(int count) {
    return 'Aplicar filtros ($count)';
  }

  @override
  String get filterSheetApply => 'Aplicar filtros';

  @override
  String get signUpSkip => 'Omitir';

  @override
  String get rolePickerHeadline => 'Soy un...';

  @override
  String get rolePickerSubtitle => 'Elige cómo quieres usar StuffWithFantasy';

  @override
  String get rolePickerContinue => 'Continuar';

  @override
  String get interestStepHeadline => '¿Qué más te trae por aquí?';

  @override
  String get interestStepSubtitle => 'Selecciona lo que aplique — o avanza.';

  @override
  String get interestCardAuthorTitle => 'Soy autor/a';

  @override
  String get interestCardAuthorDescription =>
      'Quiero que los lectores de fantasía descubran mis libros.';

  @override
  String get interestCardInfluencerTitle => 'Soy influencer';

  @override
  String get interestCardInfluencerDescription =>
      'Creo contenido y quiero compartir libros de fantasía con mi audiencia.';

  @override
  String get interestStepContinue => 'Continuar';

  @override
  String get signUpFormHeadline => 'Crea tu cuenta';

  @override
  String get signUpFormSubtitle => 'Solo unos pocos datos y estarás dentro';

  @override
  String get signUpFieldNameLabel => 'Nombre para mostrar';

  @override
  String get signUpFieldNameHint => '¿Cómo deberíamos llamarte?';

  @override
  String get signUpValidatorEnterName => 'Ingresa tu nombre';

  @override
  String get signUpFieldEmailLabel => 'Correo electrónico';

  @override
  String get signUpFieldEmailHint => 'you@example.com';

  @override
  String get signUpValidatorEnterEmail => 'Ingresa tu correo electrónico';

  @override
  String get signUpValidatorInvalidEmail =>
      'Ingresa un correo electrónico válido';

  @override
  String get signUpFieldPasswordLabel => 'Contraseña';

  @override
  String get signUpFieldPasswordHint => 'Al menos 8 caracteres';

  @override
  String get signUpValidatorEnterPassword => 'Ingresa una contraseña';

  @override
  String get signUpValidatorPasswordTooShort =>
      'Debe tener al menos 8 caracteres';

  @override
  String get signUpButtonCreateAccount => 'Crear cuenta';

  @override
  String welcomeStepHeadline(String name) {
    return '¡Bienvenido/a, $name!';
  }

  @override
  String get welcomeStepSubtitle =>
      'Tu próxima gran aventura fantástica te espera.';

  @override
  String get welcomeStepGetStarted => 'Comenzar';

  @override
  String get profileUnknownRank => 'Rango desconocido';

  @override
  String get profileAppBarTitle => 'Salón del Gremio';

  @override
  String get profileSectionRunes => 'Runas';

  @override
  String get profileSectionRunesSubtitle =>
      'Sella misiones para grabar runas de habilidad.';

  @override
  String get profileSectionQuestLog => 'Registro de Misiones';

  @override
  String get profileSectionQuestLogSubtitle =>
      'Despliega pergaminos para rastrear y sellar objetivos.';

  @override
  String get profileSectionRelicVault => 'Bóveda de Reliquias';

  @override
  String get profileSectionRelicVaultSubtitle =>
      'Sella pergaminos para reclamar reliquias para tu bóveda.';

  @override
  String get profileSectionCharacterSheet => 'Hoja de Personaje';

  @override
  String get profileSnackbarRuneComingSoon =>
      'Esta runa será configurable pronto.';

  @override
  String get profileDeleteAccountTitle => 'Eliminar cuenta';

  @override
  String get profileDeleteAccountBody =>
      'Esto eliminará permanentemente tu cuenta y todos los datos asociados. Esta acción no se puede deshacer.';

  @override
  String get profileDeleteCancel => 'Cancelar';

  @override
  String get profileDeleteConfirm => 'Eliminar';

  @override
  String get profileSigningOut => 'Abandonando el reino...';

  @override
  String get profileSignOut => 'Salir del Reino';

  @override
  String get profileDeletingAccount => 'Eliminando cuenta...';

  @override
  String get profileDeleteAccount => 'Eliminar cuenta';

  @override
  String get profileRetry => 'Reintentar';

  @override
  String get profileErrorHeadline => 'El tablón de misiones no se pudo cargar';

  @override
  String get profileTryAgain => 'Intentar de nuevo';

  @override
  String get guestGuildHallLabel => 'SALÓN DEL GREMIO';

  @override
  String get guestGuildHeadline => 'Comienza tu misión';

  @override
  String get guestGuildBody =>
      'Crea una cuenta para rastrear tus misiones de lectura, desbloquear runas de habilidad y coleccionar reliquias mientras exploras el reino.';

  @override
  String get guestGuildButtonCreateAccount => 'Crear cuenta para comenzar';

  @override
  String get runeStatusEngraved => 'GRABADA';

  @override
  String get runeStatusLocked => 'BLOQUEADA';

  @override
  String get runeDetailLockedHint =>
      'Completa la misión vinculada para grabar esta runa';

  @override
  String get runeDetailConfigure => 'Configurar';

  @override
  String get arcShieldTitle => 'Escudo ARC';

  @override
  String get arcShieldDescription =>
      'Cuando está activo, autores y editoriales pueden encontrarte como lector de ARC.';

  @override
  String get arcShieldSectionAvailability => 'Disponibilidad';

  @override
  String get arcShieldToggleOpenLabel => 'Abierto a ARCs';

  @override
  String get arcShieldToggleClosedLabel => 'No aceptando ARCs';

  @override
  String get arcShieldToggleOpenSubtitle => 'Los autores pueden contactarte';

  @override
  String get arcShieldToggleClosedSubtitle =>
      'Tu perfil está oculto en las búsquedas de ARC';

  @override
  String get genreAttunementTitle => 'Sintonización de Género';

  @override
  String get genreAttunementDescription =>
      'Selecciona los géneros y tropos que te llaman. El reino aprenderá qué mostrarte.';

  @override
  String get genreAttunementSectionGenres => 'Géneros';

  @override
  String get genreAttunementSectionTropes => 'Tropos';

  @override
  String genreAttunementCountAttuned(int count) {
    return '$count sintonizados';
  }

  @override
  String get genreEpicFantasy => 'Fantasía Épica';

  @override
  String get genreDarkFantasy => 'Fantasía Oscura';

  @override
  String get genreUrbanFantasy => 'Fantasía Urbana';

  @override
  String get genreRomantasy => 'Romantasy';

  @override
  String get genreCozyFantasy => 'Fantasía Acogedora';

  @override
  String get genreGrimdark => 'Grimdark';

  @override
  String get genreLitRpg => 'LitRPG';

  @override
  String get genreSwordAndSorcery => 'Espada y Hechicería';

  @override
  String get genreMythicFantasy => 'Fantasía Mítica';

  @override
  String get genrePortalFantasy => 'Fantasía de Portal';

  @override
  String get tropeFoundFamily => 'Familia encontrada';

  @override
  String get tropeEnemiesToLovers => 'De enemigos a amantes';

  @override
  String get tropeChosenOne => 'El Elegido';

  @override
  String get tropeMagicSchools => 'Escuelas de magia';

  @override
  String get tropeMorallyGrey => 'Moralmente gris';

  @override
  String get tropeSlowBurn => 'Slow Burn';

  @override
  String get tropePoliticalIntrigue => 'Intriga política';

  @override
  String get tropeQuestJourney => 'Viaje de misión';

  @override
  String get tropeHiddenRoyalty => 'Realeza oculta';

  @override
  String get tropeRevengeArc => 'Arco de venganza';

  @override
  String get eventWatchtowerTitle => 'Torre de Vigía';

  @override
  String get eventWatchtowerDescription =>
      'Elige qué señales te llegan del reino.';

  @override
  String get eventWatchtowerSectionSignals => 'Señales';

  @override
  String get notifNewEventsTitle => 'Nuevos eventos';

  @override
  String get notifNewEventsDescription =>
      'Cuando se lanza un evento Stuff Your Kindle';

  @override
  String get notifBookDropsTitle => 'Nuevos libros';

  @override
  String get notifBookDropsDescription =>
      'Cuando se añaden nuevos libros al catálogo';

  @override
  String get notifRecommendationsTitle => 'Recomendaciones';

  @override
  String get notifRecommendationsDescription =>
      'Selecciones personalizadas basadas en tu sintonización';

  @override
  String get rewardRevealBarrierLabel => 'Revelación de recompensa';

  @override
  String get rewardRevealLegendRelicClaimed => 'RELIQUIA LEGENDARIA RECLAMADA';

  @override
  String get rewardRevealRelicUnlocked => 'RELIQUIA DESBLOQUEADA';

  @override
  String get rewardRevealContinue => 'Continuar la aventura';

  @override
  String get characterSheetHeaderLabel => 'HOJA DE PERSONAJE';

  @override
  String get characterSheetStatName => 'Nombre';

  @override
  String get characterSheetStatRank => 'Rango';

  @override
  String get characterSheetStatQuests => 'Misiones';

  @override
  String characterSheetStatQuestsValue(int completed, int total) {
    return '$completed / $total';
  }

  @override
  String get characterSheetStatRelics => 'Reliquias';

  @override
  String characterSheetStatRelicsValue(int collected, int total) {
    return '$collected / $total';
  }

  @override
  String get characterSheetStatSignal => 'Señal';

  @override
  String get realmMapCurrentQuest => 'MISIÓN ACTUAL';

  @override
  String get questScrollSealed => 'Sellada';

  @override
  String get questScrollActive => 'ACTIVA';

  @override
  String get questScrollReward => 'RECOMPENSA';

  @override
  String get relicVaultLockedTitle => '???';

  @override
  String get relicVaultLegendRelic => 'Reliquia legendaria';

  @override
  String get relicVaultClaimed => 'Reclamada';

  @override
  String get relicVaultSealed => 'Sellada';

  @override
  String get libraryAppBarTitle => 'Biblioteca';

  @override
  String get libraryTabMyBooks => 'Mis libros';

  @override
  String get libraryTabReadingList => 'Lista de lectura';

  @override
  String get libraryMyBooksSignInTitle => 'Tu estantería te espera';

  @override
  String get libraryMyBooksSignInMessage =>
      'Inicia sesión para acceder a los libros que has comprado, reclamado o subido — listos para leer aquí mismo.';

  @override
  String get libraryMyBooksEmptyTitle => 'Aún no hay libros para leer';

  @override
  String get libraryMyBooksEmptyMessage =>
      'Los libros que compres, reclames o subas aparecerán aquí cuando estén listos para leer.';

  @override
  String get libraryReadingListSignInTitle => 'Comienza tu lista de lectura';

  @override
  String get libraryReadingListSignInMessage =>
      'Inicia sesión para guardar libros del catálogo y armar tu lista de lectura personal.';

  @override
  String get libraryReadingListEmptyTitle => 'Nada guardado aún';

  @override
  String get libraryReadingListEmptyMessage =>
      'Guarda libros del catálogo para armar tu lista de lectura.';

  @override
  String get libraryButtonSignIn => 'Iniciar sesión';

  @override
  String get libraryRetry => 'Reintentar';

  @override
  String readerProgressRead(String progress) {
    return '$progress leído';
  }

  @override
  String get readerHintSwipeToTurn => 'Desliza para pasar de página';

  @override
  String get readerHintOpeningBook => 'Abriendo libro…';

  @override
  String get readerHintTapToHide => 'Toca el centro para ocultar los controles';

  @override
  String get readerTooltipBack => 'Atrás';

  @override
  String get readerTooltipChapters => 'Capítulos';

  @override
  String get readerTooltipReadingSettings => 'Ajustes de lectura';

  @override
  String get readerTooltipPreviousPage => 'Página anterior';

  @override
  String get readerButtonPrev => 'Ant.';

  @override
  String get readerTooltipNextPage => 'Página siguiente';

  @override
  String get readerButtonNext => 'Sig.';

  @override
  String get readerChaptersTitle => 'Capítulos';

  @override
  String get readerSettingsTitle => 'Ajustes de lectura';

  @override
  String get readerSettingsTextSize => 'Tamaño del texto';

  @override
  String get readerTooltipSmallerText => 'Texto más pequeño';

  @override
  String readerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get readerTooltipLargerText => 'Texto más grande';

  @override
  String get readerSettingsPageTheme => 'Tema de página';

  @override
  String get readerAppearancePaper => 'Papel';

  @override
  String get readerAppearanceSepia => 'Sepia';

  @override
  String get readerAppearanceNight => 'Noche';

  @override
  String get eventDetailLoadingBooks => 'Cargando libros...';

  @override
  String eventDetailBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count libros en este evento',
      one: '1 libro en este evento',
    );
    return '$_temp0';
  }

  @override
  String get eventDetailNoBooksYet => 'Aún no hay libros en este evento.';

  @override
  String get creatorDetailNoBooksYet => 'Aún no hay libros para mostrar.';

  @override
  String get creatorDetailFavoriteBookLabel => 'Libro favorito: ';

  @override
  String get creatorDetailLovesLabel => 'Le encanta: ';

  @override
  String creatorDetailBooksBy(String name) {
    return 'Libros de $name';
  }

  @override
  String creatorDetailRecommendedBy(String name) {
    return 'Recomendado por $name';
  }

  @override
  String get socialLinkTiktok => 'TikTok';

  @override
  String get socialLinkInstagram => 'Instagram';

  @override
  String get socialLinkYoutube => 'YouTube';

  @override
  String get socialLinkThreads => 'Threads';

  @override
  String get socialLinkGoodreads => 'Goodreads';

  @override
  String get socialLinkStorygraph => 'StoryGraph';

  @override
  String get socialLinkBookbub => 'BookBub';

  @override
  String get socialLinkFacebook => 'Facebook';

  @override
  String get socialLinkWebsite => 'Sitio web';

  @override
  String get userRoleReader => 'Lector/a';

  @override
  String get userRoleReaderDescription =>
      'Descubre tu próximo libro de fantasía favorito';

  @override
  String get creatorRoleAuthor => 'Autor/a';

  @override
  String get creatorRoleInfluencer => 'Influencer';

  @override
  String get readAccessOwner => 'Tu subida';

  @override
  String get readAccessPurchased => 'Comprado';

  @override
  String get readAccessNone => 'Sin acceso';

  @override
  String get eventStatusLastDay => '¡Último día!';

  @override
  String get eventStatusHappeningNow => 'En curso ahora';

  @override
  String get eventStatusStartsToday => 'Comienza hoy';

  @override
  String get eventStatusStartsTomorrow => 'Comienza mañana';

  @override
  String eventStatusStartsInDays(int days) {
    return 'Comienza en $days días';
  }

  @override
  String get spiceLevelNone => 'Sin picante';

  @override
  String get spiceLevelMild => 'Picante suave';

  @override
  String get spiceLevelMedium => 'Picante medio';

  @override
  String get spiceLevelHot => 'Picante fuerte';

  @override
  String get spiceLevelScorching => 'Abrasador';

  @override
  String get languageLevelClean => 'Limpio';

  @override
  String get languageLevelMild => 'Lenguaje suave';

  @override
  String get languageLevelModerate => 'Lenguaje moderado';

  @override
  String get languageLevelStrong => 'Lenguaje fuerte';

  @override
  String get homeHeadline => 'Stuff With Fantasy';

  @override
  String get homeTagline => 'Tu compañero de lectura fantástica.';

  @override
  String get homeSubtitle =>
      'Descubre, rastrea y comparte los libros de fantasía que amas.';

  @override
  String get homeChipMaterial3 => 'Material 3';

  @override
  String get homeChipStructuredStarter => 'Inicio estructurado';

  @override
  String get homeChipWidgetTests => 'Tests de widgets';

  @override
  String get homeCardWhatIsReadyTitle => 'Qué está listo';

  @override
  String get homeCardWhatIsReadyItem1 =>
      'Una app con marca propia con temas claro y oscuro.';

  @override
  String get homeCardWhatIsReadyItem2 =>
      'Una línea base de análisis más estricta usando flutter_lints.';

  @override
  String get homeCardWhatIsReadyItem3 =>
      'Un test de widget para proteger la experiencia inicial.';

  @override
  String get homeCardWhereToGoNextTitle => 'A dónde ir después';

  @override
  String get homeCardWhereToGoNextItem1 =>
      'Añade funciones bajo lib/src por dominio en vez de hacer crecer main.dart.';

  @override
  String get homeCardWhereToGoNextItem2 =>
      'Reemplaza los assets de ejemplo, iconos de lanzamiento y textos de producto.';

  @override
  String get homeCardWhereToGoNextItem3 =>
      'Ejecuta flutter analyze y flutter test mientras añades pantallas.';

  @override
  String get homeGetStarted => 'Comenzar';

  @override
  String get homeBrowseBooks => 'Explorar libros';

  @override
  String get monthJan => 'Ene';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Abr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Ago';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Oct';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dic';

  @override
  String get profileSectionLanguage => 'Idioma';

  @override
  String get languageSystemDefault => 'Predeterminado del sistema';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageBulgarian => 'Български';

  @override
  String get languageJapanese => '日本語';

  @override
  String get profileSectionReadingChronicle => 'Crónica de Lectura';

  @override
  String get profileSectionReadingChronicleSubtitle =>
      'Tu travesía por las páginas, trazada en tinta.';

  @override
  String get profileSectionTomeCounter => 'Contador de Tomos';

  @override
  String get profileSectionTomeCounterSubtitle =>
      'Tus hazañas de lectura acumuladas.';

  @override
  String get profileSectionAchievementSigils => 'Sigilos de Logro';

  @override
  String get profileSectionAchievementSigilsSubtitle =>
      'Hitos forjados con dedicación.';

  @override
  String chroniclePagesThisWeek(int count) {
    return '~$count páginas esta semana';
  }

  @override
  String chronicleStreak(int count) {
    return 'Racha de $count días';
  }

  @override
  String get chronicleLess => 'Menos';

  @override
  String get chronicleMore => 'Más';

  @override
  String get tomeCounterBooks => 'Tomos conquistados';

  @override
  String get tomeCounterPages => 'Páginas pasadas';

  @override
  String get tomeCounterTime => 'Tiempo en el reino';

  @override
  String tomeCounterHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String tomeCounterMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String get achievementLocked => 'SELLADO';

  @override
  String get achievementUnlocked => 'OBTENIDO';

  @override
  String get achievementFirstPageTitle => 'Primera Página';

  @override
  String get achievementFirstPageDesc => 'Abre un libro y comienza a leer.';

  @override
  String get achievementBookwormTitle => 'El Ratón de Biblioteca Despierta';

  @override
  String get achievementBookwormDesc => 'Termina tu primer libro.';

  @override
  String get achievementDailyRitualTitle => 'Ritual Diario';

  @override
  String get achievementDailyRitualDesc => 'Lee durante 3 días seguidos.';

  @override
  String get achievementPageTurnerTitle => 'Pasapáginas';

  @override
  String get achievementPageTurnerDesc => 'Lee aproximadamente 100 páginas.';

  @override
  String get achievementHourGlassTitle => 'Reloj de Arena';

  @override
  String get achievementHourGlassDesc => 'Pasa 1 hora leyendo.';

  @override
  String get achievementChapterChampionTitle => 'Campeón de Capítulos';

  @override
  String get achievementChapterChampionDesc => 'Termina 3 libros.';

  @override
  String get achievementFlameKeeperTitle => 'Guardián de la Llama';

  @override
  String get achievementFlameKeeperDesc => 'Lee durante 7 días seguidos.';

  @override
  String get achievementTomeScholarTitle => 'Erudito de Tomos';

  @override
  String get achievementTomeScholarDesc => 'Lee aproximadamente 1.000 páginas.';

  @override
  String get achievementDevotedReaderTitle => 'Lector Devoto';

  @override
  String get achievementDevotedReaderDesc => 'Pasa 10 horas leyendo.';

  @override
  String get achievementFiveRealmsTitle => 'Cinco Reinos';

  @override
  String get achievementFiveRealmsDesc =>
      'Comienza a leer 5 libros diferentes.';

  @override
  String get achievementGrandLibrarianTitle => 'Gran Bibliotecario';

  @override
  String get achievementGrandLibrarianDesc => 'Termina 10 libros.';

  @override
  String get achievementEternalFlameTitle => 'Llama Eterna';

  @override
  String get achievementEternalFlameDesc =>
      'Mantén una racha de lectura de 30 días.';

  @override
  String get achievementMythicScribeTitle => 'Escriba Mítico';

  @override
  String get achievementMythicScribeDesc => 'Pasa 100 horas leyendo.';

  @override
  String get achievementRealmWalkerTitle => 'Caminante de Reinos';

  @override
  String get achievementRealmWalkerDesc =>
      'Comienza a leer 10 libros diferentes.';

  @override
  String get oathAppBarTitle => 'Piedra del Juramento';

  @override
  String get oathSectionTitle => 'Piedra del Juramento';

  @override
  String get oathSectionSubtitle => 'Tu juramento de lectura';

  @override
  String get oathSwearCta => 'Presta un Juramento';

  @override
  String get oathSwearSubtitle =>
      'Establece una meta de lectura pública y rastrea tu progreso';

  @override
  String get oathSwearPageTitle => 'Inscribe Tu Juramento';

  @override
  String get oathFieldTitle => 'Tu compromiso';

  @override
  String get oathFieldTitleHint => 'Leeré 24 libros en 2026';

  @override
  String get oathFieldTarget => 'Libros objetivo';

  @override
  String get oathFieldYear => 'Año';

  @override
  String get oathFieldPublic => 'Juramento público';

  @override
  String get oathFieldPublicSubtitle => 'Visible en el Tablón de Leyendas';

  @override
  String get oathSwearButton => 'Prestar este Juramento';

  @override
  String get oathSwearing => 'Inscribiendo...';

  @override
  String oathProgressLabel(int current, int target) {
    return '$current de $target';
  }

  @override
  String get oathProgressComplete => '¡Juramento cumplido!';

  @override
  String get oathEntryLogged => '¡Runa grabada!';

  @override
  String get oathEntryRemoved => 'Entrada eliminada';

  @override
  String get oathDeleteConfirmTitle => '¿Romper este Juramento?';

  @override
  String get oathDeleteConfirmBody =>
      'Esto eliminará permanentemente tu juramento y todas las entradas registradas.';

  @override
  String get oathDeleteCancel => 'Mantener Juramento';

  @override
  String get oathDeleteConfirm => 'Romper Juramento';

  @override
  String get oathDeleted => 'Juramento roto';

  @override
  String get oathCompleteTitle => 'JURAMENTO CUMPLIDO';

  @override
  String get oathCompleteHeadline => 'Tu Juramento ha sido Sellado';

  @override
  String get oathCompleteBody =>
      'Has honrado tu compromiso. Las runas están completas.';

  @override
  String get oathCompleteContinue => 'Continuar';

  @override
  String get oathEmptyEntries => 'Aún no se han registrado libros';

  @override
  String get oathLogBookAction => 'Registrar hacia el Juramento';

  @override
  String oathLogBookConfirm(String title) {
    return '¿Registrar \"$title\" hacia tu juramento?';
  }

  @override
  String get oathLogBookButton => 'Registrar';

  @override
  String get oathAlreadyLogged => 'Ya registrado hacia tu juramento';

  @override
  String get oathEditButton => 'Editar Juramento';

  @override
  String get oathUpdated => 'Juramento actualizado';

  @override
  String get oathErrorCreate => 'No se pudo crear el juramento';

  @override
  String get oathErrorLoad => 'No se pudo cargar el juramento';

  @override
  String get oathGuestHeadline => 'La Piedra del Juramento Espera';

  @override
  String get oathGuestBody =>
      'Crea una cuenta para prestar un juramento de lectura y rastrear tu progreso.';

  @override
  String get seasonalCampaignLabel => 'Campaña Estacional';

  @override
  String get seasonalCampaignExpired => 'Expedición finalizada';

  @override
  String get seasonalCampaignLastDay => '¡Último día!';

  @override
  String seasonalCampaignCountdownDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días restantes',
      one: '1 día restante',
    );
    return '$_temp0';
  }

  @override
  String seasonalCampaignCountdownMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months meses restantes',
      one: '1 mes restante',
    );
    return '$_temp0';
  }

  @override
  String seasonalCampaignCountdownMonthsDays(int months, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months meses',
      one: '1 mes',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días restantes',
      one: '1 día restante',
    );
    return '$_temp0, $_temp1';
  }

  @override
  String get seasonalRelicSectionTitle => 'Reliquias Estacionales';

  @override
  String get profileSectionSeasonalQuests => 'Misiones Estacionales';

  @override
  String get profileSectionSeasonalQuestsSubtitle =>
      'Expediciones por tiempo limitado con reliquias exclusivas.';

  @override
  String get realmRankingsTitle => 'Clasificación del Reino';

  @override
  String get leaderboardMetricQuests => 'Misiones';

  @override
  String get leaderboardMetricBooks => 'Libros';

  @override
  String get leaderboardMetricRelics => 'Reliquias';

  @override
  String leaderboardTotalParticipants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aventureros clasificados',
      one: '1 aventurero clasificado',
    );
    return '$_temp0';
  }

  @override
  String get leaderboardYourPosition => 'TU POSICIÓN';

  @override
  String leaderboardPositionOfTotal(int position, int total) {
    return '#$position de $total';
  }

  @override
  String get leaderboardErrorHeadline => 'La clasificación no se pudo cargar';

  @override
  String get leaderboardOptInTitle => 'Clasificación del Reino';

  @override
  String get leaderboardOptInDescription =>
      'Compite con otros aventureros uniéndote a la clasificación del reino. Tu posición se basa en misiones selladas, libros leídos y reliquias coleccionadas.';

  @override
  String get leaderboardOptInPrivacy =>
      'Solo tu nombre para mostrar y rango son visibles para otros.';

  @override
  String get leaderboardOptInActive => 'Clasificado en el reino';

  @override
  String get leaderboardOptInInactive => 'Sin clasificar';

  @override
  String get leaderboardOptInJoinButton => 'Unirse a la Clasificación';

  @override
  String get leaderboardOptInLeaveButton => 'Abandonar la Clasificación';

  @override
  String get characterSheetStatRealmRank => 'Reino';

  @override
  String get characterSheetRealmRankJoin => 'Unirse a la Clasificación';

  @override
  String get skillTreeSectionTitle => 'Árbol de Habilidades';

  @override
  String get skillTreeSectionSubtitle =>
      'Desarrolla tu maestría de género a través de la lectura.';

  @override
  String skillTreeXpProgress(int current, int next) {
    return '$current / $next XP';
  }

  @override
  String skillTreeXpLabel(int xp) {
    return '$xp XP';
  }

  @override
  String get skillTreeTiersLabel => 'Niveles';

  @override
  String get skillTreeTierUnlocked => 'DESBLOQUEADO';

  @override
  String get skillTreeTierCurrent => 'EN PROGRESO';

  @override
  String get skillTreeTierLocked => 'BLOQUEADO';

  @override
  String skillTreeRuneUnlocked(String runeTitle) {
    return 'Runa desbloqueada: $runeTitle';
  }

  @override
  String skillTreeRuneLockedAt(String runeTitle) {
    return 'Desbloquea: $runeTitle';
  }

  @override
  String get loreBoardTitle => 'Tablón de Leyendas';

  @override
  String get loreBoardGlobalTab => 'Global';

  @override
  String get loreBoardFriendsTab => 'Amigos';

  @override
  String get loreBoardEmpty =>
      'El tablón está vacío... aún no se han publicado relatos.';

  @override
  String get loreBoardTooltip => 'Tablón de Leyendas';

  @override
  String get guildHubTitle => 'Salón del Gremio';

  @override
  String get guildHubEmpty =>
      'Aún no te has unido a ningún gremio. Funda el tuyo o descubre los existentes.';

  @override
  String get guildCreateButton => 'Fundar un Nuevo Gremio';

  @override
  String get guildDiscoverButton => 'Descubrir Gremios';

  @override
  String get guildDetailCompanions => 'Compañeros';

  @override
  String get guildDetailLedger => 'Libro de Cuentas del Grupo';

  @override
  String get guildDetailLedgerEmpty => 'Aún no hay libros en el registro.';

  @override
  String get guildJoinButton => 'Unirse al Gremio';

  @override
  String get guildJoined => '¡Te has unido al gremio!';

  @override
  String get guildLeaveButton => 'Abandonar el Gremio';

  @override
  String get guildLeft => 'Has abandonado el gremio.';

  @override
  String get guildDeleteConfirmTitle => '¿Disolver este Gremio?';

  @override
  String get guildDeleteConfirmBody =>
      'Esto eliminará permanentemente el gremio y todos sus datos. Esta acción no se puede deshacer.';

  @override
  String get guildDeleteCancel => 'Mantener Gremio';

  @override
  String get guildDeleteConfirm => 'Disolver Gremio';

  @override
  String get guildDeleted => 'Gremio disuelto';

  @override
  String get guildCreated => '¡Gremio fundado!';

  @override
  String get guildUpdated => 'Gremio actualizado';

  @override
  String get guildCreatePageTitle => 'Fundar un Gremio';

  @override
  String get guildFieldName => 'Nombre del gremio';

  @override
  String get guildFieldNameHint => 'La Hermandad de las Páginas';

  @override
  String get guildFieldDescription => 'Descripción';

  @override
  String get guildFieldDescriptionHint => '¿De qué trata tu gremio?';

  @override
  String get guildFieldPublic => 'Gremio público';

  @override
  String get guildFieldPublicSubtitle =>
      'Visible en el Tablón de Gremios para que cualquiera se una';

  @override
  String get guildCreateSubmit => 'Fundar este Gremio';

  @override
  String get guildCreating => 'Fundando...';

  @override
  String get guildDiscoverTitle => 'Tablón de Gremios';

  @override
  String get guildDiscoverEmpty => 'Aún no hay gremios por descubrir.';

  @override
  String guildMemberCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count compañeros',
      one: '1 compañero',
    );
    return '$_temp0';
  }

  @override
  String get guildRoleGuildmaster => 'Maestro del Gremio';

  @override
  String get guildRoleCompanion => 'Compañero';

  @override
  String get guildGuestHeadline => 'El Salón del Gremio Espera';

  @override
  String get guildGuestBody =>
      'Crea una cuenta para fundar gremios, unirte a grupos de lectura y crear registros con otros aventureros.';

  @override
  String get guildAddToLedger => 'Añadir al Registro';

  @override
  String get guildBookAdded => '¡Libro añadido al registro!';

  @override
  String get guildBookRemoved => 'Libro eliminado del registro.';

  @override
  String get guildAlreadyMember => 'Ya eres miembro de este gremio.';
}
