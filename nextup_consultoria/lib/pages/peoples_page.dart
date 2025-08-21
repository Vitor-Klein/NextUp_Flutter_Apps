import 'package:flutter/material.dart';

class PeoplesPage extends StatelessWidget {
  const PeoplesPage({super.key});

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

    return Scaffold(
      appBar: AppBar(title: const Text("Peoples")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: people.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final person = people[index];
            return _PersonCard(
              person: person,
              onTap: () => _openPersonModal(context, person),
            );
          },
        ),
      ),
    );
  }

  void _openPersonModal(BuildContext context, Person person) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    person.photo,
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  person.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  person.role,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
                const Divider(height: 30),
                Text(
                  person.bio,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PersonCard extends StatelessWidget {
  final Person person;
  final VoidCallback onTap;

  const _PersonCard({required this.person, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                person.photo,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              person.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              person.role,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
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
