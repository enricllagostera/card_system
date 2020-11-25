# Log

Reverse chronological notes about the development of this project.

## Entries

### 2020-11-22

Started the log.

### 2020-11-23

Acho que vou precisar de uma função de embaralhar (`shuffle`) as cartas de um deck. Uma consequência de pensar isso é que provavelmente vou precisa de algum jeito para garantir que não tem cartas duplicadas. Uma coisa é duas cartas terem conteúdos iguais, outra é serem a mesma instância. Acho que vou começar por isso.

Ok, acho que está feito. Foi meio complicado estar a repetição ou não da ordem criada, mas isso foi mais por minha falta de familiaridade com o RNG de Godot. Agora é possível embaralhar um deck usando uma seed para tornar a embaralhada repetível. Essa é uma funcionalidade que pode ajudar com saves e desafios gerados por algoritmos.

### 2020-11-25

Vou trabalhar num sistema de referenciar cartas por IDs únicos. A ideia é usar esses IDs para conectar os nós com dicionários que guardam o estado e informações atualizadas da carta. Com isso, os dados ficam razoavelmente desconectados do nó em si, facilitando seu gerenciamento. Isso é necessário no caso de deletar instâncias de nós de cartas, mas mantendo a carta lógica. Isso também facilitaria salvar e carregar estados do jogo.

Por padrão, essa é apenas uma camada de abstração em cima do `get_instance_id()` de objetos em GDScript. Não são feitas outras checagens para garantir que os IDs são únicos.
