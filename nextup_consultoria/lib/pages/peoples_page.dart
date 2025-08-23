import 'package:flutter/material.dart';

class PeoplesPage extends StatefulWidget {
  const PeoplesPage({super.key});

  @override
  State<PeoplesPage> createState() => _PeoplesPageState();
}

class _PeoplesPageState extends State<PeoplesPage> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    // Dispara as animações de entrada após o primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final people = <Person>[
      Person(
        name: "Carlos Alexandre",
        role: "Desenvolvedor Full-Stack",
        photo: "assets/carlos.jpg",
        bio:
            "Desenvolvedor de Software com atuação full-stack, o qual utiliza tecnologias como Angular, Flutter, Node.js, SQL e NoSQL na criação de soluções modernas e práticas.\n\n"
            "Gosta de enfrentar novos desafios e aprender com eles, enriquecendo sua capacidade técnica e criativa. Considera a satisfação e a experiência do usuário como aspectos fundamentais do desenvolvimento.",
      ),
      Person(
        name: "Izabela Araujo",
        role: "Inovação e Captação de Recursos",
        photo: "assets/izabela.png",
        bio:
            "Consultora em Pesquisa, Desenvolvimento e Inovação. Especialista nas áreas de agronegócios, segurança do trabalho, energias renováveis e saneamento ambiental. "
            "Busco entender as demandas das pessoas e empresas e converter em projetos. "
            "Sou alguém que une propósito e ação: transformo desafios em oportunidades por meio de planejamento estratégico, conteúdos de capacitação e iniciativas que geram valor para pessoas e instituições.",
      ),
      Person(
        name: "Jean Rizk",
        role: "Gerente de Projetos",
        photo: "assets/jean.jpg",
        bio:
            "Gerente de projetos com atuação em iniciativas internacionais e nacionais, especializado em Compliance, LGPD, Investigações, SaaS, Desenvolvimento de Aplicativos Mobile e Inteligência Artificial.\n\n"
            "Possui sólida experiência na liderança de equipes multidisciplinares internacionais e na entrega de soluções tecnológicas alinhadas às normas regulatórias e às melhores práticas de governança.",
      ),
      Person(
        name: "Jian Licio de Oliveira",
        role: "Desenvolvedor de Soluções Digitais",
        photo: "assets/jian.jpg",
        bio:
            "Desenvolvedor que gosta de criar soluções práticas e bem feitas. "
            "Transforma ideias em aplicações que realmente funcionam e facilitam o dia a dia. "
            "Sempre busca melhorar o que já existe e colaborar para que os projetos saiam do papel de forma simples e eficiente.",
      ),
      Person(
        name: "Murilo Carvalho",
        role: "Desenvolvedor Full-Stack",
        photo: "assets/murilo.jpg",
        bio:
            "Desenvolvedor com experiência e dedicação em tecnologias como C#, .NET, Node.js, SQL e Flutter, atuando no desenvolvimento e manutenção de aplicativos, sistemas e soluções inovadoras.\n\n"
            "Busca estar em constante crescimento profissional, aplicando seus conhecimentos de forma prática e eficiente, sempre priorizando a experiência do usuário e atendendo às suas necessidades em cada projeto.",
      ),
      Person(
        name: "Vitor Klein",
        role: "Desenvolvedor Full-Stack",
        photo: "assets/vitor.png",
        bio:
            "Desenvolvedor com foco e grande conhecimento em tecnologias como ReactJs, ReactNative, NodeJs, SQL e Flutter para a criação ou manutenção de aplicativos, sites e soluções modernas.\n\n"
            "Procura estar em constante evolução e aprendizado, sempre aplicando seu conhecimento de maneira prática e útil no trabalho, sempre focando na experiência final do usuário e se preocupando com suas dores e necessidades em cada aplicação.",
      ),
    ];

    final theme = Theme.of(context);
    final bg = theme.colorScheme.surface;
    final onBg = theme.colorScheme.onSurface.withOpacity(0.8);
    final accent = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text("Nosso Time"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: people.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.86,
          ),
          itemBuilder: (context, index) {
            final person = people[index];
            final duration = Duration(milliseconds: 320 + index * 60);

            return AnimatedOpacity(
              duration: duration,
              opacity: _ready ? 1 : 0,
              curve: Curves.easeOut,
              child: AnimatedSlide(
                duration: duration,
                curve: Curves.easeOutCubic,
                offset: _ready ? Offset.zero : const Offset(0, .08),
                child: _PersonCard(
                  person: person,
                  accent: accent,
                  onTap: () => _openPersonModal(context, person),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openPersonModal(BuildContext context, Person person) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'Detalhes',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) {
        final theme = Theme.of(context);
        final cardColor = theme.colorScheme.surface;
        final textColor = theme.colorScheme.onSurface;

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 520),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 24,
                    spreadRadius: 0,
                    color: Colors.black.withOpacity(0.12),
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Hero(
                      tag: 'avatar-${person.photo}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(72),
                        child: Image.asset(
                          person.photo,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      person.name,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _RoleChip(role: person.role),
                    const SizedBox(height: 16),
                    const Divider(height: 24),
                    Text(
                      person.bio,
                      textAlign: TextAlign.justify,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Fechar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: .96,
              end: 1,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          ),
        );
      },
    );
  }
}

class _PersonCard extends StatefulWidget {
  final Person person;
  final VoidCallback onTap;
  final Color accent;

  const _PersonCard({
    required this.person,
    required this.onTap,
    required this.accent,
  });

  @override
  State<_PersonCard> createState() => _PersonCardState();
}

class _PersonCardState extends State<_PersonCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 180),
      tween: Tween(begin: 1, end: _pressed ? 0.97 : 1),
      builder: (_, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: InkWell(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'avatar-${widget.person.photo}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(48),
                  child: Image.asset(
                    widget.person.photo,
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.person.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.person.role,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary.withOpacity(.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String role;
  const _RoleChip({required this.role});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.primary.withOpacity(.08);
    final fg = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        role,
        style: theme.textTheme.labelMedium?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          letterSpacing: .2,
        ),
      ),
    );
  }
}

class Person {
  final String name;
  final String role;
  final String photo;
  final String bio;

  Person({
    required this.name,
    required this.role,
    required this.photo,
    required this.bio,
  });
}
