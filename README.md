RISC-V Space Invaders

A simplified Space Invaders game implemented in RISC-V Assembly for the RARS emulator.

About

This project was developed as part of the Computer Architecture course at the University of Strasbourg.

The game uses a memory-mapped bitmap display and keyboard input to implement a simple 2D Space Invaders game.

Features:
Player movement and shooting
Moving alien invaders
Enemy projectiles
Obstacles
Collision detection
Player lives
Game-over conditions
Bitmap-based graphics
Double buffering for smoother animation

Technical Details:
Language: RISC-V Assembly
Emulator: RARS 1.6
Input: Memory-mapped keyboard
Graphics: Memory-mapped bitmap display
Architecture concepts: memory management, registers, procedures, stack management, and low-level I/O
Project Structure

The project was developed incrementally through several stages:

Timing and delays
Keyboard input
Bitmap graphics and image manipulation
Game object data structures
Object movement
Collision detection and complete game logic
Running

Open the projet_final.s file in RARS 1.6 and run the program.

The game requires the RARS Keyboard and Display MMIO Simulator and Bitmap Display tools.

Course

Computer Architecture — Licence 2 Informatique
Université de Strasbourg
