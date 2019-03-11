# balancegame

This is a balance game written in MATLAB that is controlled by a microBit attached to a balance board.

The game was built with the [Simulink Coder Support Package for the micro:bit](https://www.mathworks.com/matlabcentral/fileexchange/60273-simulink-coder-support-package-for-bbc-micro-bit-board).

It should be fairly easy to update the game to use the Arduino instead.

Here's an example screen shot of the game:

![Alt text](game.png?raw=true "Screen shot")

The micro:bit and balance board control the orange rectangle at the bottom of the screen. Move the balance board to make sure the orange rectangle avoids the white rectangles.

As soon as the orange rectangle collides with a white rectangle, the game is over and the time (shown in the upper left is captured). If the time is one of the top ten recorded times, it's displayed on the record board.

The record board is shown for 10 seconds before the next game automatically starts.
