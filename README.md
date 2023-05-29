# mips-suffering

An implementation of the classic Tic Tac Toe with an computer component - I'm not even done yet and I'm already in pain... but, I will learn plenty at the end.

THINGS I NEED TO CHANGE:

- The board state should be stored as words rather than bytes - I've run into issue of essentially trying to "cram" a word (produced by syscall 5) into a byte which is not supported by mipsy (and probably not by the real MIPS32 either) which means that I have to change to the data structure which stores the board state and bite the bullet of making it 4 times bigger... oh no... how will my 8 GB of RAM survive going from 9 bytes to 36 bytes...
