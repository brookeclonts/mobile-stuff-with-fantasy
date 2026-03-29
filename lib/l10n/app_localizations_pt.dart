// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'StuffWithFantasy';

  @override
  String get bookSingular => 'livro';

  @override
  String get bookPlural => 'livros';

  @override
  String booksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count livros',
      one: '1 livro',
    );
    return '$_temp0';
  }

  @override
  String get catalogSignUpPrompt =>
      'Crie uma conta para salvar livros na sua lista de leitura.';

  @override
  String get catalogSnackbarActionProfile => 'Perfil';

  @override
  String get catalogTooltipLibrary => 'Biblioteca';

  @override
  String get catalogTooltipProfile => 'Perfil';

  @override
  String get catalogFiltersUnavailable =>
      'Os filtros estão indisponíveis até que a taxonomia seja carregada com sucesso.';

  @override
  String get catalogRetry => 'Tentar novamente';

  @override
  String get catalogEmptyFiltered =>
      'Nenhum livro corresponde aos seus filtros';

  @override
  String get catalogEmptyNoBooks => 'Nenhum livro ainda';

  @override
  String get catalogClearFilters => 'Limpar Filtros';

  @override
  String get bookDetailSignUpPrompt =>
      'Crie uma conta a partir do seu perfil para salvar livros na sua lista de leitura.';

  @override
  String bookDetailByAuthor(String author) {
    return 'por $author';
  }

  @override
  String get bookDetailSectionSubgenres => 'Subgêneros';

  @override
  String get bookDetailSectionTropes => 'Tropos';

  @override
  String get bookDetailSectionRepresentation => 'Representatividade';

  @override
  String get bookDetailSectionAbout => 'Sobre este livro';

  @override
  String get bookDetailReadMore => 'Leia mais';

  @override
  String get bookDetailSectionSimilar => 'Você também pode gostar';

  @override
  String get bookDetailBadgeKu => 'KU';

  @override
  String get bookDetailUpdating => 'Atualizando...';

  @override
  String get bookDetailRemoveFromList => 'Remover da Lista de Leitura';

  @override
  String get bookDetailSaving => 'Salvando...';

  @override
  String get bookDetailSaveToList => 'Salvar na Lista de Leitura';

  @override
  String get bookDetailOpening => 'Abrindo...';

  @override
  String get bookDetailReadInApp => 'Ler no App';

  @override
  String get bookDetailGetBook => 'Obter este Livro';

  @override
  String get bookDetailAmazon => 'Amazon US';

  @override
  String get bookDetailAllRetailers => 'Ver todos os varejistas';

  @override
  String get bookDetailAudiobook => 'Audiolivro';

  @override
  String get filterSearchHint => 'Buscar por título ou autor...';

  @override
  String get filterChipKu => 'KU';

  @override
  String get filterChipAudiobook => 'Audiolivro';

  @override
  String get filterClearAll => 'Limpar tudo';

  @override
  String get filterSheetTitle => 'Filtros';

  @override
  String get filterSheetReset => 'Redefinir';

  @override
  String get filterSheetSubgenres => 'Subgêneros';

  @override
  String get filterSheetTropes => 'Tropos';

  @override
  String get filterSheetSpiceLevel => 'Nível de Picância';

  @override
  String get filterSheetAgeCategory => 'Faixa Etária';

  @override
  String get filterSheetRepresentation => 'Representatividade';

  @override
  String get filterSheetLanguageLevel => 'Nível de Linguagem';

  @override
  String filterSheetApplyWithCount(int count) {
    return 'Aplicar Filtros ($count)';
  }

  @override
  String get filterSheetApply => 'Aplicar Filtros';

  @override
  String get signUpSkip => 'Pular';

  @override
  String get rolePickerHeadline => 'Eu sou um(a)...';

  @override
  String get rolePickerSubtitle =>
      'Escolha como você quer usar o StuffWithFantasy';

  @override
  String get rolePickerContinue => 'Continuar';

  @override
  String get interestStepHeadline => 'O que mais te traz aqui?';

  @override
  String get interestStepSubtitle =>
      'Selecione o que se aplica — ou pule essa etapa.';

  @override
  String get interestCardAuthorTitle => 'Sou Autor(a)';

  @override
  String get interestCardAuthorDescription =>
      'Quero que meus livros sejam descobertos por leitores de fantasia.';

  @override
  String get interestCardInfluencerTitle => 'Sou Influenciador(a)';

  @override
  String get interestCardInfluencerDescription =>
      'Crio conteúdo e quero compartilhar livros de fantasia com meu público.';

  @override
  String get interestStepContinue => 'Continuar';

  @override
  String get signUpFormHeadline => 'Crie sua conta';

  @override
  String get signUpFormSubtitle => 'Só alguns detalhes e você entra';

  @override
  String get signUpFieldNameLabel => 'Nome de exibição';

  @override
  String get signUpFieldNameHint => 'Como devemos te chamar?';

  @override
  String get signUpValidatorEnterName => 'Digite seu nome';

  @override
  String get signUpFieldEmailLabel => 'Email';

  @override
  String get signUpFieldEmailHint => 'voce@exemplo.com';

  @override
  String get signUpValidatorEnterEmail => 'Digite seu email';

  @override
  String get signUpValidatorInvalidEmail => 'Digite um email válido';

  @override
  String get signUpFieldPasswordLabel => 'Senha';

  @override
  String get signUpFieldPasswordHint => 'Pelo menos 8 caracteres';

  @override
  String get signUpValidatorEnterPassword => 'Digite uma senha';

  @override
  String get signUpValidatorPasswordTooShort =>
      'Deve ter pelo menos 8 caracteres';

  @override
  String get signUpButtonCreateAccount => 'Criar Conta';

  @override
  String welcomeStepHeadline(String name) {
    return 'Bem-vindo(a), $name!';
  }

  @override
  String get welcomeStepSubtitle =>
      'Sua próxima grande aventura de fantasia está te esperando.';

  @override
  String get welcomeStepGetStarted => 'Começar';

  @override
  String get profileUnknownRank => 'Posto Desconhecido';

  @override
  String get profileAppBarTitle => 'Salão da Guilda';

  @override
  String get profileSectionRunes => 'Runas';

  @override
  String get profileSectionRunesSubtitle =>
      'Sele missões para gravar runas de habilidade.';

  @override
  String get profileSectionQuestLog => 'Registro de Missões';

  @override
  String get profileSectionQuestLogSubtitle =>
      'Desenrole pergaminhos para rastrear e selar objetivos.';

  @override
  String get profileSectionRelicVault => 'Cofre de Relíquias';

  @override
  String get profileSectionRelicVaultSubtitle =>
      'Sele pergaminhos para reivindicar relíquias para seu cofre.';

  @override
  String get profileSectionCharacterSheet => 'Ficha de Personagem';

  @override
  String get profileSnackbarRuneComingSoon =>
      'Esta runa será configurável em breve.';

  @override
  String get profileDeleteAccountTitle => 'Excluir Conta';

  @override
  String get profileDeleteAccountBody =>
      'Isso excluirá permanentemente sua conta e todos os dados associados. Essa ação não pode ser desfeita.';

  @override
  String get profileDeleteCancel => 'Cancelar';

  @override
  String get profileDeleteConfirm => 'Excluir';

  @override
  String get profileSigningOut => 'Deixando o reino...';

  @override
  String get profileSignOut => 'Sair do Reino';

  @override
  String get profileDeletingAccount => 'Excluindo conta...';

  @override
  String get profileDeleteAccount => 'Excluir Conta';

  @override
  String get profileRetry => 'Tentar novamente';

  @override
  String get profileErrorHeadline => 'O quadro de missões falhou ao carregar';

  @override
  String get profileTryAgain => 'Tentar novamente';

  @override
  String get guestGuildHallLabel => 'SALÃO DA GUILDA';

  @override
  String get guestGuildHeadline => 'Comece sua missão';

  @override
  String get guestGuildBody =>
      'Crie uma conta para rastrear suas missões de leitura, desbloquear runas de habilidade e coletar relíquias enquanto explora o reino.';

  @override
  String get guestGuildButtonCreateAccount => 'Criar conta para começar';

  @override
  String get runeStatusEngraved => 'GRAVADA';

  @override
  String get runeStatusLocked => 'BLOQUEADA';

  @override
  String get runeDetailLockedHint =>
      'Complete a missão vinculada para gravar esta runa';

  @override
  String get runeDetailConfigure => 'Configurar';

  @override
  String get arcShieldTitle => 'Escudo ARC';

  @override
  String get arcShieldDescription =>
      'Quando ativo, autores e editoras podem encontrar você como leitor(a) de ARC.';

  @override
  String get arcShieldSectionAvailability => 'Disponibilidade';

  @override
  String get arcShieldToggleOpenLabel => 'Aberto a ARCs';

  @override
  String get arcShieldToggleClosedLabel => 'Não aceitando ARCs';

  @override
  String get arcShieldToggleOpenSubtitle =>
      'Autores podem entrar em contato com você';

  @override
  String get arcShieldToggleClosedSubtitle =>
      'Seu perfil está oculto das buscas de ARC';

  @override
  String get genreAttunementTitle => 'Sintonia de Gênero';

  @override
  String get genreAttunementDescription =>
      'Selecione os gêneros e tropos que te chamam. O reino aprenderá o que mostrar.';

  @override
  String get genreAttunementSectionGenres => 'Gêneros';

  @override
  String get genreAttunementSectionTropes => 'Tropos';

  @override
  String genreAttunementCountAttuned(int count) {
    return '$count sintonizados';
  }

  @override
  String get genreEpicFantasy => 'Fantasia Épica';

  @override
  String get genreDarkFantasy => 'Fantasia Sombria';

  @override
  String get genreUrbanFantasy => 'Fantasia Urbana';

  @override
  String get genreRomantasy => 'Romantasia';

  @override
  String get genreCozyFantasy => 'Fantasia Aconchegante';

  @override
  String get genreGrimdark => 'Grimdark';

  @override
  String get genreLitRpg => 'LitRPG';

  @override
  String get genreSwordAndSorcery => 'Espada e Feitiçaria';

  @override
  String get genreMythicFantasy => 'Fantasia Mítica';

  @override
  String get genrePortalFantasy => 'Fantasia de Portal';

  @override
  String get tropeFoundFamily => 'Família Encontrada';

  @override
  String get tropeEnemiesToLovers => 'De Inimigos a Amantes';

  @override
  String get tropeChosenOne => 'O Escolhido';

  @override
  String get tropeMagicSchools => 'Escolas de Magia';

  @override
  String get tropeMorallyGrey => 'Moralmente Ambíguo';

  @override
  String get tropeSlowBurn => 'Slow Burn';

  @override
  String get tropePoliticalIntrigue => 'Intriga Política';

  @override
  String get tropeQuestJourney => 'Jornada de Missão';

  @override
  String get tropeHiddenRoyalty => 'Realeza Oculta';

  @override
  String get tropeRevengeArc => 'Arco de Vingança';

  @override
  String get eventWatchtowerTitle => 'Torre de Vigia';

  @override
  String get eventWatchtowerDescription =>
      'Escolha quais sinais chegam até você do reino.';

  @override
  String get eventWatchtowerSectionSignals => 'Sinais';

  @override
  String get notifNewEventsTitle => 'Novos Eventos';

  @override
  String get notifNewEventsDescription =>
      'Quando um evento Stuff Your Kindle é lançado';

  @override
  String get notifBookDropsTitle => 'Novos Livros';

  @override
  String get notifBookDropsDescription =>
      'Quando novos livros são adicionados ao catálogo';

  @override
  String get notifRecommendationsTitle => 'Recomendações';

  @override
  String get notifRecommendationsDescription =>
      'Sugestões personalizadas com base na sua sintonia';

  @override
  String get rewardRevealBarrierLabel => 'Revelação de recompensa';

  @override
  String get rewardRevealLegendRelicClaimed => 'RELÍQUIA LENDÁRIA REIVINDICADA';

  @override
  String get rewardRevealRelicUnlocked => 'RELÍQUIA DESBLOQUEADA';

  @override
  String get rewardRevealContinue => 'Continuar a missão';

  @override
  String get characterSheetHeaderLabel => 'FICHA DE PERSONAGEM';

  @override
  String get characterSheetStatName => 'Nome';

  @override
  String get characterSheetStatRank => 'Posto';

  @override
  String get characterSheetStatQuests => 'Missões';

  @override
  String characterSheetStatQuestsValue(int completed, int total) {
    return '$completed / $total';
  }

  @override
  String get characterSheetStatRelics => 'Relíquias';

  @override
  String characterSheetStatRelicsValue(int collected, int total) {
    return '$collected / $total';
  }

  @override
  String get characterSheetStatSignal => 'Sinal';

  @override
  String get realmMapCurrentQuest => 'MISSÃO ATUAL';

  @override
  String get questScrollSealed => 'Selada';

  @override
  String get questScrollActive => 'ATIVA';

  @override
  String get questScrollReward => 'RECOMPENSA';

  @override
  String get relicVaultLockedTitle => '???';

  @override
  String get relicVaultLegendRelic => 'Relíquia lendária';

  @override
  String get relicVaultClaimed => 'Reivindicada';

  @override
  String get relicVaultSealed => 'Selada';

  @override
  String get libraryAppBarTitle => 'Biblioteca';

  @override
  String get libraryTabMyBooks => 'Meus Livros';

  @override
  String get libraryTabReadingList => 'Lista de Leitura';

  @override
  String get libraryMyBooksSignInTitle => 'Sua estante te espera';

  @override
  String get libraryMyBooksSignInMessage =>
      'Entre para acessar livros que você comprou, reivindicou ou enviou — prontos para ler aqui mesmo.';

  @override
  String get libraryMyBooksEmptyTitle =>
      'Nenhum livro disponível para leitura ainda';

  @override
  String get libraryMyBooksEmptyMessage =>
      'Livros que você comprar, reivindicar ou enviar aparecerão aqui quando estiverem prontos para ler.';

  @override
  String get libraryReadingListSignInTitle => 'Comece sua lista de leitura';

  @override
  String get libraryReadingListSignInMessage =>
      'Entre para salvar livros do catálogo e montar sua lista de leitura pessoal.';

  @override
  String get libraryReadingListEmptyTitle => 'Nada salvo ainda';

  @override
  String get libraryReadingListEmptyMessage =>
      'Salve livros do catálogo para montar sua lista de leitura.';

  @override
  String get libraryButtonSignIn => 'Entrar';

  @override
  String get libraryRetry => 'Tentar novamente';

  @override
  String readerProgressRead(String progress) {
    return '$progress lido';
  }

  @override
  String get readerHintSwipeToTurn => 'Deslize para virar páginas';

  @override
  String get readerHintOpeningBook => 'Abrindo livro…';

  @override
  String get readerHintTapToHide => 'Toque no centro para ocultar os controles';

  @override
  String get readerTooltipBack => 'Voltar';

  @override
  String get readerTooltipChapters => 'Capítulos';

  @override
  String get readerTooltipReadingSettings => 'Configurações de leitura';

  @override
  String get readerTooltipPreviousPage => 'Página anterior';

  @override
  String get readerButtonPrev => 'Ant.';

  @override
  String get readerTooltipNextPage => 'Próxima página';

  @override
  String get readerButtonNext => 'Próx.';

  @override
  String get readerChaptersTitle => 'Capítulos';

  @override
  String get readerSettingsTitle => 'Configurações de leitura';

  @override
  String get readerSettingsTextSize => 'Tamanho do texto';

  @override
  String get readerTooltipSmallerText => 'Texto menor';

  @override
  String readerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get readerTooltipLargerText => 'Texto maior';

  @override
  String get readerSettingsPageTheme => 'Tema da página';

  @override
  String get readerAppearancePaper => 'Papel';

  @override
  String get readerAppearanceSepia => 'Sépia';

  @override
  String get readerAppearanceNight => 'Noturno';

  @override
  String get eventDetailLoadingBooks => 'Carregando livros...';

  @override
  String eventDetailBookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count livros neste evento',
      one: '1 livro neste evento',
    );
    return '$_temp0';
  }

  @override
  String get eventDetailNoBooksYet => 'Nenhum livro neste evento ainda.';

  @override
  String get creatorDetailNoBooksYet => 'Nenhum livro para mostrar ainda.';

  @override
  String get creatorDetailFavoriteBookLabel => 'Livro favorito: ';

  @override
  String get creatorDetailLovesLabel => 'Adora: ';

  @override
  String creatorDetailBooksBy(String name) {
    return 'Livros de $name';
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
  String get socialLinkWebsite => 'Site';

  @override
  String get userRoleReader => 'Leitor(a)';

  @override
  String get userRoleReaderDescription =>
      'Descubra seu próximo livro favorito de fantasia';

  @override
  String get creatorRoleAuthor => 'Autor(a)';

  @override
  String get creatorRoleInfluencer => 'Influenciador(a)';

  @override
  String get readAccessOwner => 'Seu envio';

  @override
  String get readAccessPurchased => 'Comprado';

  @override
  String get readAccessNone => 'Sem acesso';

  @override
  String get eventStatusLastDay => 'Último dia!';

  @override
  String get eventStatusHappeningNow => 'Acontecendo agora';

  @override
  String get eventStatusStartsToday => 'Começa hoje';

  @override
  String get eventStatusStartsTomorrow => 'Começa amanhã';

  @override
  String eventStatusStartsInDays(int days) {
    return 'Começa em $days dias';
  }

  @override
  String get spiceLevelNone => 'Sem Picância';

  @override
  String get spiceLevelMild => 'Picância Leve';

  @override
  String get spiceLevelMedium => 'Picância Média';

  @override
  String get spiceLevelHot => 'Quente';

  @override
  String get spiceLevelScorching => 'Ardente';

  @override
  String get languageLevelClean => 'Linguagem Limpa';

  @override
  String get languageLevelMild => 'Linguagem Leve';

  @override
  String get languageLevelModerate => 'Linguagem Moderada';

  @override
  String get languageLevelStrong => 'Linguagem Forte';

  @override
  String get homeHeadline => 'Stuff With Fantasy';

  @override
  String get homeTagline => 'Seu companheiro de leitura de fantasia.';

  @override
  String get homeSubtitle =>
      'Descubra, acompanhe e compartilhe os livros de fantasia que você ama.';

  @override
  String get homeChipMaterial3 => 'Material 3';

  @override
  String get homeChipStructuredStarter => 'Modelo estruturado';

  @override
  String get homeChipWidgetTests => 'Testes de widget';

  @override
  String get homeCardWhatIsReadyTitle => 'O que está pronto';

  @override
  String get homeCardWhatIsReadyItem1 =>
      'Um app com identidade visual e temas claro e escuro.';

  @override
  String get homeCardWhatIsReadyItem2 =>
      'Uma base de análise mais rigorosa usando flutter_lints.';

  @override
  String get homeCardWhatIsReadyItem3 =>
      'Um teste de widget para proteger a experiência inicial.';

  @override
  String get homeCardWhereToGoNextTitle => 'Próximos passos';

  @override
  String get homeCardWhereToGoNextItem1 =>
      'Adicione funcionalidades em lib/src por domínio em vez de expandir o main.dart.';

  @override
  String get homeCardWhereToGoNextItem2 =>
      'Substitua assets de placeholder, ícones do launcher e textos de produto.';

  @override
  String get homeCardWhereToGoNextItem3 =>
      'Execute flutter analyze e flutter test conforme adiciona telas.';

  @override
  String get homeGetStarted => 'Começar';

  @override
  String get homeBrowseBooks => 'Explorar Livros';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Fev';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Abr';

  @override
  String get monthMay => 'Mai';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Ago';

  @override
  String get monthSep => 'Set';

  @override
  String get monthOct => 'Out';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dez';

  @override
  String get profileSectionLanguage => 'Idioma';

  @override
  String get languageSystemDefault => 'Padrão do sistema';

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
  String get profileSectionReadingChronicle => 'Crônica de Leitura';

  @override
  String get profileSectionReadingChronicleSubtitle =>
      'Sua jornada pelas páginas, mapeada em tinta.';

  @override
  String get profileSectionTomeCounter => 'Contador de Tomos';

  @override
  String get profileSectionTomeCounterSubtitle =>
      'Seus feitos acumulados de leitura.';

  @override
  String get profileSectionAchievementSigils => 'Sigilos de Conquista';

  @override
  String get profileSectionAchievementSigilsSubtitle =>
      'Marcos forjados pela dedicação.';

  @override
  String chroniclePagesThisWeek(int count) {
    return '~$count páginas esta semana';
  }

  @override
  String chronicleStreak(int count) {
    return 'Sequência de $count dias';
  }

  @override
  String get chronicleLess => 'Menos';

  @override
  String get chronicleMore => 'Mais';

  @override
  String get tomeCounterBooks => 'Tomos Conquistados';

  @override
  String get tomeCounterPages => 'Páginas Viradas';

  @override
  String get tomeCounterTime => 'Tempo no Reino';

  @override
  String tomeCounterHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String tomeCounterMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String get achievementLocked => 'SELADO';

  @override
  String get achievementUnlocked => 'CONQUISTADO';

  @override
  String get achievementFirstPageTitle => 'Primeira Página';

  @override
  String get achievementFirstPageDesc => 'Abra um livro e comece a ler.';

  @override
  String get achievementBookwormTitle => 'Rato de Biblioteca Desperta';

  @override
  String get achievementBookwormDesc => 'Termine seu primeiro livro.';

  @override
  String get achievementDailyRitualTitle => 'Ritual Diário';

  @override
  String get achievementDailyRitualDesc => 'Leia por 3 dias seguidos.';

  @override
  String get achievementPageTurnerTitle => 'Virador de Páginas';

  @override
  String get achievementPageTurnerDesc => 'Leia aproximadamente 100 páginas.';

  @override
  String get achievementHourGlassTitle => 'Ampulheta';

  @override
  String get achievementHourGlassDesc => 'Passe 1 hora lendo.';

  @override
  String get achievementChapterChampionTitle => 'Campeão de Capítulos';

  @override
  String get achievementChapterChampionDesc => 'Termine 3 livros.';

  @override
  String get achievementFlameKeeperTitle => 'Guardião da Chama';

  @override
  String get achievementFlameKeeperDesc => 'Leia por 7 dias seguidos.';

  @override
  String get achievementTomeScholarTitle => 'Erudito dos Tomos';

  @override
  String get achievementTomeScholarDesc =>
      'Leia aproximadamente 1.000 páginas.';

  @override
  String get achievementDevotedReaderTitle => 'Leitor Devotado';

  @override
  String get achievementDevotedReaderDesc => 'Passe 10 horas lendo.';

  @override
  String get achievementFiveRealmsTitle => 'Cinco Reinos';

  @override
  String get achievementFiveRealmsDesc => 'Comece a ler 5 livros diferentes.';

  @override
  String get achievementGrandLibrarianTitle => 'Grande Bibliotecário';

  @override
  String get achievementGrandLibrarianDesc => 'Termine 10 livros.';

  @override
  String get achievementEternalFlameTitle => 'Chama Eterna';

  @override
  String get achievementEternalFlameDesc =>
      'Mantenha uma sequência de leitura de 30 dias.';

  @override
  String get achievementMythicScribeTitle => 'Escriba Mítico';

  @override
  String get achievementMythicScribeDesc => 'Passe 100 horas lendo.';

  @override
  String get achievementRealmWalkerTitle => 'Andarilho dos Reinos';

  @override
  String get achievementRealmWalkerDesc => 'Comece a ler 10 livros diferentes.';

  @override
  String get oathAppBarTitle => 'Pedra do Juramento';

  @override
  String get oathSectionTitle => 'Pedra do Juramento';

  @override
  String get oathSectionSubtitle => 'Seu juramento de leitura';

  @override
  String get oathSwearCta => 'Fazer um Juramento';

  @override
  String get oathSwearSubtitle =>
      'Defina uma meta pública de leitura e acompanhe seu progresso';

  @override
  String get oathSwearPageTitle => 'Inscreva Seu Juramento';

  @override
  String get oathFieldTitle => 'Seu compromisso';

  @override
  String get oathFieldTitleHint => 'Vou ler 24 livros em 2026';

  @override
  String get oathFieldTarget => 'Livros-alvo';

  @override
  String get oathFieldYear => 'Ano';

  @override
  String get oathFieldPublic => 'Juramento público';

  @override
  String get oathFieldPublicSubtitle => 'Visível no Quadro de Saberes';

  @override
  String get oathSwearButton => 'Fazer Este Juramento';

  @override
  String get oathSwearing => 'Inscrevendo...';

  @override
  String oathProgressLabel(int current, int target) {
    return '$current de $target';
  }

  @override
  String get oathProgressComplete => 'Juramento Cumprido!';

  @override
  String get oathEntryLogged => 'Runa gravada!';

  @override
  String get oathEntryRemoved => 'Entrada removida';

  @override
  String get oathDeleteConfirmTitle => 'Quebrar Este Juramento?';

  @override
  String get oathDeleteConfirmBody =>
      'Isso removerá permanentemente seu juramento e todas as entradas registradas.';

  @override
  String get oathDeleteCancel => 'Manter Juramento';

  @override
  String get oathDeleteConfirm => 'Quebrar Juramento';

  @override
  String get oathDeleted => 'Juramento quebrado';

  @override
  String get oathCompleteTitle => 'JURAMENTO CUMPRIDO';

  @override
  String get oathCompleteHeadline => 'Seu Juramento Está Selado';

  @override
  String get oathCompleteBody =>
      'Você honrou seu compromisso. As runas estão completas.';

  @override
  String get oathCompleteContinue => 'Continuar';

  @override
  String get oathEmptyEntries => 'Nenhum livro registrado ainda';

  @override
  String get oathLogBookAction => 'Registrar no Juramento';

  @override
  String oathLogBookConfirm(String title) {
    return 'Registrar \"$title\" no seu juramento?';
  }

  @override
  String get oathLogBookButton => 'Registrar';

  @override
  String get oathAlreadyLogged => 'Já registrado no seu juramento';

  @override
  String get oathEditButton => 'Editar Juramento';

  @override
  String get oathUpdated => 'Juramento atualizado';

  @override
  String get oathErrorCreate => 'Falha ao criar juramento';

  @override
  String get oathErrorLoad => 'Falha ao carregar juramento';

  @override
  String get oathGuestHeadline => 'A Pedra do Juramento Aguarda';

  @override
  String get oathGuestBody =>
      'Crie uma conta para fazer um juramento de leitura e acompanhar seu progresso.';

  @override
  String get seasonalCampaignLabel => 'Campanha Sazonal';

  @override
  String get seasonalCampaignExpired => 'Expedição encerrada';

  @override
  String get seasonalCampaignLastDay => 'Último dia!';

  @override
  String seasonalCampaignCountdownDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias restantes',
      one: '1 dia restante',
    );
    return '$_temp0';
  }

  @override
  String seasonalCampaignCountdownMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months meses restantes',
      one: '1 mês restante',
    );
    return '$_temp0';
  }

  @override
  String seasonalCampaignCountdownMonthsDays(int months, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months meses',
      one: '1 mês',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias restantes',
      one: '1 dia restante',
    );
    return '$_temp0, $_temp1';
  }

  @override
  String get seasonalRelicSectionTitle => 'Relíquias Sazonais';

  @override
  String get profileSectionSeasonalQuests => 'Missões Sazonais';

  @override
  String get profileSectionSeasonalQuestsSubtitle =>
      'Expedições por tempo limitado com relíquias exclusivas.';

  @override
  String get realmRankingsTitle => 'Classificação do Reino';

  @override
  String get leaderboardMetricQuests => 'Missões';

  @override
  String get leaderboardMetricBooks => 'Livros';

  @override
  String get leaderboardMetricRelics => 'Relíquias';

  @override
  String leaderboardTotalParticipants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aventureiros classificados',
      one: '1 aventureiro classificado',
    );
    return '$_temp0';
  }

  @override
  String get leaderboardYourPosition => 'SUA POSIÇÃO';

  @override
  String leaderboardPositionOfTotal(int position, int total) {
    return '#$position de $total';
  }

  @override
  String get leaderboardErrorHeadline => 'A classificação falhou ao carregar';

  @override
  String get leaderboardOptInTitle => 'Classificação do Reino';

  @override
  String get leaderboardOptInDescription =>
      'Compita com outros aventureiros participando do placar do reino. Sua classificação é baseada em missões seladas, livros lidos e relíquias coletadas.';

  @override
  String get leaderboardOptInPrivacy =>
      'Apenas seu nome de exibição e posto são visíveis para outros.';

  @override
  String get leaderboardOptInActive => 'Classificado no reino';

  @override
  String get leaderboardOptInInactive => 'Não classificado';

  @override
  String get leaderboardOptInJoinButton => 'Entrar na Classificação';

  @override
  String get leaderboardOptInLeaveButton => 'Sair da Classificação';

  @override
  String get characterSheetStatRealmRank => 'Reino';

  @override
  String get characterSheetRealmRankJoin => 'Entrar na Classificação';

  @override
  String get skillTreeSectionTitle => 'Árvore de Habilidades';

  @override
  String get skillTreeSectionSubtitle =>
      'Evolua sua maestria em gêneros através da leitura.';

  @override
  String skillTreeXpProgress(int current, int next) {
    return '$current / $next XP';
  }

  @override
  String skillTreeXpLabel(int xp) {
    return '$xp XP';
  }

  @override
  String get skillTreeTiersLabel => 'Níveis';

  @override
  String get skillTreeTierUnlocked => 'DESBLOQUEADO';

  @override
  String get skillTreeTierCurrent => 'EM PROGRESSO';

  @override
  String get skillTreeTierLocked => 'BLOQUEADO';

  @override
  String skillTreeRuneUnlocked(String runeTitle) {
    return 'Runa Desbloqueada: $runeTitle';
  }

  @override
  String skillTreeRuneLockedAt(String runeTitle) {
    return 'Desbloqueia: $runeTitle';
  }

  @override
  String get loreBoardTitle => 'Quadro de Saberes';

  @override
  String get loreBoardGlobalTab => 'Global';

  @override
  String get loreBoardFriendsTab => 'Amigos';

  @override
  String get loreBoardEmpty =>
      'O quadro está vazio... nenhuma história foi publicada ainda.';

  @override
  String get loreBoardTooltip => 'Quadro de Saberes';

  @override
  String get guildHubTitle => 'Salão da Guilda';

  @override
  String get guildHubEmpty =>
      'Você ainda não entrou em nenhuma guilda. Funde a sua ou descubra guildas existentes.';

  @override
  String get guildCreateButton => 'Fundar uma Nova Guilda';

  @override
  String get guildDiscoverButton => 'Descobrir Guildas';

  @override
  String get guildDetailCompanions => 'Companheiros';

  @override
  String get guildDetailLedger => 'Livro-Razão do Grupo';

  @override
  String get guildDetailLedgerEmpty => 'Nenhum livro no livro-razão ainda.';

  @override
  String get guildJoinButton => 'Entrar na Guilda';

  @override
  String get guildJoined => 'Você entrou na guilda!';

  @override
  String get guildLeaveButton => 'Sair da Guilda';

  @override
  String get guildLeft => 'Você saiu da guilda.';

  @override
  String get guildDeleteConfirmTitle => 'Dissolver Esta Guilda?';

  @override
  String get guildDeleteConfirmBody =>
      'Isso removerá permanentemente a guilda e todos os seus dados. Essa ação não pode ser desfeita.';

  @override
  String get guildDeleteCancel => 'Manter Guilda';

  @override
  String get guildDeleteConfirm => 'Dissolver Guilda';

  @override
  String get guildDeleted => 'Guilda dissolvida';

  @override
  String get guildCreated => 'Guilda fundada!';

  @override
  String get guildUpdated => 'Guilda atualizada';

  @override
  String get guildCreatePageTitle => 'Fundar uma Guilda';

  @override
  String get guildFieldName => 'Nome da Guilda';

  @override
  String get guildFieldNameHint => 'A Irmandade das Páginas';

  @override
  String get guildFieldDescription => 'Descrição';

  @override
  String get guildFieldDescriptionHint => 'Sobre o que é a sua guilda?';

  @override
  String get guildFieldPublic => 'Guilda pública';

  @override
  String get guildFieldPublicSubtitle =>
      'Visível no Quadro de Guildas para qualquer pessoa entrar';

  @override
  String get guildCreateSubmit => 'Fundar Esta Guilda';

  @override
  String get guildCreating => 'Fundando...';

  @override
  String get guildDiscoverTitle => 'Quadro de Guildas';

  @override
  String get guildDiscoverEmpty => 'Nenhuma guilda para descobrir ainda.';

  @override
  String guildMemberCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count companheiros',
      one: '1 companheiro',
    );
    return '$_temp0';
  }

  @override
  String get guildRoleGuildmaster => 'Mestre da Guilda';

  @override
  String get guildRoleCompanion => 'Companheiro';

  @override
  String get guildGuestHeadline => 'O Salão da Guilda Aguarda';

  @override
  String get guildGuestBody =>
      'Crie uma conta para fundar guildas, participar de grupos de leitura e montar livros-razão com outros aventureiros.';

  @override
  String get guildAddToLedger => 'Adicionar ao Livro-Razão';

  @override
  String get guildBookAdded => 'Livro adicionado ao livro-razão!';

  @override
  String get guildBookRemoved => 'Livro removido do livro-razão.';

  @override
  String get guildAlreadyMember => 'Você já é membro desta guilda.';
}
