import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/guild/data/guild_repository.dart';
import 'package:swf_app/src/guild/models/guild.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// "Found a Guild" — form to create a new guild.
///
/// Returns the created [Guild] via [Navigator.pop] on success.
class CreateGuildPage extends StatefulWidget {
  const CreateGuildPage({super.key});

  @override
  State<CreateGuildPage> createState() => _CreateGuildPageState();
}

class _CreateGuildPageState extends State<CreateGuildPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPublic = true;
  bool _isSubmitting = false;

  late final GuildRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = ServiceLocator.guildRepository;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final result = await _repo.createGuild(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      isPublic: _isPublic,
    );

    if (!mounted) return;

    result.when(
      success: (guild) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.guildCreated)),
        );
        Navigator.pop(context, guild);
      },
      failure: (message, _) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    const accent = SwfColors.secondaryAccent;

    return Scaffold(
      backgroundColor: SwfColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          l10n.guildCreatePageTitle,
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name field
              Text(
                l10n.guildFieldName,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: accent,
                  letterSpacing: 1.0,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: l10n.guildFieldNameHint,
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withAlpha(60),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A2235),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withAlpha(20)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withAlpha(20)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accent.withAlpha(120)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.guildFieldName;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Description field
              Text(
                l10n.guildFieldDescription,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: accent,
                  letterSpacing: 1.0,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: l10n.guildFieldDescriptionHint,
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withAlpha(60),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A2235),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withAlpha(20)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withAlpha(20)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accent.withAlpha(120)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Public toggle
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2235),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withAlpha(20)),
                ),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.guildFieldPublic,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    l10n.guildFieldPublicSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withAlpha(120),
                    ),
                  ),
                  value: _isPublic,
                  activeTrackColor: accent.withAlpha(120),
                  thumbColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? accent
                        : Colors.white.withAlpha(180),
                  ),
                  onChanged: (value) => setState(() => _isPublic = value),
                ),
              ),

              const SizedBox(height: 36),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: Text(
                    _isSubmitting ? l10n.guildCreating : l10n.guildCreateSubmit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
