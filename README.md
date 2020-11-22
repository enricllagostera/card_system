# card_system

This a game that contains a reusable system, entirely contained within the `card_system` folder, for making other card-based games. The focus right now is on cards that can be dragged, which I'll use on a deck-building game.

Some thoughts on the general approach are below, and there's also [a log here](docs/log.md).

---

## Current design

TBD.

## Dev approach

### Testing

I'm experimenting with automated testing for my programming. I've recently read some books and materials on unit and integration tests, and I want to experiment with this practice. The main reason is that I feel like I've done so much programming in the past that could not be really re-used in more than one project, for both plain technical debt or failing architectures. I think testing will help with making my systems be more re-usable: using smaller units, more readable, easier to make sense of.

I'm trying out a plugin for Godot called [Gut](https://github.com/bitwes/Gut/) that facilitates running unit and integration tests. It has lots of features, and I like how it also has a VSCode extension to make running the tests easier. There are still many features I haven't used in it yet, so this is an opportunity for me to get used with doubles, stubs, and integration tests.
