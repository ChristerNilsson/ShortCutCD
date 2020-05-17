# Shortcut

- A simple mathematical twelve person game.
- The object is to make your number equal to the target below.
- Every operation costs ten seconds.

## Usage

- Left letter selects
- Right letter executes
- Up Arrow makes it harder
- Down Arrow makes it easier

## Tree
```
+2 *2 /2
7    Start {7:0}
9    14                                1 operation   {7:0, 9:7, 14:7}
11    18         16        28 (7)      2 operationer {7:0, 9:7, 14:7, 11:9, 18:9, 16:14, 28:14}
13 22 20 36 (9) (18) 32 8 30 56 (14)   3 operationer {7:0, 9:7, 14:7, 11:9, 18:9, 16:14, 28:14, 13:11, 22:11, 20:18, 36:16, 32:16, 8:16, 30:28, 56:28}
```

## URL
```
ShortcutCD/index.html?ADD=2&MUL=3&DIV=4&MAX=20&COST=5&PLAYERS=7
```