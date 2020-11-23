# Log

Reverse chronological notes about the development of this project.

## Entries

### 2020-11-22

Started the log.

### 2020-11-23

Acho que vou precisar de uma função de embaralhar (`shuffle`) as cartas de um deck. Uma consequência de pensar isso é que provavelmente vou precisa de algum jeito para garantir que não tem cartas duplicadas. Uma coisa é duas cartas terem conteúdos iguais, outra é serem a mesma instância. Acho que vou começar por isso.

Ok, acho que está feito. Foi meio complicado estar a repetição ou não da ordem criada, mas isso foi mais por minha falta de familiaridade com o RNG de Godot. Agora é possível embaralhar um deck usando uma seed para tornar a embaralhada repetível. Essa é uma funcionalidade que pode ajudar com saves e desafios gerados por algoritmos.
