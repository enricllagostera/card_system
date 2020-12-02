# card_system log

Reverse chronological notes about the development of this project.

## Entries

### 2020-11-22

Started the log.

I'm experimenting with automated testing for my programming in this project. I've recently read some books and materials on unit and integration tests, and I want to experiment with this practice. The main reason is that I feel like I've done so much programming in the past that could not be really re-used in more than one project, for both plain technical debt or failing architectures. I think testing will help with making my systems be more re-usable: using smaller units, more readable, easier to make sense of.

I'm trying out a plugin for Godot called [Gut](https://github.com/bitwes/Gut/) that facilitates running unit and integration tests. It has lots of features, and I like how it also has a VSCode extension to make running the tests easier. There are still many features I haven't used in it yet, so this is an opportunity for me to get used with doubles, stubs, and integration tests.

### 2020-11-23

Acho que vou precisar de uma função de embaralhar (`shuffle`) as cartas de um deck. Uma consequência de pensar isso é que provavelmente vou precisa de algum jeito para garantir que não tem cartas duplicadas. Uma coisa é duas cartas terem conteúdos iguais, outra é serem a mesma instância. Acho que vou começar por isso.

Ok, acho que está feito. Foi meio complicado estar a repetição ou não da ordem criada, mas isso foi mais por minha falta de familiaridade com o RNG de Godot. Agora é possível embaralhar um deck usando uma seed para tornar a embaralhada repetível. Essa é uma funcionalidade que pode ajudar com saves e desafios gerados por algoritmos.

### 2020-11-25

Vou trabalhar num sistema de referenciar cartas por IDs únicos. A ideia é usar esses IDs para conectar os nós com dicionários que guardam o estado e informações atualizadas da carta. Com isso, os dados ficam razoavelmente desconectados do nó em si, facilitando seu gerenciamento. Isso é necessário no caso de deletar instâncias de nós de cartas, mas mantendo a carta lógica. Isso também facilitaria salvar e carregar estados do jogo.

Por padrão, essa é apenas uma camada de abstração em cima do `get_instance_id()` de objetos em GDScript. Não são feitas outras checagens para garantir que os IDs são únicos.

#### Importar dados de arquivos externos

Outra coisa que vou experimentar agora é com carregar informações para cartas a partir de arquivos externos. Para isso, a ideia básica é:

1. Criar uma cena herdada de `Card`;
2. Adicionar uma `Label` para texto;
3. Carregar um dicionário de um arquivo JSON;
4. Usar o dicionário para inicializar um conjunto de cartas em um deck;

(...) Funcionou bem fazer isso (até o 3o item). Fiz uma carta que carregava um texto para um `Label` de um arquivo JSON com apenas um campo nele. Agora acho que seria o caso de criar um banco de dados de cartas, ao invés de um arquivo por carta.

(...) Acabei preparando uma classe específica para bancos de cartas (`CardDb`), que carrega um dicionário com as informações. Por enquanto só tem a função de carregar do arquivo, mas que trata erros corretamente.

### 2020-12-02

Tenho feito um protótipo do jogo dos disquetes, usando o sistema, e estou encontrando algumas limitações de usar ele. Uma coisa que quero mudar é que estou usando relações de pai -> filho para representar onde uma carta está e isso simplesmente não funciona bem. A ideia é mudar isso para um componente mais simples, que pode ser contido em decks, holders e outros nós. Com isso ficaria um pouco mais simples lidar com adicionar / remover e checar capacidade. Atualmente isso acaba sendo duplicado em vários lugares.
