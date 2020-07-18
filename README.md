# Demo
https://guava-inn-20.herokuapp.com/


# Novas gems instaladas
1. factory_bot_rails: usada para facilitar a criação e manutenção nos testes, facilitando criar objetos;

1. database_cleaner: usada para facilitar os testes, apagando o banco de dados a cada teste;

1. ffaker: usada para integrar ao factory_bot_rails e facilitar a criação de objetos;

1. pry-rails: usada para facilitar a busca de bugs na aplicação;

1. rubocop-rails e rubocop-performance: usada para garantir o uso de boas práticas no código;

1. dotenv-rails: usada para armazenar as variáveis de ambiente;

1. simple_form: usada para facilitar a criação de formulários;

1. will_paginate: usada para realizar a paginação dos objetos;


# README

Bem-vindo ao teste de back-end da Guava. A aplicação deste repositório simula um sistema de gerenciamento de reservas para uma pequena pousada. Assuma que o sistema tem apenas um usuário: o funcionário que administra a pousada. O teste consiste em implementar correções e melhorias nesta aplicação, descritas pelas duas estórias de usuário a seguir.

## Software necessário

- Ruby 2.7.1
- PostgreSQL 11 ou superior
- [Yarn](https://yarnpkg.com/en/docs/install)
- [ChromeDriver](https://github.com/SeleniumHQ/selenium/wiki/ChromeDriver)

## Instruções de execução

Para fazer o setup geral do projeto (incluindo a criação de _seeds_):

```
$ bin/setup
```

Para executar os testes:

```
$ bundle exec rspec
```

Para executar o servidor:

```
$ bundle exec rails server
```

Para saber mais sobre outros comandos de Rails, consulte o guia [_Getting Started with Rails_](https://guides.rubyonrails.org/getting_started.html).

## Estória 1: Considerar capacidade e disponibilidade na busca por quartos e criação de reservas

Atualmente, na página _New Reservation_, a busca por quartos para criação de uma nova reserva mostra uma lista com todos os quartos, mesmo os que têm uma capacidade inferior à quantidade de hóspedes informada ou os que já estão ocupados nas datas solicitadas. O sistema deve trazer como resultado da busca apenas os quartos com capacidade igual ou superior à quantidade de hóspedes solicitada e que também estejam disponíveis por todo o período informado.

### Observações e cenários alternativos

- Caso não existam quartos disponíveis no período solicitado e com a capacidade informada, o sistema deve mostrar a mensagem _There are no available rooms for the selected filters_.
- A data de início da reserva deve sempre ser anterior à data final. O sistema não deve permitir que uma reserva com data de início posterior ou igual à data final seja criada.
- O sistema não deve permitir criar uma nova reserva com uma quantidade de hóspedes superior à capacidade do quarto ou para um período no qual o quarto já esteja ocupado, mesmo que parcialmente.
- Considere que as diárias começam e terminam ao meio-dia. Por exemplo: considerando que um quarto tem uma reserva de 02/08 a 04/08/2020, deve ser possível criar outra reserva começando em 04/08/2020 ou terminando em 02/08/2020, mas não deve ser possível, por exemplo, criar uma reserva de 01/08 a 03/08/2020.

## Estória 2: Calcular taxas de ocupação mensal e semanal, global e por quarto

A aplicação mostra atualmente valores estáticos para as taxas de ocupação globais e por quarto (50% para a taxa semanal e 25% para a taxa mensal). O sistema deve calcular estes valores e exibi-los corretamente tanto na listagem geral dos quartos (nas caixas da seção _Global Occupation_ e na tabela que lista os quartos) como também na página de detalhamento de cada quarto (página _Room ###_). A taxa de ocupação de um quarto é calculada dividindo a quantidade de dias em que o quarto está ocupado pela quantidade de dias do período total. Por exemplo: se o quarto está 4 dias ocupados nos próximos 7 dias, a taxa de ocupação semanal do quarto é 4/7 = 57%. A taxa de ocupação mensal de um quarto é calculada de forma equivalente, considerando os próximos 30 dias. A taxa de ocupação global é a média da taxa de ocupação de todos os quartos no respectivo período.

### Observações e cenários alternativos

- A taxa de ocupação semanal sempre leva em consideração os sete dias seguintes (ao invés de uma semana fechada), começando sempre no dia seguinte à data corrente. Por exemplo: se hoje é 15/01, a taxa de ocupação semanal vai levar em consideração o período entre 16/01 a 22/01.
- A taxa de ocupação mensal sempre leva em consideração os trinta dias seguintes (ao invés de um mês fechado), começando sempre no dia seguinte à data corrente. Por exemplo: se hoje é 15/01, a taxa de ocupação mensal vai levar em consideração o período entre 16/01 a 14/02.
- Caso a taxa de ocupação seja fracionária, deve ser exibida como o número inteiro mais próximo.
- Considere que as diárias começam e terminam ao meio-dia. Por exemplo: uma reserva de 01/08 a 05/08/2020 tem duração de 4 dias.

## Prazo
De 13/07 a 27/07/2020.

## Observações

- Este é um teste não trivial e, portanto, tem várias soluções possíveis. Seja criativo e procure seguir as boas práticas de Ruby, Rails e de código no geral.
- A implementação dos requisitos descritos nas estórias deve vir acompanhada de testes automatizados de unidade. Testes de integração são opcionais, mas serão considerados na avaliação.
- Fique à vontade para alterar a arquitetura geral do sistema, a estrutura de modelos e controladores ou adicionar novas gems ao projeto se achar necessário.
- Não é obrigatório fazer deploy da aplicação, mas caso a aplicação seja disponibilizada on-line, isso será levado em consideração.
- Você é livre para implementar melhorias fora do escopo das estórias, mas antes certifique-se de ter concluído todos os requisitos solicitados.
- O código deve ser disponibilizado em um repositório Git, que pode estar on-line no Github ou Bitbucket ou ser enviado por e-mail como um arquivo comprimido (zip ou tgz).
- Se você quiser usar _Pull Requests_, lembre-se de fazer um _fork_ do projeto e enviar os PRs para ele ao invés de mandar pro repositório original.
- Você pode adicionar notas de implementação ou documentar decisões tomadas ao longo do projeto aqui no README. Qualquer informação que nos ajude na avaliação é bem-vinda.
- Esteja preparado para discutir as soluções e aspectos do código posteriormente com a gente.
- Em caso de dúvida, é só perguntar por e-mail que a gente responde em até dois dias úteis.
